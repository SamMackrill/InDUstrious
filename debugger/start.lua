function queryElement(id)
    if not core then return end
    system.print(id.." in core")
    local name = core.getElementNameById(id)
    if not name then
        system.print("  Not Found")
    end
    system.print("  Name="..name.." Type="..core.getElementTypeById(id))      
    system.print("  HP="..core.getElementMaxHitPointsById(id).." Mass="..core.getElementMassById(id))
end

function queryAllElements()
    elementsIds = core.getElementIdList()
    for _,id in ipairs(elementsIds) do    
        queryElement(id)
    end   
end

function dumpKeyValue(key)

    if key == "updated" or key=="master" or key=="debugId" then
        system.print("databank \""..key.."\"="..databank.getIntValue(key))
        return
    end
    system.print("databank \""..key.."\"")
    local infoJson = databank.getStringValue(key)
    if infoJson then
        system.print(infoJson)
        --local info = json.decode(infoJson)
    else
        system.print("Empty!")
    end
end

function dataDump()
    local keyJson = databank.getKeys()
    if keyJson==nil or keyJson=="" then return end
    local keys = json.decode(keyJson)
    for _,key in ipairs(keys) do
        dumpKeyValue(key)
    end
end

function query(id)
    queryElement(id)
    dumpKeyValue(id.."_updated")
    dumpKeyValue(id)
end

function slotValid(slot)
    return slot 
    and type(slot) == "table"
    and type(slot.export) == "table"
    and slot.getElementClass
end

function searchForDataSlot()
    for _, slot in pairs(unit) do        
        if slotValid(slot) and slot.getElementClass():lower() == 'databankunit' then
            databank = slot
            return
        end
    end
end

databank = nil
searchForDataSlot()
--databank.clear()
--dataDump()
--queryAllElements()

dumpKeyValue("updated")
dumpKeyValue("master")
dumpKeyValue("debugId")
query(853)