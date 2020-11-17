PlayerContainerProficiency = 30 --export Your Container Proficiency bonus in total percent (Skills->Mining and Inventory->Inventory Manager)
PlayerContainerOptimization = 0 --export Your Container Optimization bonus in total percent (Skills->Mining and Inventory->Stock Control)
LowLevel = 25 --export Percent for low level indicator
HighLevel = 50 --export Percent for high level indicator
ContainerMatch = "C_(.+)" --export Match for single item Storage Container names (e.g. "C_Hematite")
OverflowMatch = "O_(.+)" --export Match for single item Overflow Container names (e.g. "O_Hydrogen")
ContRowsPerScreen = 20 --export Container rows per screen
ProdRowsPerScreen = 16 --export Production rows per screen
AlignTop = false --export Align with top of screen
WaitingAsAlarm = false --export Display waiting state with alarm colour
KeepBlocksTogether = false  --Don't break blocks across displays
DataThrottle = 15 --export Maximum writes to process each update, lower this if you get CPU overloads
SkipHeadings = false --export No substance headings
US_Spellings = false --export Expect American spellings

FontSize = 11.2 / ProdRowsPerScreen

debugId = 0 --export Print diagnostics for this ID, 0=OFF

function debug(id, text)
    if id~=debugId then return end
    system.print("MAS#"..self.getId().." "..text)
end

-- These densities are not all quite accurate, yet
properties = {
    Bauxite     = {density = 1.2808, ore = true},
    Coal        = {density = 1.3465, ore = true},
    Quartz      = {density = 2.6498, ore = true},
    Hematite    = {density = 5.0398, ore = true},
    Chromite    = {density = 4.54,   ore = true},
    Malachite   = {density = 3.9997, ore = true},
    Limestone   = {density = 2.7105, ore = true},
    Natron      = {density = 1.5499, ore = true},
    Petalite    = {density = 2.4119, ore = true},
    Garnierite  = {density = 2.6,    ore = true},
    Acanthite   = {density = 7.1995, ore = true},
    Pyrite      = {density = 5.0098, ore = true},
    Cobaltite   = {density = 6.33,   ore = true},
    Cryolite    = {density = 2.9495, ore = true},
    Kolbeckite  = {density = 2.37,   ore = true},
    GoldNuggets = {density = 19.3,   ore = true},
    Rhodonite   = {density = 3.76,   ore = true},
    Columbite   = {density = 5.38,   ore = true},
    Illmenite   = {density = 4.55,   ore = true},
    Vanadinite  = {density = 6.95,   ore = true};

    Hydrogen = {density = 0.069785, short = "H₂"};
    Oxygen   = {density = 1.0000,   short = "O₂"},
    
    Aluminium = {density = 2.7,   short = "Al", usSpelling = "Aluminum"},
    Carbon    = {density = 2.27,  short = "C"},
    Silicon   = {density = 2.33,  short = "Si"},
    Iron      = {density = 7.85,  short = "Fe"},
    Calcium   = {density = 1.55,  short = "Ca"},
    Chromium  = {density = 7.19,  short = "Cr"},
    Copper    = {density = 8.96,  short = "Cu"},
    Sodium    = {density = 0.97,  short = "Na"},
    Lithium   = {density = 0.53,  short = "Li"},
    Nickel    = {density = 8.91,  short = "Ni"},
    Silver    = {density = 10.49, short = "Ag"},
    Sulfur    = {density = 1.82,  short = "S"},
    Cobalt    = {density = 8.9,   short = "Co"},
    Fluorine  = {density = 1.7,   short = "Fl"},
    Gold      = {density = 19.3,  short = "Au"},
    Scandium  = {density = 2.98,  short = "Sc"},
    Manganese = {density = 7.21,  short = "Mn"},
    Niobium   = {density = 8.57,  short = "Ni"},
    Titanium  = {density = 4.51,  short = "Ti"},
    Vanadium  = {density = 6.00,  short = "Va"};

    Silumin             = {density = 3.00},
    Steel               = {density = 8.05},
    AlFe                = {density = 7.50},
    AlLi                = {density = 2.50},
    CaRefCu             = {density = 8.10},
    CuAg                = {density = 9.20},
    Duralumin           = {density = 2.80},
    ["Stainless steel"] = {density = 7.75, short = "S.Steel"};

    Polycarbonate  = {density = 1.4,  short = "Polycarb"},
    Polycalcite    = {density = 1.5,  short = "Polycalc"},
    Polysulfide    = {density = 1.6,  short = "Polysulf"},
    Fluoropolymer  = {density = 1.65, short = "Fl.Poly"};

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

    function setMessage(screen, text)
        local html = [[<div style="width:100vw"><div style="margin-top: 20vw;padding: 10vw; font-size: 4em;width: 100vw;display: inline-block;">]]..text..[[</div></div>]] 
        screen.setHTML(html)
    end

    for slotName, slot in pairs(unit) do
        if slotValid(slot) then
            if slot.setHTML then 
                slot.activate()
                setMessage(slot, "If you see this you need to rename the screens...")
            elseif not databank and slot.getStringValue then
                databank = slot
                databank.setIntValue("master", 1)
                if debugId>0 then databank.setIntValue("debugId", debugId) end
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
                    local type, index = string.match(name, "(.*)Display(%d)")
                    --system.print("Display type: "..type.." index:"..index)
                    if type and index then
                        index = tonumber(index)
                        if type=="Cont" then
                            if containerDisplays[index] then
                                table.insert(containerDisplays[index], slot)
                            else
                                containerDisplays[index] = {slot}
                            end
                            setMessage(slot, "If you see this you may need to restart the master board")
                        elseif type=="Prod" then
                            if productionDisplays[index] then
                                table.insert(productionDisplays[index], slot)
                            else
                                productionDisplays[index] = {slot}
                            end
                            setMessage(slot, "If you see this you may need to restart the master board")
                        end
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

local displayStyle = "alignBottom"
if AlignTop then
    displayStyle = "alignTop"
end

--{font-family: monospace;text-transform:none;text-align:left;vertical-align:text-bottom;padding:20px;display:flex;flex-direction: column;}

local css = [[<style>
.alignTop,.alignBottom,.bar{font-family:monospace;color:white;text-align:left}
.alignTop,.alignBottom{display:flex;width:100vw;height:100vh}
.alignBottom{justify-content:flex-end;align-items:flex-end;margin:auto}
.bar{border-radius:4px}
.bar::after {content: attr(lab);font-weight:500;padding:5px}
table {width:100vw}
td,th,table{margin:0;padding:0;}
</style>]]

local H = {
    d1 = [[<div class="]]..displayStyle..[[">]],
    de = [[</div>]],

    t1 = [[<table style="font-size:4em;">]],
    t2 = [[<table style="font-size:2.6em">]],
    te = [[</table>]],

    r1 = [[<tr style="width:100vw; background-color: ]]..headerColour..[[; color: white;">]],
    r2 = [[<tr>]],
    re = [[</tr>]],

    th = [[<th>]],
    thL  = [[<th style="margin-left:20px">]],
    thL2 = [[<th style="margin-left:20px" colspan="2">]],
    thR  = [[<th style="text-align:right; margin-right:20px">]],

    th3 = [[<th style="background-color: ]]..headerColour..[[;">&nbsp;</th>]],
    th4 = [[<th colspan=9>&nbsp;</th>]],
    the = [[</th>]],

    nbr = [[<nobr>]],
    nbre = [[</nobr>]],
}

function refreshContainerDisplay(displays, force)
    -- Credit to badman74 for initial approach https://github.com/badman74/DU
    
    local outputData = {}

    function processSubstanceContainer(container)
        local contentMass = (core.getElementMassById(container.id) - container.selfMass) * (1.0 + PlayerContainerOptimization/100)
        local volume = contentMass/container.property.density

        local key = container.substance
        if container.overflow then key = "O_"..container.substance end

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

    function barGraph(width, percent, reverse)
        return [[<td width=]]..width..[[><div class="bar" lab="]]..string.format("%02.1f", percent)..[[%" style="background-color:]]..statusColour(percent, reverse)..[[;width:]]..percent..[[%"/></td>]]        
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

        local short = properties[substance].short     
        if overflow then
            if short then
                text = short.." Overflow"
            else
                text = text.." OF"
            end
        elseif text:len() > 10 and short then
            text = short
        end

        if not substanceData then
            if overflow then return nil end
            return "?", 0.0, "kℓ", text
        end

        local volume = substanceData.volume
        --system.print(key.." volume="..volume)
        local percent = math.min(100.0 * volume / substanceData.capacity, 100.0) -- densities are not accurate enough

        if volume >= 1000000 then return string.format("%02.1f", volume/1000000), percent, "Mℓ", text end
        return string.format("%02.1f", volume/1000), percent, "kℓ", text
    end

    
    function cellAlign(width, text, align) return [[<th width=]]..width..[[ style="text-align:]]..align..[[;"><nobr>]]..text..[[</nobr></th>]] end
    function cell(width, text) return [[<th width=]]..width..[[<nobr>]]..text..[[</nobr></th>]] end

    function newHTMLRow(id1, id2, overflow)
        local volume1, percent1, units1, text1 = displayFormat(id1, overflow)
        if not volume1 then return "" end
        --system.print(text1.." volume="..volume1.." units="..units1.." percent="..percent1)
        local volume2, percent2, units2, text2 = displayFormat(id2, overflow)
        --system.print(text2.." volume="..volume2.." units="..units2.." percent="..percent2)
        local converting = "&nbsp;" -- "⇒"
        --if overflow or not outputData[id1] or not outputData[id1].ore then converting = "&nbsp;" end
        return H.r2 
            ..cell("18%", text1)
            ..cellAlign("13%", volume1..units1, "right")
            ..barGraph("17%", percent1, overflow)
            ..H.th..converting..H.the
            ..cell("18%", text2)
            ..cellAlign("13%", volume2..units2, "right")
            ..barGraph("17%", percent2, overflow)
            ..H.re
    end

    local th1 = [[<th width=18%>]]
    local th2 = [[<th width=13%/><th width=17%/>]]
    
    function newHTMLHeader(text1, text2)
        return H.r1..[[<th width=48% colspan=3>]]..text1..[[</th><th/><th width=48% colspan=3>]]..text1..[[</th>]]..H.re
    end
    
    -- Add rows from the bottom up
    local rows = {}

    function addRow(t1, t2, overflow)
        rows[#rows+1] = {text1=t1, text2=t2, overflow=overflow}
    end

    function addHeaderRow(t1, t2)
        if not SkipHeadings then rows[#rows+1] = {text1=t1, text2=t2, header=true} end
    end

    addHeaderRow("T5 Ores", "T5 Pures")    -- 1
    addRow("Rhodonite", "Manganese")
    addRow("Columbite", "Niobium")
    addRow("Illmenite", "Titanium")
    addRow("Vanadinite", "Vanadium")

    addHeaderRow("T4 Ores", "T4 Pures")
    addRow("Cobaltite", "Cobalt")
    addRow("Cryolite", "Fluorine")
    addRow("GoldNuggets", "Gold")
    addRow("Kolbeckite", "Scandium")       --10

    addHeaderRow("Plastic", "Plastic")
    addRow("Polycarbonate", "Polycalcite")
    addRow("Polysulfide", "Fluoropolymer")

    addHeaderRow("Alloys", "Alloys")
    addRow("Silumin", "Steel")
    addRow("AlFe", "CaRefCu")
    addRow("Stainless steel", "Duralumin") -- 17    end - 19
  
    addHeaderRow("T3 Ores", "T3 Pures")
    addRow("Petalite", "Lithium")
    addRow("Garnierite", "Nickel")         -- 20
    addRow("Pyrite", "Sulfur")
    addRow("Acanthite", "Silver")

    addHeaderRow("T2 Ores", "T2 Pures")
    addRow("Natron", "Sodium")
    addRow("Malachite", "Copper")
    addRow("Limestone", "Calcium")
    addRow("Chromite", "Chromium")

    addHeaderRow("T1 Ores", "T1 Pures")
    addRow("Bauxite", "Aluminium")
    addRow("Hematite", "Iron")             -- 30
    addRow("Coal", "Carbon")
    addRow("Quartz", "Silicon")

    addHeaderRow("H₂", "O₂")
    addRow("Hydrogen", "Oxygen")
    addRow("Hydrogen", "Oxygen", true)     -- 35

    function addDisplayRows(dId)
        local html=H.d1..H.t2
        local startRow = #rows - ContRowsPerScreen * dId + 1
        local endRow = startRow + ContRowsPerScreen - 1
        startRow = math.max(startRow , 1)
        --system.print("row range "..startRow..":"..endRow)
        for i = startRow, endRow do
            local row = rows[i]
            if not row then break end
            if row.header then 
                html=html..newHTMLHeader(row.text1, row.text2)
            else
                html=html..newHTMLRow(row.text1, row.text2, row.overflow)
            end
            i = i + 1
        end
        html=html..H.te..H.de
        return html
    end

    for d, display in pairs(displays) do
        --system.print("Displaying on: "..core.getElementNameById(display.getId()).." @"..d)
        local html = addDisplayRows(d)
        for _, mirror in pairs(display) do
            mirror.setHTML(css..html)
        end
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
]]..H.thL..H.nbr..text1..H.nbre..[[</th>
]]..H.thL..H.nbr..text2..H.nbre..[[</th>
]]..H.thR..H.nbr..text3..H.nbre..[[</th>
]]..H.thL..H.nbr..text4..H.nbre..[[</th>
</tr>]]
        return resHTML
    end

    function processData(key, force)
        --system.print("Process Data key="..key)
        local id = tonumber(key)
        if not id then return end
        debug(id, "Processing #"..id)
        
        local updated = databank.getIntValue(id.."_updated")
        if not force and updated~=1 then
            debug(id, "Skipping #"..id.." (not changed)")
            return 
        end

        local infoJson = databank.getStringValue(id)
        if infoJson==nil or infoJson=="" then
            debug(id, "Skipping #"..id.." (data missing)")
            return 
        end

        local info = json.decode(infoJson)
        
        if (not info or type(info)~="table" or not info.status) then 
            debug(id, "Skipping #"..id.." (data invalid)")
            return 
        end

        debug(id, id.." status="..info.status)
        local name = core.getElementNameById(id)
        local machine = core.getElementTypeById(id)
        if (machine=="assembly line") then
            local sizeIndex, size = assemblySize(id)
            local product = ""
            if not string.find(name, "%[") then
                product = name
            end
            debug(id, id.." Assembly "..assemblySize(id).." : "..info.status)
            assemblies[sizeIndex * 10000 + id] = {name=name, size=size, id=id, product=product, status=info.status}
        else
            local alertKey = machine.."_"..name.."_"..id
            debug(id, id.." : "..machine.."["..name.."] : "..info.status)
            if info.status:find("JAMMED") == 1 then       
                alerts[alertKey] = {name=name, machine=machine, id=id, status=info.status}
            else
                alerts[alertKey] = nil
            end
        end
        if updated==1 then
            dataUpdates[id] = 1
        end
    end

    local keyJson = databank.getKeys()
    if keyJson==nil or keyJson=="" then return end
    local keys = json.decode(keyJson)
    for _,key in ipairs(keys) do
        processData(key, force)
    end
    processDataUpdates()

    -- Sort the assemblies
    local tkeys = {}
    for k in pairs(assemblies) do table.insert(tkeys, k) end
    table.sort(tkeys)

    if displayLow then
        local html=H.d1..H.t1

        html=html..H.r1..H.thL.."&nbsp;"..H.the..H.thL2.."Assm. - Making"..H.the..H.thR.."#&nbsp;"..H.the..H.thL.."Status"..H.the..H.re

        for _, k in ipairs(tkeys) do
            local assembly = assemblies[k]
            local colour = alarmColour
            local status = assembly.status
            if status == "JAMMED_MISSING_INGREDIENT" then
                if WaitingAsAlarm then       
                    colour = alarmColour
                else
                    colour = neutralColour
                end
                status = "WAITING"
            elseif status == "RUNNING" then       
                colour = goodColour
            elseif status == "STOPPED" 
                or status == "PENDING" then       
                colour = idleColour
            elseif status:find("JAMMED") == 1 then       
                colour = alarmColour
            end
            --system.print(assembly.size.." ["..assembly.id.."] :"..status.. " ("..colour..")")
            html=html..newHTMLRow(assembly.size, assembly.product, assembly.id.."&nbsp;", status, colour, FontSize)
        end

        html=html..H.te..H.de
        for _, mirror in pairs(displayLow) do
            mirror.setHTML(css..html)
        end
    end

    -- Sort the alerts
    local alertkeys = {}
    for k in pairs(alerts) do table.insert(alertkeys, k) end
    table.sort(alertkeys)

    local shortTypes = {
        ["electronics industry"] = "Elec. ind.",
        ["chemical industry"] = "Chem. ind.",
        ["metalworks industry"] = "Met. ind.",
    }
    if displayHigh then
        local html=H.d1..H.t1

        html=html..H.r1..H.thL.."&nbsp;"..H.the..H.thL2.."Machine"..H.the..H.thR.."#"..H.the..H.thL.."Alert"..H.the..H.re

        for _, k in ipairs(alertkeys) do
            local alert = alerts[k]
            local colour = alarmColour
            local status = alert.status
            if status == "JAMMED_MISSING_INGREDIENT" then       
                if WaitingAsAlarm then       
                    colour = alarmColour
                else
                    colour = neutralColour
                end
                status = "WAITING"
            elseif status == "JAMMED_OUTPUT_FULL" then       
                colour = alarmColour
                status = "OUTPUT FULL"
            elseif status:find("JAMMED") == 1 then       
                colour = alarmColour
            end
            local type = alert.machine
            if shortTypes[type] then type = shortTypes[type] end
            html=html..newHTMLRow(type, alert.name, alert.id.."&nbsp;", status, colour, FontSize)
        end

        html=html..H.te..H.de
        for _, mirror in pairs(displayHigh) do
            mirror.setHTML(html)
        end
    end

end

function refreshScreens(force)
    refreshContainerDisplay(containerDisplays, force)
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
    local maxToProcess = DataThrottle
    for key, info in pairs(dataUpdates) do
        maxToProcess = maxToProcess - 1
        if maxToProcess==0 then return end
        debug(key, "Resetting update flag for "..key)
        databank.setIntValue(key.."_updated", 0)
        dataUpdates[key] = nil
    end
    -- TODO investigate race condition?
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
if debugId > 0 then system.print("Debugging #"..debugId) end
onStart()

unit.setTimer("First", 1)
unit.setTimer("Live", 7)
unit.setTimer("WriteData", 3)