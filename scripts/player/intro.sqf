if (!hasInterface) exitWith {};

private _es = [
	getMarkerPos "objectiveMarker",
	"AAN Broadcast Station",
	50,
	120,
	20,
	1,
	[],
	0,
	true,
	0
] spawn BIS_fnc_establishingShot;

[_es] spawn {
	params ["_es"];
	sleep 2;
	private _source = playSound "dispatch";
	waitUntil { scriptDone _es };
	doStop player;
};

[] execVM "scripts\player\missionTitle.sqf";
