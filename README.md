# InDUstrious
Screens for a Dual Universe Industrial Control Room

<img src="images/mon01.png" height="320" alt="Alerts"> <img src="images/mon02.png" height="320" alt="Ores & Pures">

### Introduction
TBD

### How it works - Simple
<img src="images/industrious_simple.png" height="320" alt="Diagram">

### Installation - Simple
#### Master Only
* Add a databank
* Add 4 large screens
* Add a programming board
* Connect the core and databank and screens to the programming board
* Name the screens
* Paste the display driver config into the programming board
* Add up to 9 monitor programming boards
* Connect up to 9 industries and the databank to the monitor programming board
* Paste the monitor config into all the monitor programming boards
* Name the containers as C_XXXX where XXXX is the name of what is being stored e.g. C_Bauxite
* Name the overflow containers as O_XXXX where XXXX is the name of what is being stored e.g. O_Hydrogen
* Optionally name the industry machines after what they are producing
* Optionally add a button and relays to turn eveything on at once

### How it works - Expanded (not working yet)
#### Expanded
<img src="images/industrious.png" height="320" alt="Diagram">

### Installation - Expanded
#### Master
* Add a databank
* Add 4 screens
* Add a programming board
* Connect the core and databank and screens to the programming board
* Paste the display driver config into the programming board
#### Local Monitor
* Add a databank
* Add upto 9 programming boards
* Connect upto 9 industries and the databank to the programming board
* Paste the monitor config into all the programming boards
#### Repeater(s)
* Add a databank
* Add a programming board
* Connect the board to any local databanks and the master databank
* Paste the repeater config into the programming board
