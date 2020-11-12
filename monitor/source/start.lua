
function slotValid(slot)
    return slot 
    and type(slot) == "table"
    and type(slot.export) == "table"
    and slot.getElementClass
end

function onStatusChanged(slot)
    --system.print(slot.getId().." status=> "..slot.getStatus())
    storeStatus(slot)
    databank.setIntValue("updated", 1)
end

function storeStatus(slot)
    if not slotValid(slot) or not slot.getStatus then return end
    
    local id = slot.getId();
    if not id then return end
    --system.print("Unit id:"..id)
    
    local info = {
       id = id,
       status = slot.getStatus(),
       cyclesCount = slot.getCycleCountSinceStartup(),
       efficiency = slot.getEfficiency(),
       uptime = slot.getUptime(),
       source = self.getId(),
    }
    databank.setIntValue(tostring(id).."_updated",1)
    databank.setStringValue(tostring(id), json.encode(info))
end


function searchForDataSlot()
    for _, slot in pairs(unit) do        
        if slotValid(slot) and slot.getElementClass():lower() == 'databankunit' then
            databank = slot
            return
        end
    end
end

function queryAllSlots()
    for _, slot in pairs(unit) do
        storeStatus(slot)
    end
    databank.setIntValue("updated", 1)
end

function onStop()
    --system.print("Board ["..self.getId().."] OFF")
end

function onStart()
    searchForDataSlot()
end

--system.print("Board ["..self.getId().."] ON")
unit.hide()

databank = nil
onStart()
if not databank then
    system.print("Databank not connected to monitor board! "..self.getId())
    self.exit()
    return
end

queryAllSlots()