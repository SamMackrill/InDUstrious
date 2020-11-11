PlayerContainerProficiency = 30 --export Your Container Proficiency bonus in total percent (Skills->Mining and Inventory->Inventory Manager)
PlayerContainerOptimization = 0 --export Your Container Optimization bonus in total percent (Skills->Mining and Inventory->Stock Control)
LowLevel = 25 --export Percent for low level indicator
HighLevel = 50 --export Percent for high level indicator
ContainerMatch = "C_(.+)" --export Match for single item Storage Container names (e.g. "C_Hematite")
OverflowMatch = "O_(.+)" --export Match for single item Overflow Container names (e.g. "O_Hydrogen")
Font_Size = 0.8 --export Assembly display font size, decrease this if you have many assemblers
--Skip_Headings = true --export No substance headings
US_Spellings = false --export Expect American spellings

-- These densities are not all quite accurate, yet
properties = {
    Bauxite = {density = 1.2808, ore = true},
    Coal = {density = 1.3465,ore = true},
    Quartz = {density = 2.6498,ore = true},
    Hematite = {density = 5.0398,ore = true},
    Chromite = {density = 4.54,ore = true},
    Malachite = {density = 3.9997,ore = true},
    Limestone = {density = 2.7105,ore = true},
    Natron = {density = 1.5499,ore = true},
    Petalite = {density = 2.4119,ore = true},
    Garnierite = {density = 2.6,ore = true},
    Acanthite = {density = 7.1995,ore = true},
    Pyrite = {density = 5.0098,ore = true},
    Cobaltite = {density = 6.33,ore = true},
    Cryolite = {density = 2.9495,ore = true},
    Kolbeckite = {density = 2.37,ore = true},
    GoldNuggets = {density = 19.3,ore = true},
    Rhodonite = {density = 3.76,ore = true},
    Columbite = {density = 5.38,ore = true},
    Illmenite = {density = 4.55,ore = true},
    Vanadinite = {density = 6.95,ore = true};

    Hydrogen = {density = 0.069785, short = "H₂"};
    Oxygen = {density = 1.0000, short ="O₂"},
    
    Aluminium = {density = 2.7, usSpelling="Aluminum", short="Al"},
    Carbon = {density = 2.27, short="C"},
    Silicon = {density = 2.33, short="Si"},
    Iron = {density = 7.85, short="Fe"},
    Calcium = {density = 1.55, short="Ca"},
    Chromium = {density = 7.19, short="Cr"},
    Copper = {density = 8.96, short="Cu"},
    Sodium = {density = 0.97, short="Na"},
    Lithium = {density = 0.53, short="Li"},
    Nickel = {density = 8.91, short="Ni"},
    Silver = {density = 10.49, short="Ag"},
    Sulfur = {density = 1.82, short="S"},
    Cobalt = {density = 8.9, short="Co"},
    Fluorine = {density = 1.7, short="Fl"},
    Gold = {density = 19.3, short="Au"},
    Scandium = {density = 2.98, short="Sc"},
    Manganese = {density = 7.21, short="Mn"},
    Niobium = {density = 8.57, short="Ni"},
    Titanium = {density = 4.51, short="Ti"},
    Vanadium = {density = 6.00, short="Va"};

    Silumin = {density = 3.00},
    Steel = {density = 8.05},
    AlFe = {density = 7.50},
    AlLi = {density = 2.50},
    CaRefCu = {density = 8.10},
    CuAg = {density = 9.20},
    Duralumin = {density = 2.80};
    ["Stainless steel"] = {density = 7.75, short="S.Steel"};
}

function slotValid(slot)
    return slot 
    and type(slot) == "table"
    and type(slot.export) == "table"
    and slot.getElementClass
end

local containerDisplays = {}
local productionDisplays = {}
local containers = {}
function onStart()

    for slotName, slot in pairs(unit) do
        if slotValid(slot) then
            if slot.setHTML then 
                local html = [[<div style="width:100vw"><div style="margin-top: 10px;padding: 0px;width: 100vw;display: inline-block;">Hamsters wake up ...</div></div>]] 
                slot.activate()
                slot.setHTML(html)
            elseif not databank and slot.getStringValue then
                databank = slot
            elseif not core and slot.getConstructId then
                core = slot
            end
        end
    end

    if not core then return end

    for slotName, slot in pairs(unit) do
        if slotValid(slot) then
            if slot.setHTML then 
                local id = slot.getId();
                if id then
                    local name = core.getElementNameById(id)
                    if name=="ContDisplay1" then
                        containerDisplays[1] = slot
                    elseif name=="ContDisplay2" then
                        containerDisplays[2] = slot
                    elseif name=="ProdDisplay1" then
                        productionDisplays[1] = slot
                    elseif name=="ProdDisplay2" then
                        productionDisplays[2] = slot
                    end
                end
            end
        end
    end

    function extractSubstanceName(name, match)
        local substance = string.gsub(name, match, "")
        -- TODO check American spellings?
        return substance
    end

    -- returns container self mass, container base volume
    function getBaseCointainerProperties(id)
        local maxHP = core.getElementMaxHitPointsById(id)
        if maxHP <= 123 then       -- Hub
            return 0.0, 0.0
        elseif maxHP <= 998 then   -- XS
            return 229.09, 1000.0
        elseif maxHP <= 7996 then  -- S
            return 1281.31, 8000.0
        elseif maxHP <= 17315 then -- M
            return 7421.35, 64000.0
        else                       -- L
            return 14842.7, 128000.0
        end
    end

    function addContainer(id)
        if not core.getElementTypeById(id)=="container" then return end
        local name = core.getElementNameById(id)
        if not name then return end

        local overflow = false
        local substance = string.match(name, "^"..ContainerMatch)
        if not substance then 
            substance = string.match(name, "^"..OverflowMatch)
            if not substance then
                --system.print("Ignoring container: "..name.." ["..id.."]")
                return 
            end
            overflow = true
        end

        local property = properties[substance]
        if not property then return end

        local selfMass, baseVolume = getBaseCointainerProperties(id)
        capacity = baseVolume*(1.0 + PlayerContainerProficiency/100)

        --system.print("Adding container: "..name.. " ["..id.."]")
        containers[id] = {
            name=name, 
            id=id, 
            substance=substance, 
            capacity=capacity, 
            selfMass=selfMass, 
            property=property, 
            overflow=overflow,
            isHub=baseVolume==0,
        }
    end
    
    local elementsIds = core.getElementIdList()
    for _,id in ipairs(elementsIds) do
        addContainer(id)
    end
end

local machineSizes = {"XS", " S", " M", " L", "XL"}
function assemblySize(id)
    local mass = core.getElementMassById(id)
    local sizeIndex = math.floor(math.log(mass - 90, 10) + 0.1)
    return sizeIndex, machineSizes[sizeIndex]
end

-- colourblind friendly colours
tolColours = {
    blue=   "#332288",
    cyan=   "#66CCEE",
    green=  "#228833",
    yellow= "#CCBB44",
    red=    "#EE6677",
    purple= "#AA3377",
    grey=   "#BBBBBB",
} -- https://personal.sron.nl/~pault/


local headerColour  = "darkslategray"

local goodColour    = tolColours.green
local idleColour    = tolColours.cyan
local neutralColour = tolColours.yellow
local alarmColour   = tolColours.red

local font = [[monospace]]

local H = {
    h1 = [[<head><style> .bar { text-align: left; vertical-align: top; border-radius: 0 0em 0em 0; } </style></head>]],

    d1 = [[<div class="bootstrap" style="text-transform:none; text-align:left; vertical-align: text-bottom;
    display: flex; flex-direction: column; justify-content: flex-end; align-items: flex-end; margin: auto;">]],
    de = [[</div>]],

    t1 = [[<table style="Font-Family: ]]..font..[[;  font-size: 4em; table-layout: auto; width: 100vw;">]],
    t2 = [[<table style="Font-Family: ]]..font..[[;  font-size: 2.6em; table-layout: auto; width: 100vw;">]],
    te = [[</table>]],

    r1 = [[<tr style="width:100vw; background-color: ]]..headerColour..[[; color: white;">]],
    r2 = [[<tr>]],
    re = [[</tr>]],

    thL  = [[<th style="text-align:left; margin-left:20px">]],
    thL2 = [[<th style="text-align:left; margin-left:20px" colspan="2">]],
    thR  = [[<th style="text-align:right; margin-right:20px">]],

    th3 = [[<th style="background-color: ]]..headerColour..[[;">&nbsp;</th>]],
    th4 = [[<th colspan=9>&nbsp;</th>]],
    the = [[</th>]],

    nbr = [[<nobr>]],
    nbre = [[</nobr>]],
}

function refreshContainerDisplay(displayLow, displayHigh, force)
    -- Credit to badman74 for initial approach https://github.com/badman74/DU
    
    local outputData = {}

    function processSubstanceContainer(container)
        local contentMass = (core.getElementMassById(container.id) - container.selfMass) * (1.0 + PlayerContainerOptimization/100)
        local volume = contentMass/container.property.density

        local key = container.substance
        if container.overflow then key = "O_"..container.substance end

        -- if container.substance=="Quartz" then
        --     system.print("Processing Container "..container.name.." ["..container.id.."] key:"..key)
        --     system.print(" Volume  : "..volume)
        --     system.print(" Capacity: "..container.capacity)
        --     system.print(" selfMass  : "..container.selfMass)
        --     system.print(" contentMass: "..contentMass)
        --     system.print(" isHub: "..tostring(container.isHub))
        -- end
        if outputData[key] then
            outputData[key].volume      = outputData[key].volume   + volume
            outputData[key].contentMass = outputData[key].contentMass + contentMass
            outputData[key].capacity    = outputData[key].capacity + container.capacity
        else
            outputData[key] = {
                substance = container.substance,
                volume = volume,
                contentMass = contentMass,
                capacity = container.capacity,
                overflow = container.overflow,
            }
        end
        -- if container.substance=="Quartz" then
        --     system.print("Totals "..key)
        --     system.print(" Volume     : "..outputData[key].volume)
        --     system.print(" Capacity   : "..outputData[key].capacity)
        --     system.print(" ContentMass: "..outputData[key].contentMass)
        -- end

        -- if outputData[key].volume-container.capacity > .5 then
        --     system.print(container.substance.." : volume > capacity")
        --     system.print(outputData[key].volume.." > "..outputData[key].capacity)
        --     system.print("contentMass : "..outputData[key].contentMass)
        --     system.print("Density : "..container.property.density.." => ".. string.format("%0.6f", outputData[key].contentMass / outputData[key].capacity))
        -- end

    end

    for _,container in pairs(containers) do
        processSubstanceContainer(container)
    end

    function statusColour(percent, reverse)
        if reverse then percent = 100.0 - percent end
        if percent <= LowLevel then return alarmColour end
        if percent <= HighLevel then return neutralColour end
        return goodColour
    end

    function barGraph(percent, reverse, colspan)
        if not colspan then colspan = 1 end
        local barcolour = statusColour(percent, reverse)
        return [[<td class="bar" valign=top colspan="]]..colspan..[[">
        <svg>
            <rect x="0" y="1" rx="4" ry="4" height="2.5vw" width="17.2vw" stroke="white" stroke-width="1" rx="0" />
            <rect x="1" y="2" rx="3" ry="3" height="2.4vw" width="]].. (17*percent/100) ..[[vw" fill="]] .. barcolour ..[[" opacity="1.0" rx="0" />
            <text x="1" y="23" fill="white" text-align="left" margin-left="3" font-family="]]..font..[[">]].. string.format("%02.1f", percent) ..[[%</text>
        </svg>
        </td>]]        
    end

    function correctSpelling(text)
        if US_Spellings and properties[text] and properties[text].usSpelling then return properties[text].usSpelling end
        return text
    end

    function displayFormat(substance, overflow)
        local text = correctSpelling(substance)

        local key = substance
        if overflow then key = "O_"..substance end
        local substanceData = outputData[key]
        if not substanceData then
            if overflow then return nil end
            return "?", 0.0, "kℓ", text
        end

        local short = properties[substance].short     
        if overflow then
            if short then
                text = short.." Overflow"
            else
                text = text.." OF"
            end
        elseif text:len() > 12 and short then
            text = short
        end

        local volume = substanceData.volume
        --system.print(key.." volume="..volume)
        local percent = math.min(100.0 * volume / substanceData.capacity, 100.0) -- densities are not accurate enough

        if volume >= 1000000 then return string.format("%02.1f", volume/1000000), percent, "Mℓ", text end
        return string.format("%02.1f", volume/1000), percent, "kℓ", text
    end

    
    function cell(width, align) return [[<th style="width:]]..width..[[vw; text-align:]]..align..[[;">]]  end

    function newHTMLRow(id1, id2, overflow)
        local volume1, percent1, units1, text1 = displayFormat(id1, overflow)
        if not volume1 then return "" end
        --system.print(text1.." volume="..volume1.." units="..units1.." percent="..percent1)
        local volume2, percent2, units2, text2 = displayFormat(id2, overflow)
        --system.print(text2.." volume="..volume2.." units="..units2.." percent="..percent2)
        local converting = "⇒"
        if overflow or not outputData[id1] or not outputData[id1].ore then converting = "&nbsp;" end
        resHTML = H.r2 
            ..H.thL..text1..H.the
            ..H.thR..volume1..units1..H.the
            ..barGraph(percent1, overflow)
            .."<th style=\"background-color: "..headerColour.."\">"..converting..H.the
            ..H.thL..text2..H.the
            ..H.thR..volume2..units2..H.the
            ..barGraph(percent2, overflow)
            ..H.re
        return resHTML
    end

    local th1 = [[<th style="width:18vw; text-align:left;">]]
    local th2 = [[<th style="width:13vw; text-align:left;"></th>
                  <th style="width:17vw; text-align:left;"></th>]]
    
    function newHTMLHeader(text1, text2)
        return H.r1..th1..text1..H.the..th2..[[<th style="width:2vw"/>]]..th1..text2..H.the..th2
    end
    
    if displayLow then
        local html=H.h1..H.d1..H.t2

        html=html..newHTMLHeader("T3 Ores", "T3 Pures")
        html=html..newHTMLRow("Petalite", "Lithium")
        html=html..newHTMLRow("Garnierite", "Nickel")
        html=html..newHTMLRow("Pyrite", "Sulfur")
        html=html..newHTMLRow("Acanthite", "Silver")

        html=html..newHTMLHeader("T2 Ores", "T2 Pures")
        html=html..newHTMLRow("Natron", "Sodium")
        html=html..newHTMLRow("Malachite", "Copper")
        html=html..newHTMLRow("Limestone", "Calcium")
        html=html..newHTMLRow("Chromite", "Chromium")
        
        html=html..newHTMLHeader("T1 Ores", "T1 Pures")
        html=html..newHTMLRow("Bauxite", "Aluminium")
        html=html..newHTMLRow("Coal", "Carbon")
        html=html..newHTMLRow("Hematite", "Iron")
        html=html..newHTMLRow("Quartz", "Silicon")

        html=html..newHTMLHeader("H₂", "O₂")
        html=html..newHTMLRow("Hydrogen", "Oxygen")
        html=html..newHTMLRow("Hydrogen", "Oxygen", true)

        html=html..H.r1..H.th4..H.re
        html=html..H.te..H.de
        displayLow.setHTML(html)
    end

    if displayHigh then
        local html=H.h1..H.d1..H.t2

        html=html..newHTMLHeader("T5 Ores", "T5 Pures")
        html=html..newHTMLRow("Rhodonite", "Manganese")
        html=html..newHTMLRow("Columbite", "Niobium")
        html=html..newHTMLRow("Illmenite", "Titanium")
        html=html..newHTMLRow("Vanadinite", "Vanadium")

        html=html..newHTMLHeader("T4 Ores", "T4 Pures")
        html=html..newHTMLRow("Cobaltite", "Cobalt")
        html=html..newHTMLRow("Cryolite", "Fluorine")
        html=html..newHTMLRow("GoldNuggets", "Gold")
        html=html..newHTMLRow("Kolbeckite", "Scandium")

        html=html..newHTMLHeader("Alloys", "Alloys")
        html=html..newHTMLRow("Silumin", "Steel")
        html=html..newHTMLRow("AlFe", "CaRefCu")
        html=html..newHTMLRow("Stainless steel", "Duralumin")

        html=html..H.r1..H.th4..H.re
        html=html..H.te..H.de
        displayHigh.setHTML(html)
    end

end

dataUpdates = {}
assemblies = {}
alerts = {}

function refreshIndustryScreens(displayLow, displayHigh, force)
    --if not force and databank.hasKey("updated") and databank.getIntValue("updated")==0 then return end

    function newHTMLRow(text1, text2, text3, text4, colour, size)
        resHTML =
            [[<tr style="color: ]]..colour..[[; font-size: ]]..size..[[em;">>
                ]]..H.thL..[[&nbsp;</th>
                ]]..H.thL..text1..[[</th>
                ]]..H.thL..text2..[[</th>
                ]]..H.thR..text3..[[</th>
                ]]..H.thL..text4..[[</th>
            </tr>]]
        return resHTML
    end

    function processData(key)
        if key == "updated" then return end
        
        local infoJson = databank.getStringValue(key)
        if infoJson==nil or infoJson=="" then return end
        local info = json.decode(infoJson)
        
        if (not info or type(info)~="table" or not info.status or (not force and info.updated~=1)) then 
            --system.print("skipping "..key)
            return 
        end

        --if not force then system.print(key.." status="..info.status) end
        local name = core.getElementNameById(key)
        local machine = core.getElementTypeById(key)
        if (machine=="assembly line") then
            local sizeIndex, size = assemblySize(key)
            local product = ""
            if not string.find(name, "%[") then
                product = name
            end
            --system.print(key.." Assembly "..assemblySize(key).." : "..info.status)
            assemblies[sizeIndex * 10000 + key] = {name=name, size=size, id=key, product=product, status=info.status}
        else
            local alertKey = machine.."_"..name.."_"..key
            --system.print(key.." : "..machine.."["..name.."] : "..info.status)
            if info.status:find("JAMMED") == 1 then       
                --system.print(key.." : "..machine.."["..name.."] : "..info.status)
                alerts[alertKey] = {name=name, machine=machine, id=key, status=info.status}
            else
                alerts[alertKey] = nil
            end
        end
        if info.updated==1 then
            info.updated = 0
            dataUpdates[key] = info
        end
    end

    local keyJson = databank.getKeys()
    if keyJson==nil or keyJson=="" then return end
    local keys = json.decode(keyJson)
    for _,key in ipairs(keys) do
        processData(key)
    end

    -- Sort the assemblies
    local tkeys = {}
    for k in pairs(assemblies) do table.insert(tkeys, k) end
    table.sort(tkeys)

    if displayLow then
        local html=H.h1..H.d1..H.t1

        html=html..H.r1..H.thL.."&nbsp;"..H.the..H.thL2.."Assm. - Making"..H.the..H.thR.."#&nbsp;"..H.the..H.thL.."Status"..H.the..H.re

        for _, k in ipairs(tkeys) do
            local assembly = assemblies[k]
            local colour = alarmColour
            local status = assembly.status
            if status == "JAMMED_MISSING_INGREDIENT" then       
                colour = neutralColour
                status = "WAITING"
            elseif status == "RUNNING" then       
                colour = goodColour
            elseif status == "STOPPED" then       
                colour = idleColour
            elseif status:find("JAMMED") == 1 then       
                colour = alarmColour
            end
            --system.print(assembly.size.." ["..assembly.id.."] :"..status.. " ("..colour..")")
            html=html..newHTMLRow(assembly.size, assembly.product, assembly.id.."&nbsp;", status, colour, Font_Size)
        end

        html=html..H.te..H.de
        displayLow.setHTML(html)
    end

    -- Sort the alerts
    local alertkeys = {}
    for k in pairs(alerts) do table.insert(alertkeys, k) end
    table.sort(alertkeys)

    if displayHigh then
        local html=H.h1..H.d1..H.t1

        html=html..H.r1..H.thL.."&nbsp;"..H.the..H.thL2.."Machine"..H.the..H.thR.."#"..H.the..H.thL.."Alert"..H.the..H.re

        for _, k in ipairs(alertkeys) do
            local alert = alerts[k]
            local colour = alarmColour
            local status = alert.status
            if status == "JAMMED_MISSING_INGREDIENT" then       
                colour = neutralColour
                status = "WAITING"
            elseif status:find("JAMMED") == 1 then       
                colour = alarmColour
            end
            html=html..newHTMLRow(alert.machine, alert.name, alert.id.."&nbsp;", status, colour, Font_Size)
        end

        html=html..H.te..H.de
        displayHigh.setHTML(html)
    end

end

function refreshScreens(force)
    refreshContainerDisplay(containerDisplays[1], containerDisplays[2], force)
    refreshIndustryScreens(productionDisplays[1], productionDisplays[2], force)
end

function processFirst()
    --system.print("Tick First")
    unit.stopTimer("First")
    refreshScreens(true)
end

function processDataUpdates()
    if not databank then return end
    --system.print("Tick WriteData")
    local throttle = 11
    for key, info in pairs(dataUpdates) do
        throttle = throttle - 1
        if throttle==0 then return end
        --system.print("Writing data for "..key)
        databank.setStringValue(key, json.encode(info))
        dataUpdates[key] = nil
    end
    if next(dataUpdates) == nil then databank.setIntValue("updated", 0) end
end

function processTick()   
    --system.print("Tick Live")
    local ok, msg = xpcall(function ()

        refreshScreens(false)

    end, traceback)

    if not ok then
      system.print(msg)
    end
end

function onStop()
    for _, slot in pairs(unit) do
        if slotValid(slot) then
            if slot.setHTML then slot.clear() end
        end
    end    
end

--unit.hide()
system.print("InDUstry Status")
local databank = nil
onStart()

unit.setTimer("First", 1)
unit.setTimer("Live", 7)
unit.setTimer("WriteData", 3)