function debug(id, text)
    if id~=debugId then return end
    system.print("REP#"..self.getId().." "..text)
end

function slotValid(slot)
    return slot 
    and type(slot) == "table"
    and type(slot.export) == "table"
    and slot.getElementClass
end

function queryRemotesForChanges()

    function queryRemote(id, remote)
        --system.print("Query Remote Databank #"..id)
        if not slotValid(remote) or not remote.hasKey then
            --system.print("Skipping (invalid slot)")
            return 
        end            
        if remote.getIntValue("updated")==0 then
            --system.print("Skipping (databank unchanged)")
            return 
        end

        --system.print("Remote Databank "..id.." has updates")

        function processKey(key, remote)
            local industryId =  tonumber(string.match(key, "(%d+)_updated"))
            if not industryId then return end
            local updated = remote.getIntValue(key)
            if updated~=1 then return end
            debug(industryId, "Industry Unit #"..industryId.." has updates")
            local infoJson = remote.getStringValue(industryId)
            if infoJson==nil or infoJson=="" then
                debug(industryId, "Skipping #"..industryId.." (data missing)")
                return
            end
            if not dataUpdates[remote] then dataUpdates[remote] = {} end
            dataUpdates[remote][industryId] = infoJson
            debug(industryId, "Set info for update")
        end

        local keyJson = remote.getKeys()
        if keyJson==nil or keyJson=="" then return end
        local keys = json.decode(keyJson)
        for _,key in ipairs(keys) do
            --system.print("Checking key "..key)
            processKey(key, remote)
        end
    end

    for id, remote in pairs(remoteDatabanks) do
        queryRemote(id, remote)
    end
end


function processDataUpdates()
    if not masterDatabank then return end
    --system.print("Tick WriteData")
    local maxToProcess = throttle
    for remote, remoteUpdates in pairs(dataUpdates) do
        --system.print("Updates for Remote #"..remote.getId())
        for key, info in pairs(remoteUpdates) do
            --system.print("Writing data for "..key.." from remote #"..remote.getId())
            maxToProcess = maxToProcess - 1
            if maxToProcess==0 then 
                system.print("Throttle data")
                return
            end
            debug(key, "Writing data for "..key.." from remote #"..remote.getId().." to master #"..masterDatabank.getId())
            masterDatabank.setStringValue(key, info)
            masterDatabank.setIntValue(key.."_updated", 1)
            remote.setIntValue(key.."_updated", 0)
            dataUpdates[remote][key] = nil
        end
        if next(dataUpdates[remote]) == nil then
            system.print("All done for Remote #"..remote.getId())
            masterDatabank.setIntValue("updated", 1)
            remote.setIntValue("updated", 0)
            dataUpdates[remote] = nil
        end
    end
    --if next(dataUpdates) == nil then databank.setIntValue("updated", 0) end
end

function processTick()   
    --system.print("Tick Live")
    --local ok, msg = xpcall(function ()

        if not masterDatabank then return end
        queryRemotesForChanges()

    --end, traceback)

    --if not ok then
    --  system.print(msg)
    --end
end

function onStop()
    system.print("Board ["..self.getId().."] OFF")
end

function processFirst()
    --system.print("Tick First")
    unit.stopTimer("First")
    for slotName, slot in pairs(unit) do
        if slotValid(slot) and slot.getElementClass():lower() == 'databankunit' then
            if slot.getIntValue("master")==1 then
                if masterDatabank then
                    system.print("Warning! Unexpected master databank found in slot "..slotName)
                else
                    --system.print("Found master databank in slot "..slotName)
                    masterDatabank = slot
                    debugId = masterDatabank.getIntValue("debugId")
                    if debugId > 0 then system.print("Debugging #"..debugId) end
                    throttle = masterDatabank.getIntValue("throttle")
                    if not throttle then throttle = 25 end
                end
            else
                --system.print("Found remote databank in slot "..slotName)
                remoteDatabanks[slot.getId()] = slot
            end
        end
    end

    if not masterDatabank then
        system.print("Master Databank not connected to relay board! #"..self.getId())
        self.exit()
        return
    end

    for _, remote in pairs(remoteDatabanks) do
        remote.setIntValue("debugId", debugId)
    end
end


system.print("Board ["..self.getId().."] ON")
throttle = 25
debugId = 0
unit.hide()

masterDatabank = nil
remoteDatabanks = {} 
dataUpdates = {} 

unit.setTimer("First", 1)
unit.setTimer("Live", 7)
unit.setTimer("WriteData", 3)