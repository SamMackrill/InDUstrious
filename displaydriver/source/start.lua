local version = "V2.1.6"

PlayerContainerProficiency = 30 --export Your Container Proficiency bonus in total percent (Skills->Mining and Inventory->Inventory Manager)
PlayerContainerOptimization = 0 --export Your Container Optimization bonus in total percent (Skills->Mining and Inventory->Stock Control)
LowLevel = 25 --export Percent for low level indicator
HighLevel = 50 --export Percent for high level indicator
ContainerMatch = "C_(.+)" --export Match for single item Storage Container names (e.g. "C_Hematite")
OverflowMatch = "O_(.+)" --export Match for single item Overflow Container names (e.g. "O_Hydrogen")
DisplayBlocks = "t5 t4 gl pl a1 t3 t2 t1 ga" --export Container types to display from top to bottom (t1-t5, pl, al, a1, a2, ga, gl)
ContRowsPerScreen = 20 --export Container rows per screen
ProdRowsPerScreen = 24 --export Production rows per screen
AlignTop = false --export Align with top of screen
WaitingAsAlarm = false --export Display waiting state with alarm colour
KeepBlocksTogether = false  --Don't break blocks across displays
AnalyseThrottle = 400 --export Maximum Core Elements to process at once, lower this if you get an immediate CPU overload
DataThrottle = 50 --export Maximum changes to process each update, lower this if you get CPU overloads after some time
AnalyseDelay = .3 --export Rate at which core elements are initially analysed
FirstDelay = .3 --export Delay before First calculations after analyse completes
RefreshDelay = 5 --export Screen Refresh Rate
MonitorDelay = 3 --export Rate at which changes are processed
SkipHeadings = false --export No substance headings
US_Spellings = false --export Expect American spellings

contGap = 1.33 --export Cont Table gap (temporary)
prodGap = 0.4 --export Prod Table gap (temporary)
prodBase = 95 --export Prod Table base (temporary)
prodScale = 1.0 --export Prod Table scale (temporary)

contDebug = false --export Container Debug Flag
overloadDebug = false --export CPU overload Debug Flag

local prodFontSize =  prodScale * (prodBase / ProdRowsPerScreen - prodGap)
--alertFontSize = 100 / AlertRowsPerScreen - gap
local contFontSize = 100 / ContRowsPerScreen - contGap

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
    GoldNuggets = {density = 19.3,   ore = true, short="GoldNug"},
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
    Inconel             = {density = 8.5};
    ["Maraging steel"]  = {density = 8.23, short = "M.Steel"};
    ["Red gold"]        = {density = 14.13};
    ScAl                = {density = 2.85};

    Polycarbonate  = {density = 1.4,  short = "Polycarb"},
    Polycalcite    = {density = 1.5,  short = "Polycalc"},
    Polysulfide    = {density = 1.6,  short = "Polysulf"},
    Fluoropolymer  = {density = 1.65, short = "Fl.Poly"};

    Glass                     = {density = 2.5},
    ["Advanced glass"]        = {density = 2.6,  short = "Adv.Glass"},
    ["AgLi reinforced glass"] = {density = 2.8,  short = "AgLi Glass"},
    ["Gold coated glass"]     = {density = 3.0,  short = "Gold Glass"},

}


local blocks = {
    t5 = {    
       Headers = {"T5 Ores", "T5 Pures"},
       Rows = {
            {"Rhodonite", "Manganese"},
            {"Columbite", "Niobium"},
            {"Illmenite", "Titanium"},
            {"Vanadinite", "Vanadium"},
        },
    },
    t4 = {    
        Headers = {"T4 Ores", "T4 Pures"},
        Rows = {
            {"Cobaltite", "Cobalt"},
            {"Cryolite", "Fluorine"},
            {"GoldNuggets", "Gold"},
            {"Kolbeckite", "Scandium"},
        },
    },
    pl = {    
        Headers = {"Plastic", "Plastic"},
        Rows = {
            {"Polycarbonate", "Polycalcite"},
            {"Polysulfide", "Fluoropolymer"},
        },
    },
    gl = {    
        Headers = {"Glass", "Glass"},
        Rows = {
            {"Glass", "Advanced glass"},
            {"AgLi reinforced glass", "Gold coated glass"},
        },
    },
    al = {    
        Headers = {"Alloys", "Alloys"},
        Rows = {
            {"Silumin", "Duralumin"},
            {"AlFe", "CaRefCu"},
            {"Steel", "Stainless steel"},
            {"AlLi", "Inconel"},
            {"CuAg", "Maraging steel"},
            {"Red gold", "ScAl"},
        },
    },
    a1 = {    
        Headers = {"Alloys", "Alloys"},
        Rows = {
            {"Silumin", "Duralumin"},
            {"AlFe", "CaRefCu"},
            {"Steel", "Stainless steel"},
        },
    },
    a2 = {    
        Headers = {"Alloys", "Alloys"},
        Rows = {
            {"AlLi", "Inconel"},
            {"CuAg", "Maraging steel"},
            {"Red gold", "ScAl"},
        },
    },
    t3 = {    
        Headers = {"T3 Ores", "T3 Pures"},
        Rows = {
            {"Petalite", "Lithium"},
            {"Garnierite", "Nickel"},
            {"Pyrite", "Sulfur"},
            {"Acanthite", "Silver"},
        },
    },
    t2 = {    
        Headers = {"T2 Ores", "T2 Pures"},
        Rows = {
            {"Natron", "Sodium"},
            {"Malachite", "Copper"},
            {"Limestone", "Calcium"},
            {"Chromite", "Chromium"},
        },
    },
    t1 = {    
        Headers = {"T1 Ores", "T1 Pures"},
        Rows = {
            {"Bauxite", "Aluminium"},
            {"Hematite", "Iron"},
            {"Coal", "Carbon"},
            {"Quartz", "Silicon"},
        },
    },
    ga = {
        Headers = {"H₂", "O₂"},
        Rows = {
            {"Hydrogen", "Oxygen"},
            {"Hydrogen", "Oxygen", true},
        },
    },
}

local shortTypes = {
    ["electronics industry"] = "Elec. ind.",
    ["chemical industry"] = "Chem. ind.",
    ["metalworks industry"] = "Met. ind.",
}

local tiers = {
    basic = 1,
    uncommon = 2,
    advanced = 3,
    rare= 4,
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
local industries = {}
local assemblies = {}
local alerts = {}
local schematicMainProduct = {[0]="No Schematic Set"}
local monitorIndex = 1
local highlight = {on=false, id=0, stickers={}}
local coreWorldOffset = 0

function onStart()

    if overloadDebug then system.print("onStart") end
    function setMessage(screen, text)
        local html = [[<div style="width:100vw"><div style="margin-top: 20vw;padding: 10vw; font-size: 4em;width: 100vw;display: inline-block;">]]..text..[[</div></div>]] 
        screen.setHTML(html)
    end

    -- Process connected slots
    for slotName, slot in pairs(unit) do
        if slotValid(slot) then
            if slot.setHTML then 
                slot.activate()
                setMessage(slot, "If you see this you need to rename the screens...")
            elseif not databank and slot.getStringValue then
                databank = slot
            elseif not core and slot.getConstructId then
                core = slot
            end
        end
    end

    if not core then 
        for slotName, slot in pairs(unit) do
            if slotValid(slot) then
                if slot.setHTML then 
                    setMessage(slot, "Core Unit must be connected to the master board")
                end
            end
        end
        return 
    end

    coreWorldOffset = 2 ^ math.floor(math.log(core.getMaxHitPoints(),10) + 3)

    -- Find displays
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
                                containerDisplays[index].screens[id] = slot
                            else
                                containerDisplays[index] = {screens={[id]=slot}}
                            end
                            setMessage(slot, "If you see this you may need to restart the master board")
                        elseif type=="Prod" then
                            if productionDisplays[index] then
                                productionDisplays[index].screens[id] = slot
                            else
                                productionDisplays[index] = {screens={[id]=slot}}
                            end
                            setMessage(slot, "If you see this you may need to restart the master board")
                        end
                    end
                end
            end
        end
    end
end

function analyseCore()

    if overloadDebug then system.print("Analyse Core") end

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

    function addContainer(id, type)
        if #containerDisplays==0 then return false end
        --if id==172 then system.print("Checking "..type.." ["..id.."]") end
        if not string.lower(type):match("^container") then  return false end
        local name = core.getElementNameById(id)
        if not name then return true end

        if contDebug then system.print("Checking container: "..name.." ["..id.."] against name matches") end
        local overflow = false
        local substance = string.match(name, "^"..ContainerMatch)
        if not substance then 
            substance = string.match(name, "^"..OverflowMatch)
            if not substance then
                if contDebug then system.print("  Ignoring because no name match") end
                return 
            end
            overflow = true
        end

        local property = properties[substance]
        if not property then 
            if contDebug then system.print("  Ignoring because "..substance.." not tracked") end
            return true 
        end

        local selfMass, baseVolume = getBaseCointainerProperties(id)
        capacity = baseVolume*(1.0 + PlayerContainerProficiency/100)

        if contDebug then system.print("Adding container: "..name.." ["..id.."] storing "..substance) end
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
        return true
    end

    function addIndustry(id, type)
        if #productionDisplays==0 then return false end

        local tier, machine = string.match(type, "(%S+)%s(.+)")
        if not tier or not machine then return false end
        --if id==65 then 
        --    system.print("type: >"..type.."<")
        --    system.print("tier: >"..tier.."< : >"..machine.."<")
        --end
        local lowTier = string.lower(tier)
        if not tiers[lowTier] then return false end
        local name = core.getElementNameById(id)
        --system.print("Adding "..machine..": "..name.. " ["..id.."]")

        local lowMachine = string.lower(machine)
        local shortType = shortTypes[lowMachine] or machine
        --system.print(id.." : "..machine.."["..name.."]")
        local industry = {name=name, industry=machine, shortType=shortType, id=id, tier=lowTier}
        if lowMachine=="assembly line" then
            industry.assembly = true
            local sizeIndex, size = assemblySize(id)
            industry.sortKey = sizeIndex * 100000 + tiers[lowTier] * 10000 + id
            industry.size = size
            --system.print(id.." Assembly "..industry.name.." "..size)
        else
            industry.sortKey = machine.."_"..name.."_"..id
        end
        table.insert(industries, industry)
        return true
    end
    
    -- Find Containers and Industry
    local elementsIds = core.getElementIdList()
    local maxToProcess = AnalyseThrottle
    local leftToProcess = #elementsIds
    for _,id in ipairs(elementsIds) do
        local type = core.getElementTypeById(id)
        --system.print("Element: "..core.getElementNameById(id).." : "..type.. " ["..id.."]")
        if not addContainer(id, type) then
            addIndustry(id, type)
        end
        maxToProcess = maxToProcess - 1
        leftToProcess = leftToProcess - 1
        if maxToProcess==0 then 
            coroutine.yield(leftToProcess)
            maxToProcess = AnalyseThrottle
        end
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
    darkYellow= "#666633",
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
.alignTop,.alignBottom{display:flex;width:100vw;height:100vh;padding:2px}
.alignBottom{justify-content:flex-end;align-items:flex-end;margin:auto}
.bar{border-radius:4px;border:1px solid white;margin:2px;}
.bar::after{content: attr(lab);font-weight:600;padding:5px}
table{width:100vw}
td,th,table{margin:0;padding:0}
</style>]]

local H = {
    d1 = [[<div class="]]..displayStyle..[[">]],
    de = [[</div>]];

    tc = [[<table style="font-size:]]..contFontSize..[[vh">]],
    tp = [[<table style="font-size:]]..prodFontSize..[[vh">]],
    te = [[</table>]];

    tr  = [[<tr>]],
    tr2 = [[<tr style="background-color:]]..headerColour..[[;">]],
    tre = [[</tr>]];

    th   = [[<th>]],
    thL  = [[<th style="margin-left:20px">]],
    thL2 = [[<th style="margin-left:20px" colspan="2">]],
    thR  = [[<th style="text-align:right">]],
    th3  = [[<th style="background-color:]]..headerColour..[[;">&nbsp;</th>]],
    the  = [[</th>]];

    nbr = [[<nobr>]],
    nbre = [[</nobr>]];
}

    
function cell(width, text, align, colour, size)
    local style = ""
    if align then style = style.." text-align:"..align..";" end
    if colour then style = style.." color:"..colour..";" end
    if size then style = style.." font-size:"..size..";" end
    if style then style = [[ style="]]..style..[["]] end
    return [[<th width=]]..width..style..[[><nobr>]]..text..[[</nobr></th>]]
end

function refreshContainerDisplay(displays)
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
        if contDebug then 
            system.print(container.name.." "..container.substance.." : contentMass : "..outputData[key].contentMass)
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

    function barGraph(width, percent, colour)
        return [[<td width=]]..width..[[><div class="bar" lab="]]..string.format("%02.1f", percent)..[[%" style="background-color:]]..colour..[[;width:]]..percent..[[%"/></td>]]        
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


    function addSubstanceDisplay(text1, text2, percent, reverse, volume)
        local colour = statusColour(percent, reverse)
        local textColour = false
        if colour==alarmColour and volume~="?" then textColour=alarmColour end
        return cell("18%", text1, false, textColour)
             ..cell("13%", text2, "right")
             ..barGraph("17%", percent, colour)
    end

    function newHTMLRow(row)
        local volume1, percent1, units1, text1 = displayFormat(row.text1, row.overflow)
        if not volume1 then return "" end
        --system.print(text1.." volume="..volume1.." units="..units1.." percent="..percent1)
        local volume2, percent2, units2, text2 = displayFormat(row.text2, row.overflow)
        --system.print(text2.." volume="..volume2.." units="..units2.." percent="..percent2)
        local converting = "&nbsp;" -- "⇒"
        --if overflow or not outputData[id1] or not outputData[id1].ore then converting = "&nbsp;" end
        local colour2 = statusColour(percent2, row.overflow)
        local textColour2 = false
        if colour2==alarmColour and volume2~="?" then textColour2=alarmColour end
        return H.tr
            ..addSubstanceDisplay(text1, volume1..units1, percent1, row.overflow, volume1)
            ..H.th..converting..H.the
            ..addSubstanceDisplay(text2, volume2..units2, percent2, row.overflow, volume2)
            ..H.tre
    end
   
    function newHTMLHeader(row)
        return H.tr2..[[<th width=48% colspan=3>]]..row.text1..[[</th><th/><th width=48% colspan=3>]]..row.text2..[[</th>]]..H.tre
    end
    
    local rows = {}

    function addRow(t1, t2, overflow)
        rows[#rows+1] = {text1=t1, text2=t2, overflow=overflow}
    end

    function addHeaderRow(t1, t2)
        if not SkipHeadings then rows[#rows+1] = {text1=t1, text2=t2, header=true} end
    end

    for key in DisplayBlocks:gmatch("%S+") do
        local block = blocks[key]
        addHeaderRow(block.Headers[1], block.Headers[2])
        for _, row in ipairs(block.Rows) do
            addRow(row[1], row[2], row[3])
        end
    end

    function addDisplayRows(dId)
        local displayRows = {}
        local html=H.d1..H.tc
        local startRow = #rows - ContRowsPerScreen * dId + 1
        local endRow = startRow + ContRowsPerScreen - 1
        startRow = math.max(startRow , 1)
        --system.print("row range "..startRow..":"..endRow)
        for i = startRow, endRow do
            local row = rows[i]
            if not row then break end
            table.insert(displayRows, row)
            if row.header then 
                html=html..newHTMLHeader(row)
            else
                html=html..newHTMLRow(row)
            end
            i = i + 1
        end
        html=html..H.te..H.de
        return html, displayRows
    end

    for d, displaySet in pairs(displays) do
        local html, displayRows = addDisplayRows(d)
        displaySet.rows = displayRows
        for id, display in pairs(displaySet.screens) do
            --system.print("Displaying "..#displayRows.." rows on #"..id..": "..core.getElementNameById(id).." set@"..d)
            display.setHTML(css..html)
        end
    end
end

function refreshIndustryScreens(displays)
    local rows = {}

    function addRow(id, t1, t2, t3, t4, colour, size)
        rows[#rows+1] = {id=id, text1=t1, text2=t2, text3=t3, text4=t4, colour=colour, size=size}
    end

    function addHeaderRow(t1, t2, t3, t4)
        if not SkipHeadings then rows[#rows+1] = {text1=t1, text2=t2, text3=t3, text4=t4, header=true} end
    end

    -- Sort the alerts
    local alertkeys = {}
    for k in pairs(alerts) do table.insert(alertkeys, k) end
    table.sort(alertkeys)

    -- Sort the assemblies
    local assemkeys = {}
    for k in pairs(assemblies) do table.insert(assemkeys, k) end
    table.sort(assemkeys)

    local checkingTotal = #industries - #assemkeys
    addHeaderRow("Machine", "Making ["..#alertkeys.."/"..checkingTotal.."]", "#", "Alert")
    for _, k in ipairs(alertkeys) do
        local alert = alerts[k]
        local colour = alarmColour
        local state = alert.status.state
        if state == "JAMMED_MISSING_INGREDIENT" then       
            if WaitingAsAlarm then       
                colour = alarmColour
            else
                colour = neutralColour
            end
            state = "WAITING"
        elseif state == "JAMMED_OUTPUT_FULL" then       
            colour = alarmColour
            state = "OUTPUT FULL"
        elseif state:find("JAMMED") == 1 then       
            colour = alarmColour
        end
        local product = schematicMainProduct[alert.status.schematicId]
        addRow(alert.id, alert.shortType, product, alert.id, state, colour, alertFontSize)
    end
    
    if #assemkeys>0 then 
        addHeaderRow("Assm.", "Making", "#", "Status")
        for _, k in pairs(assemkeys) do
            local assembly = assemblies[k]
            local colour = alarmColour
            local state = assembly.status.state
            if state == "JAMMED_MISSING_INGREDIENT" then
                if WaitingAsAlarm then       
                    colour = alarmColour
                else
                    colour = neutralColour
                end
                state = "WAITING"
            elseif state == "RUNNING" then       
                colour = goodColour
            elseif state == "STOPPED" 
                or state == "PENDING" then       
                colour = idleColour
            elseif state == "JAMMED_OUTPUT_FULL" then       
                colour = alarmColour
                state = "OUTPUT FULL"
            elseif state == "JAMMED_NO_OUTPUT_CONTAINER" then       
                colour = alarmColour
                state = "NO OUT"
            elseif state:find("JAMMED") == 1 then       
                colour = alarmColour
            end
            --if assembly.id==65 then 
            --    system.print(assembly.tier.." "..assembly.size.." ["..assembly.id.."] :"..state.." schem="..assembly.status.schematicId.." ("..colour..")")
            --end
            local product = schematicMainProduct[assembly.status.schematicId]
            addRow(assembly.id, assembly.size.."-T"..tiers[assembly.tier], product, assembly.id, state, colour)
        end
    end

    function newHTMLRow(row)
        local style = ""
        if row.colour then style = style.." color:"..row.colour..";" end

        if highlight.on and row.id==highlight.id then style = style.." background-color:"..tolColours.darkYellow..";" end

        if style then style = [[ style="]]..style..[["]] end

        return [[<tr]]..style..[[>
]]..H.thL..[[&nbsp;</th>
]]..H.thL..H.nbr..row.text1..H.nbre..[[</th>
]]..H.thL..H.nbr..row.text2..H.nbre..[[</th>
]]..H.thR..H.nbr..row.text3..H.nbre..[[&nbsp;</th>
]]..H.thL..H.nbr..row.text4..H.nbre..[[</th>
</tr>]]
    end

    function newHTMLHeader(row)
        return H.tr2..[[<th width=2%/><th width=24%>]]..row.text1..[[</th><th>]]..row.text2
        ..[[</th><th width=8% style="text-align:right">]]..row.text3..[[&nbsp;</th><th width=15%>]]..row.text4
        ..[[</th>]]..H.tre
    end

    function addDisplayRows(dId)
        --system.print("display="..dId.." rows="..#rows.." rps="..ProdRowsPerScreen)
        local displayRows = {}
        local html=H.d1..H.tp
        local startRow = #rows - ProdRowsPerScreen * dId + 1
        local endRow = startRow + ProdRowsPerScreen - 1
        startRow = math.max(startRow , 1)
        --system.print("row range "..startRow..":"..endRow)
        for i = startRow, endRow do
            local row = rows[i]
            if not row then break end
            table.insert(displayRows, row)
            if row.header then 
                html=html..newHTMLHeader(row)
            else
                html=html..newHTMLRow(row)
            end
            i = i + 1
        end
        html=html..H.te..H.de
        return html, displayRows
    end

    for d, displaySet in pairs(displays) do
        local html, displayRows = addDisplayRows(d)
        displaySet.rows = displayRows
        for id, display in pairs(displaySet.screens) do
            --system.print("Displaying "..#displayRows.." rows on: "..core.getElementNameById(id).." @"..d)
            display.setHTML(css..html)
        end
    end

end

function refreshScreens()
    refreshContainerDisplay(containerDisplays)
    refreshIndustryScreens(productionDisplays)
end

function processFirst()
    if contDebug or overloadDebug then system.print("Tick First") end
    unit.stopTimer("First")
    refreshScreens()
end

function processChanges()

    if contDebug or overloadDebug then system.print("Tick Statuses") end

    function lookupSchematic(schematicId)
        if schematicMainProduct[schematicId] then return end
        local schematicJson = core.getSchematicInfo(schematicId)
        local schematic = json.decode(schematicJson)
        if not schematic.products then
            --system.print("Schematic #"..schematicId)
            --system.print(schematicJson)
            schematicMainProduct[schematicId] = "Unknown#"..schematicId
            return;
        end
        schematicMainProduct[schematicId] = schematic.products[1].name
    end

    function processStatus(industry)    

        local statusJson = core.getElementIndustryStatus(industry.id)
        local status = json.decode(statusJson)
        industry.status = status

        if industry.assembly then
            lookupSchematic(status.schematicId)
            --system.print("Assembly: "..industry.name.." ["..industry.id.."] making:"..schematicMainProduct[status.schematicId])
            assemblies[industry.sortKey] = industry
            return 
        end

        if status.state and status.state:find("JAMMED") == 1 then       
            lookupSchematic(status.schematicId)
            --system.print("Alert: "..industry.name.." ["..industry.id.."] making:"..schematicMainProduct[status.schematicId])
            alerts[industry.sortKey] = industry
        else
            alerts[industry.sortKey] = nil
        end
    end

    local maxToProcess = math.min(DataThrottle, #industries)
    if overloadDebug then system.print("#industries="..#industries.." max="..maxToProcess.." DataThrottle="..DataThrottle)  end
    
    local index = monitorIndex
    for i = 1, maxToProcess do
        processStatus(industries[index])
        index = index + 1
        if index > #industries then index = 1 end
    end
    --system.print("Checked: "..monitorIndex..":"..index-1)
    monitorIndex = index
end


function processTick()   
    if contDebug or overloadDebug then system.print("Tick Live") end
    --local ok, msg = xpcall(function ()

        refreshScreens()

    --end, traceback)

    --if not ok then
      --system.print(msg)
    --end
end

function onStop()
    for _, slot in pairs(unit) do
        if slotValid(slot) then
            if slot.setHTML then slot.clear() end
        end
    end    
end

function HideHighlight()
    highlight.on = false
    if #highlight.stickers == 0 then return end
    --system.print("Highlighting off")
    for i in pairs(highlight.stickers) do
        core.deleteSticker(highlight.stickers[i])
    end
    highlight.stickers = {}
end

function ShowHighlight()
    highlight.on = true
    table.insert(highlight.stickers, core.spawnArrowSticker(highlight.x + highlight.xoffset, highlight.y, highlight.z, "north"))
    table.insert(highlight.stickers, core.spawnArrowSticker(highlight.x, highlight.y - highlight.yoffset, highlight.z, "east"))
    table.insert(highlight.stickers, core.spawnArrowSticker(highlight.x - highlight.xoffset, highlight.y, highlight.z, "south"))
    table.insert(highlight.stickers, core.spawnArrowSticker(highlight.x, highlight.y + highlight.yoffset, highlight.z, "west"))
    table.insert(highlight.stickers, core.spawnArrowSticker(highlight.x, highlight.y, highlight.z - highlight.zoffset, "up"))
    table.insert(highlight.stickers, core.spawnArrowSticker(highlight.x, highlight.y, highlight.z + highlight.zoffset, "down"))
end

-- Credit to DorianTheGrey for approach
function HighlightElement(id)
    --system.print("Highlighting id="..id)
    if highlight.on then HideHighlight() end
    highlight.id = id
    local pos = vec3(core.getElementPositionById(id))
    highlight.x = pos.x - coreWorldOffset
    highlight.y = pos.y - coreWorldOffset
    highlight.z = pos.z - coreWorldOffset
    --local rot = core.getElementRotationById(id)
    --system.print("Rot="..json.encode(rot))
    local size = 3.1 * (math.log(core.getElementMassById(id), 10) - 1.0)
    --system.print("Size="..size)
    highlight.xoffset = size
    highlight.yoffset = size
    highlight.zoffset = size
    ShowHighlight()
end

function screenClicked(x, y, id, screen, rows)
    --system.print("Clicked on #"..id.." : "..core.getElementNameById(id).." @("..x..", "..y..")")

    --system.print("Display has "..#rows)
    local rowIndex = math.floor(#rows - ProdRowsPerScreen * (1- y) + 1)
    --system.print("rowIndex "..rowIndex)
    local row = rows[rowIndex]
    --system.print("row id "..tostring(row.id))
    if not row.id then return end

    if row.id == highlight.id then   
        HideHighlight()
    else
        HighlightElement(row.id)
    end 
    refreshIndustryScreens(productionDisplays, false)
end

function onClick(x, y)
    --system.print("Click: ("..x..", "..y..")")
    for d, displaySet in pairs(productionDisplays) do
        for id, screen in pairs(displaySet.screens) do
            --system.print("Checking #"..id.." : "..core.getElementNameById(id))
            --system.print("  X: "..tostring(screen.getMouseX()))
            --system.print("  Y: "..tostring(screen.getMouseY()))
            if screen.getMouseX() ~= -1 and screen.getMouseY() ~= -1 then
                screenClicked(x, y, id, screen, displaySet.rows)
                return
            end
        end
    end
end

function processAnalysis()   
    unit.stopTimer("Analyse")
    if overloadDebug then system.print("Analyse Tick") end
    local _, elementsLeft = coroutine.resume(AnalyseCo)
    if elementsLeft then
       if overloadDebug then system.print("Analyse yielded, elements left: "..elementsLeft) end
       unit.setTimer("Analyse", AnalyseDelay)
       return
    end

    unit.setTimer("First", FirstDelay)
    unit.setTimer("Live", RefreshDelay)
    unit.setTimer("MonitorChanges", MonitorDelay)

end

--unit.hide()
system.print("InDUstry Status "..version)
local databank = nil

onStart()

if not core then
    system.print("InDUstrious Error: Core must be linked to a slot")
else
    AnalyseCo = coroutine.create(analyseCore)
    unit.setTimer("Analyse", AnalyseDelay)
end