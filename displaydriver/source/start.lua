--unit.hide()
system.print("Industry Status")

PlayerContainerProficiency = 30 --export Your Container Proficiency bonus in total percent (Skills->Mining and Inventory->Inventory Manager)
PlayerContainerOptimization = 0 --export Your Container Optimization bonus in total percent (Skills->Mining and Inventory->Stock Control)
LowLevel = 25 --export At which percent level do you want bars to be drawn in yellow (not red anymore)
MediumLevel = 50 --export At which percent level do you want bars to be drawn in green (not yellow anymore)
searchStringOre = " Ore" --export Your identifier for Ore Storage Containers (e.g. "Bauxite Ore"). Include the spaces if you change this!
searchStringPure = "Pure " --export Your identifier for Pure Storage Containers (e.g. "Pure Aluminium"). Include the spaces if you change this!


function slotValid(slot)
    return slot 
    and type(slot) == "table"
    and type(slot.export) == "table"
    and slot.getElementClass
end
local displays = {}
function onStart()
    if display1 then displays[1] = display1 end
    if display2 then displays[2] = display2 end
    if display3 then displays[3] = display3 end
    if display4 then displays[4] = display4 end
    local displayIndex = 1
    for slotName, slot in pairs(unit) do
        if slotValid(slot) then
            if slot.setHTML then 
                slot.activate()
                --displays[displayIndex] = slot
                --displayIndex = displayIndex + 1
            elseif not databank and slot.getStringValue then
                databank = slot
            elseif not core and slot.getConstructId then
                core = slot
            end
        end
    end    
end
 
function refreshScreens(force)
    refreshOreScreens(displays[3], displays[4], force)
    refreshIndustryScreens(displays[1], displays[2], force)
end

function processTick()   
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

function round(number,decimals)
    local power = 10^decimals
    return math.floor((number/1000) * power) / power
end

local machineSizes = {"XS", " S", " M", " L", "XL"}

function assemblySize(id)
    local mass = core.getElementMassById(id)
    local sizeIndex = math.floor(math.log(mass - 90, 10) + 0.1)
    return sizeIndex, machineSizes[sizeIndex]
end

substanceMass = {
    Bauxite=1.28;
    Coal=1.35;
    Quartz=2.65;
    Hematite=5.04;
    Chromite=4.54;
    Malachite=4;
    Limestone=2.71;
    Natron=1.55;
    Petalite=2.41;
    Garnierite=2.6;
    Acanthite=7.2;
    Pyrite=5.01;
    Cobaltite=6.33;
    Cryolite=2.95;
    Kolbeckite=2.37;
    GoldNuggets=19.3;
    Rhodonite=3.76;
    Columbite=5.38;
    Illmenite=4.55;
    Vanadinite=6.95;

    Oxygen=1;
    Hydrogen=0.07;
    
    Aluminium=2.7;
    Carbon=2.27;
    Silicon=2.33;
    Iron=7.85;
    Calcium=1.55;
    Chromium=7.19;
    Copper=8.96;
    Sodium=0.97;
    Lithium=0.53;
    Nickel=8.91;
    Silver=10.49;
    Sulfur=1.82;
    Cobalt=8.9;
    Fluorine=1.7;
    Gold=19.3;
    Scandium=2.98;
    Manganese=7.21;
    Niobium=8.57;
    Titanium=4.51;
    Vanadium=6;
}

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

local font = [[Monaco, monospace]]

local H = {
    h1 = [[<head><style> .bar { text-align: left; vertical-align: top; border-radius: 0 0em 0em 0; } </style></head>]],

    d1 = [[<div class="bootstrap" style="text-align:left; vertical-align: text-bottom;
    display: flex; flex-direction: column; justify-content: flex-end; align-items: flex-end; margin: auto;">]],
    de = [[</div>]],

    t1 = [[<table style="text-transform: capitalize;Font-Family: ]]..font..[[;  font-size: 4em; table-layout: auto; width: 100vw;">]],
    t2 = [[<table style="text-transform: capitalize;Font-Family: ]]..font..[[;  font-size: 2.6em; table-layout: auto; width: 100vw;">]],
    te = [[</table>]],

    r1 = [[<tr style="width:100vw; background-color: ]]..headerColour..[[; color: white;">]],
    r2 = [[<tr>]],
    re = [[</tr>]],

    thL = [[<th style="text-align:left;">]],
    thR = [[<th style="text-align:right;">]],

    th3 = [[ <th style="background-color: ]]..headerColour..[[;">&nbsp;</th>]],
    th4 = [[<th colspan=9>&nbsp;</th>]],
    the = [[</th>]]
}

function refreshOreScreens(displayLow, displayHigh, force)
    -- Credit to badman74 for initial approach https://github.com/badman74/DU
    
    local outputData = {}

    function processSubstanceContainer(id)

        local name = core.getElementNameById(id)
        if not name then return end

        local substance = nil
        if string.match(name, searchStringOre) then
            --system.print("Ore container:"..name)
            substance = string.gsub(name, searchStringOre, "")
        elseif string.match(name, searchStringPure) then
            --system.print("Pure container:"..name)
            substance = string.gsub(name, searchStringPure, "")
        end

        if not substance or substance=="" then return end

        local substanceSingleMass = substanceMass[substance]
        if substanceSingleMass~=nil then
            local maxHP = core.getElementMaxHitPointsById(id)
            local containerSelfMass = 0.0
            local capacity = 0.0
            if maxHP > 49 and maxHP <= 123 then -- Hub
            else
                if maxHP > 123 and maxHP <= 998 then -- XS
                    containerSelfMass = 229.09
                    containerVolume = 1000.0
                elseif maxHP > 998 and maxHP <= 7996 then -- S
                    containerSelfMass = 1280.0
                    containerVolume = 8000.0
                elseif maxHP > 7996 and maxHP <= 17315 then -- M
                    containerSelfMass = 7420.0
                    containerVolume = 64000.0
                elseif maxHP > 17315 then -- L
                    containerSelfMass = 14840.0
                    containerVolume = 128000.0
                end
                capacity = containerVolume*(1.0 + PlayerContainerProficiency/100)
            end

            local contentMass = (core.getElementMassById(id) - containerSelfMass) * (1.0 + PlayerContainerOptimization/100)
            local volume = contentMass/substanceSingleMass

            --if name=="Pure Hydrogen" then
            --    system.print(name.." : "..volume.." ".. capacity)
            --    system.print("containerSelfMass : "..containerSelfMass)
            --    system.print("contentMass : "..contentMass)
            --    system.print("substanceSingleMass : "..substanceSingleMass)
            --end

            if outputData[substance] then
                outputData[substance].volume   = outputData[substance].volume   + volume;
                outputData[substance].capacity = outputData[substance].capacity + capacity;
            else
                outputData[substance] = {
                    name = substance;
                    volume = volume;
                    capacity = capacity;
                }
            end
        end
    end

    local elementsIds = core.getElementIdList()
    for _,id in ipairs(elementsIds) do
        if string.match(core.getElementTypeById(id):lower(), "container") then
            processSubstanceContainer(id)
        end
    end

    function BarGraph(percent, colspan)
        if not colspan then colspan = 1 end
        if percent <= 0 then barcolour = alarmColour
        elseif percent > 0 and percent <= LowLevel then barcolour = alarmColour
        elseif percent > LowLevel and percent <= MediumLevel then barcolour = neutralColour
        elseif percent > MediumLevel then  barcolour = goodColour
        else  barcolour = goodColour
        end 
        return [[<td class="bar" valign=top colspan="]]..colspan..[[">
        <svg>
            <rect x="0" y="1" rx="4" ry="4" height="2.5vw" width="17.2vw" stroke="white" stroke-width="1" rx="0" />
            <rect x="1" y="2" rx="3" ry="3" height="2.4vw" width="]].. (17*percent/100) ..[[vw" fill="]] .. barcolour ..[[" opacity="1.0" rx="0" />
            <text x="1" y="23" fill="white" text-align="middle" margin-left="3">]].. string.format("%02.1f", percent) ..[[%</text>
        </svg>
        </td>]]        
    end

    function displayFormat(id)
        if not outputData[id] then return 0, 0, "Kl" end

        local volume = outputData[id].volume
        --system.print(id.." volume="..volume)
        local percent = 100 * volume / outputData[id].capacity

        if volume >= 1000000 then return volume/1000000, percent, "Ml" end
        return volume/1000, percent, "Kl"
    end

    function AddHTMLRow(id1, id2)
        local volume1, percent1, units1 = displayFormat(id1)
        --system.print(id1.." volume="..volume1.." units="..units1.." percent="..percent1)
        local volume2, percent2, units2 = displayFormat(id2)
        --system.print(id2.." volume="..volume2.." units="..units2.." percent="..percent2)
        resHTML = H.r2 
            ..H.thL..id1..H.the
            ..H.thR..string.format("%02.1f", volume1)..units1.."&nbsp;"..H.the
            ..BarGraph(percent1)
            .."<th style=\"background-color: "..headerColour.."\">"..H.the
            ..H.thR..id2..H.the
            ..H.thR..string.format("%02.1f", volume2)..units2.."&nbsp;"..H.the
            ..BarGraph(percent2)
            ..H.re
        return resHTML
    end

    local th1 = [[<th style="width:17vw; text-align:left;">]]
    local th2 = [[<th style="width:14vw; text-align:left;">Vol.</th>
                  <th style="width:17vw; text-align:left;">Levels</th>]]
    
    function AddHTMLHeader(text1, text2)
        return H.r1..th1..text1..H.the..th2..[[<th style="width:2vw"/>]]..th1..text2..H.the..th2
    end
    
    if displayLow then
        local html=H.h1..H.d1..H.t2

        html=html..AddHTMLHeader("T3 Ores", "T3 Pures")
        html=html..AddHTMLRow("Petalite", "Lithium")
        html=html..AddHTMLRow("Garnierite", "Nickel")
        html=html..AddHTMLRow("Pyrite", "Sulfur")
        html=html..AddHTMLRow("Acanthite", "Silver")

        html=html..AddHTMLHeader("T2 Ores", "T2 Pures")
        html=html..AddHTMLRow("Natron", "Sodium")
        html=html..AddHTMLRow("Malachite", "Copper")
        html=html..AddHTMLRow("Limestone", "Calcium")
        html=html..AddHTMLRow("Chromite", "Chromium")
        
        html=html..AddHTMLHeader("T1 Ores", "T1 Pures")
        html=html..AddHTMLRow("Bauxite", "Aluminium")
        html=html..AddHTMLRow("Coal", "Carbon")
        html=html..AddHTMLRow("Hematite", "Iron")
        html=html..AddHTMLRow("Quartz", "Silicon")

        html=html..AddHTMLHeader("H₂", "O₂")
        html=html..AddHTMLRow("Hydrogen", "Oxygen")

        --if oresIn then
            --system.print("Ore IN mass="..oresIn.getMass())
            --local oresInPercent = 100000 * outputdatabank.IN.amount * 1000 / outputdatabank.IN.capacity
            --html=html.."<tr><th align=right>Ores IN</th>"..BarGraph(oresInPercent,7).."</tr>"
        --end
        
        html=html..H.r1..H.th4..H.re
        html=html..H.te..H.de
        displayLow.setHTML(html)
    end

    if displayHigh then
        local html=H.h1..H.d1..H.t2

        html=html..AddHTMLHeader("T5 Ores", "T5 Pures")
        html=html..AddHTMLRow("Rhodonite", "Manganese")
        html=html..AddHTMLRow("Columbite", "Niobium")
        html=html..AddHTMLRow("Illmenite", "Titanium")
        html=html..AddHTMLRow("Vanadinite", "Vanadium")

        html=html..AddHTMLHeader("T4 Ores", "T4 Pures")
        html=html..AddHTMLRow("Cobaltite", "Cobalt")
        html=html..AddHTMLRow("Cryolite", "Fluorine")
        html=html..AddHTMLRow("GoldNuggets", "Gold")
        html=html..AddHTMLRow("Kolbeckite", "Scandium")

        html=html..H.r1..H.th4..H.re
        html=html..H.te..H.de
        displayHigh.setHTML(html)
    end

end


function refreshIndustryScreens(displayLow, displayHigh, force)
    if not force and databank.hasKey("updated") and databank.getIntValue("updated")==0 then return end

    function AddHTMLRow(text1, text2, text3, colour, size)
        resHTML =
            [[<tr style="color: ]]..colour..[[; font-size: ]]..size..[[em;">>
                ]]..H.thL..[[&nbsp;</th>
                ]]..H.thL..text1..[[</th>
                ]]..H.thR..text2..[[&nbsp;</th>
                ]]..H.thL..text3..[[</th>
            </tr>]]
        return resHTML
    end

    local assemblies = {}
    local alerts = {}
    local keys = json.decode(databank.getKeys())
    for _,key in ipairs(keys) do
        if key ~= "updated" then
            local info = json.decode(databank.getStringValue(key))
            if (data and type(info) == "table" and info.status and (force or info.updated==1)) then
                --system.print(key.." status="..info.status)
                local name = core.getElementNameById(key)
                local machine = core.getElementTypeById(key)
                if (machine=="assembly line") then
                    local sizeIndex, size = assemblySize(key)
                    --system.print(key.." Assembly "..assemblySize(key).." : "..info.status)
                    assemblies[sizeIndex * 10000 + key] = {name=name, size=size, id=key, status=info.status}
                else
                    --system.print(key.." : "..machine.."["..name.."] : "..info.status)
                    if info.status:find("JAMMED") == 1 then       
                        --system.print(key.." : "..machine.."["..name.."] : "..info.status)
                        alerts[key] = {name=name, machine=machine, id=key, status=info.status}
                    end
                end
                info.updated = 0
            end        
        end
    end

    -- Sort the assemblies by size
    local tkeys = {}
    for k in pairs(assemblies) do table.insert(tkeys, k) end
    table.sort(tkeys)

    if displayLow then
        local html=H.h1..H.d1..H.t1

        html=html..H.r1..H.thL.."&nbsp;"..H.the..H.thL.."Assembly Lines"..H.the..H.thR.."#&nbsp;"..H.the..H.thL.."Status"..H.the..H.re

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
            html=html..AddHTMLRow(assembly.size, ""..assembly.id, status, colour, "1")
        end

        html=html..H.te..H.de
        displayLow.setHTML(html)
    end

    if displayHigh then
        local html=H.h1..H.d1..H.t1

        html=html..H.r1..H.thL.."&nbsp;"..H.the..H.thL.."Machine"..H.the..H.thR.."#&nbsp;"..H.the..H.thL.."Alert"..H.the..H.re

        for _, alert in pairs(alerts) do
            local colour = alarmColour
            local status = alert.status
            if status == "JAMMED_MISSING_INGREDIENT" then       
                colour = neutralColour
                status = "WAITING"
            elseif status:find("JAMMED") == 1 then       
                colour = alarmColour
            end
            html=html..AddHTMLRow(alert.machine.." - "..alert.name, ""..alert.id, status, colour, "0.5")
        end

        html=html..H.te..H.de
        displayHigh.setHTML(html)
    end


    databank.setIntValue("updated", 0)
end


function queryAllElements()

    elementsIds = core.getElementIdList()

    for _,id in ipairs(elementsIds) do    
        system.print(id.." : "..core.getElementTypeById(id).." name="..core.getElementNameById(id))      
    end
    
end

function queryAllKeys()
    system.print("Query all keys in databank...")
    local keys = json.decode(databank.getKeys())
    for _,key in ipairs(keys) do
        system.print(key.."="..databank.getStringValue(key))    
    end  
end

local databank = nil
onStart()
--queryAllKeys()
--queryAllElements()

refreshScreens(true)
unit.setTimer("Live", 10)