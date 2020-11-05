function queryElement(id)
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
    system.print(key.." in databank")

    if key == "updated" then
        system.print(databank.getIntValue(key))
        return
    end
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

--dataDump()
--queryAllElements()

dumpKeyValue("updated")
queryElement(49)
dumpKeyValue("49")