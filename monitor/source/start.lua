system.print("unit start")

selfData = json.decode(self.getData())
system.print("Board '" .. selfData.name .. "' ON!")

function storeStatus(slotId)
    --system.print("Slot:"..slotId)
    
    local slot = self["slot"..slotId]
    if not slot or not slot.getStatus then return end
    
    local elementId = slot.getId();
    if elementId == nil then return end
    
    local key = tostring(elementId) 
    local value = slot.getStatus()
    if data.hasKey(key) and value==data.getStringValue(key) then return end
    
    data.setStringValue(key, value)
    --system.print("Set "..key.."="..value)
    data.setIntValue("updated", 1)
end


function searchForDataSlot()
    if (data) then return end
    for i=1,10 do
        local slot = self["slot"..i]
        if slot and slot.setStringValue then
            system.print("Found databank on slot"..i)
            data = slot
            return
        end
    end
end

function queryAllSlots()

    --data.clear()

    for i=1,10 do
        storeStatus(i)
    end
end

searchForDataSlot()
if (not data) then
    system.print("Databank not connected to data slot!")
    self.exit()
    return
end

queryAllSlots()