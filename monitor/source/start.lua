
function slotValid(slot)
    return slot 
    and type(slot) == "table"
    and type(slot.export) == "table"
    and slot.getElementClass
end

function onStatusChanged(slot)
    --system.print(slot.getId().." status=> "..slot.getStatus())
    storeStatus(slot)
end

function storeStatus(slot)
    if not slotValid(slot) or not slot.getStatus then return end
    
    local elementId = slot.getId();
    if elementId == nil then return end
    --system.print("ElementId:"..elementId)
    
    local info = {
       id = elementId,
       status = slot.getStatus(),
       cyclesCount = slot.getCycleCountSinceStartup(),
       efficiency = slot.getEfficiency(),
       uptime = slot.getUptime(),
       source = self.getId(),
       updated = 1
    }
    databank.setStringValue(tostring(elementId), json.encode(info))
end


function searchForDataSlot()
    for _, slot in pairs(unit) do        
        if slotValid(slot)  then
            if slot.getElementClass():lower() == 'databankunit' then
                databank = slot
                return
            end
        end
    end
end

function queryAllSlots()
    for _, slot in pairs(unit) do
        storeStatus(slot)
    end
end

function onStop()
    --system.print("Board ["..self.getId().."] OFF")
end

--system.print("Board ["..self.getId().."] ON")
unit.hide()

databank = nil
searchForDataSlot()
if not databank then
    system.print("Databank not connected to monitor board! "..self.getId())
    self.exit()
    return
end

queryAllSlots()