Foley_param_timeOfDay = ["Foley_param_timeOfDay"] call BIS_fnc_getParamValue;
Foley_param_enemyCount = ["Foley_param_enemyCount"] call BIS_fnc_getParamValue;
Foley_param_enemyEquipment = ["Foley_param_enemyEquipment"] call BIS_fnc_getParamValue;
if (Foley_param_enemyEquipment == -1) then {
	Foley_param_enemyEquipment = random [10, 35, 100];
};
Foley_param_enemySkill = ["Foley_param_enemySkill"] call BIS_fnc_getParamValue;
Foley_param_buildingType = ["Foley_param_buildingType"] call BIS_fnc_getParamValue;
if (Foley_param_buildingType == -1) then {
	Foley_param_buildingType = floor random 10;
};

TOUR_respawnTime = ["TOUR_param_respawn", 30] call BIS_fnc_getParamValue;
TOUR_respawnTickets = [
	["TOUR_param_tickets", 1] call BIS_fnc_getParamValue,
	["TOUR_param_tickets", 1] call BIS_fnc_getParamValue,
	["TOUR_param_tickets", 1] call BIS_fnc_getParamValue,
	["TOUR_param_tickets", 1] call BIS_fnc_getParamValue
];
