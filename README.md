# Close Quarters

![Loading screen](https://raw.githubusercontent.com/foley-dev/arma3-close-quarters/assets/screenshots/loading.png)

*“There are no mistakes when clearing a structure in combat, only actions that result in situations — situations that Marines must adapt to, improvise and overcome in a matter of seconds.”*

## About

* Co-op
* Map: **United Sahrani**
* Player count: **25**\
*works well with lower player count*
* Typical duration: **10 min - 20 min**
* [Mod dependencies](https://raw.githubusercontent.com/foley-dev/arma3-frogmen/assets/tour_modset.html) (load into Arma 3 Launcher)


## Briefing

> We have an international incident on our hands, a terrorist group invaded the *AAN broadcast station* - a major US-backed media outlet on Sahrani.\
\
The terrorists already shot multiple members of staff and fired at the first responders. They've also occupied the adjacent *tenement building*. There are more hostages still trapped inside but the terrorists are sending a gruesome message to the world, thus decision was made to go tactical ASAP.\
\
**Bring order to chaos, prevent further civilian casualties.**\
\
The terrorists ceased fire but they are easily provoked!

## Scripting highlights

* Heavily scripted AI behaviour `scripts\server\ai.sqf`
    * Indoor waypoints, skill adjustments, preventing AI from accidentally jumping off the building and more `scripts\server\modules\enemyDeployment.sqf`
    * Dynamically generated equipment `scripts\server\modules\enemyStereotypes.sqf`
    * Hostage situations with voice-overs (SWAT 4-inspired) `scripts\server\modules\hostages.sqf`
    * Enemies are neutral until BLUFOR fires at them or they spot BLUFOR approaching them (search for the `Foley_suspectsHostile` variable)
* Adjustments to vehicles `scripts\server\vehicles.sqf`
    * Automatically shutting off siren when driver leaves the vehicle (GTA V-inspired)
    * Helicopter locked to pilot slots only
* Paramedics are not targeted unless they pick-up a weapon or approach an enemy `scripts\player\neutralMedic.sqf`
* Selectable enemy numbers, equipment and skill `description.ext`

## Screenshots

![Screenshot](https://raw.githubusercontent.com/foley-dev/arma3-close-quarters/assets/screenshots/1.jpg)

![Screenshot](https://raw.githubusercontent.com/foley-dev/arma3-close-quarters/assets/screenshots/2.jpg)

![Screenshot](https://raw.githubusercontent.com/foley-dev/arma3-close-quarters/assets/screenshots/3.jpg)

## Playable slots

### Command
* Commander

### TAC-1
* Team Leader
* Operator (5.56)
* Operator (9mm)
* Operator (5.56)
* Operator (9mm)

### TAC-2
* Team Leader
* Operator (5.56)
* Operator (9mm)
* Operator (5.56)
* Operator (9mm)

### Sierra
* Sniper
* Spotter

### Little Bird
* Pilot
* Co-pilot / Spotter

### EMT-1
* Paramedic
* Paramedic

### EMT-2
* Paramedic
* Paramedic

### First responders
* Police Sergeant
* Police Officer
* Police Officer
* Police Officer
* Police Officer
* Police Officer
