# InDUstrious
Screens for a Dual Universe Industrial Control Room, by Smacker: 
###### In game: Smacker, Discord: Smacker#5268
Discord Channel: https://discord.gg/Gw5HWJhXFR

<img src="images/mon01.png" height="320" alt="Alerts"> <img src="images/mon02.png" height="320" alt="Ores & Pures">

### Introduction
Screen based factory monitor, simulating a real control room
* Can monitor container contents if they have a single item
* Can designate containers as overflows
* Can monitor industry unit states and display any issues (like being jammed)
  * Will not clutter the display with units that are in a normal state (running, pending, stopped etc)
* Find function, will decorate clicked industry unit with arrows
* Supports US spellings

### Notes
* Industry units running normally are not shown
* Restart the master board if you rename anything
* Sometimes displays show as blank grey screens, restart the game to fix this (known NQ bug)
* Config links are to latest versions, for earlier versions see the releases
  * To install in game on a programming board: Right-click -> Advanced -> Paste Lua configuration from clipboard

Wiki has FAQ: https://github.com/SamMackrill/InDUstrious/wiki 

<img src="images/factory.png" height="320" alt="Factory">


## In Game Setup
* Name the containers (including hubs) as C_XXXX where XXXX is the name of what is being stored e.g. C_Bauxite
  * If you have multiple containers and hubs with the same content then name them all the same
* Name the overflow containers (including hubs) as O_XXXX where XXXX is the name of what is being stored e.g. O_Hydrogen
* Some substance names cannot be matched exactly as NQ forbid certain characters in custom names (see below for list)
* Add large/medium screens, 2 x 2 layout of large screens seems best
* Rename the screens (not the slots) exactly:
  * ContDisplay1, ContDisplay2, ContDisplay3 etc
  * ProdDisplay1, ProdDisplay2, ProdDisplay3 etc
  * You can have as many screeens as you have spare slots on the master board
  * To mirror a display connect a screen with the same name e.g. add another screen called ContDisplay1

### Installation
* Add a programming board
* Connect the core and screens to the programming board (any order, do not rename any of the slots)
* Copy the [master_config.json](https://raw.githubusercontent.com/SamMackrill/InDUstrious/main/displaydriver/config/master_config.json) and paste it into the programming board
* A databank is optional and not used currently

### Upgrading from V1.x.x
* Remove all monitor programming boards, databanks and repeaters
   * All data is now obdained directly from the core

### Installation - Optional
* Tweak the behaviour by right clicking the master programming board -> Advanced -> Edit Lua Parameters
<img src="images/menu.png" height="320" alt="Menu">
<img src="images/settings.png" alt="Settings">

## Substance name list

_ | _ | _ | _ | _ | _ | _ | _
-- | -- | -- | -- | -- | -- | -- | --
Acanthite | AlFe | AlLi | Aluminium | Bauxite | Calcium | Carbon | CaRefCu
Chromite | Chromium | Coal | Cobalt | Cobaltite | Columbite | Copper | Cryolite
CuAg | Duralumin | Fluorine | Fluoropolymer | Garnierite | Gold | GoldNuggets | Hematite
Hydrogen | Illmenite | Iron | Kolbeckite | Limestone | Lithium | Malachite | Manganese
Natron | Nickel | Niobium | Oxygen | Petalite | Polycalcite | Polycarbonate | Polysulfide
Pyrite | Quartz | Rhodonite | Scandium | Silicon | Silumin | Silver | Sodium
Stainless steel | Steel | Sulfur | Titanium | Vanadinite | Vanadium

## Credits
* badman74 for initial approach: https://github.com/badman74/DU
* DU Open Source Initiative
