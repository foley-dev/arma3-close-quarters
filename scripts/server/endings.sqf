#define TIME_TO_LET_THINGS_SETTLE 15

if (!isServer) exitWith {};

private _fnc_countAliveCombatantPlayers = {
	{
		alive _x && 
		!(_x getVariable ["ACE_isUnconscious", false]) &&
		!(_x getVariable ["Foley_isCivilian", false])
	} count allPlayers
};

diag_log "endings.sqf started";
waitUntil { 
	call _fnc_countAliveCombatantPlayers > 0
};
diag_log "player count > 0";
waitUntil { time > 0 };
diag_log "time > 0";
sleep TIME_TO_LET_THINGS_SETTLE;
diag_log "slept";

while {true} do {
	if (call _fnc_countAliveCombatantPlayers == 0) exitWith {
		diag_log "player count == 0";
		0 = ["saveHostages", "FAILED", false] spawn BIS_fnc_taskSetState;
		0 = ["avoidHeavyCasualties", "FAILED", false] spawn BIS_fnc_taskSetState;
		0 = ["bringOrderToChaos", "FAILED", false] spawn BIS_fnc_taskSetState;
		sleep 3;
		"loser" call BIS_fnc_endMissionServer;
	};

	if ((["bringOrderToChaos"] call BIS_fnc_taskState) == "SUCCEEDED") exitWith {
		private _hostageTasksFailed = ("saveHostages" call BIS_fnc_taskChildren) select {
			[_x] call BIS_fnc_taskState == "FAILED"
		};

		if (count _hostageTasksFailed > 0) then {
			["saveHostages", "FAILED", false] call BIS_fnc_taskSetState;
		} else {
			["saveHostages", "SUCCEEDED", false] call BIS_fnc_taskSetState;
		};

		{
			[_x, "SUCCEEDED", false] call BIS_fnc_taskSetState;
		} forEach (("saveHostages" call BIS_fnc_taskChildren) - _hostageTasksFailed);

		if ((["avoidHeavyCasualties"] call BIS_fnc_taskState) != "FAILED") then {
			0 = ["avoidHeavyCasualties", "SUCCEEDED", false] spawn BIS_fnc_taskSetState;
		};
		
		sleep 5;
		
		if (
			(["saveHostages"] call BIS_fnc_taskState) == "SUCCEEDED" && 
			(["avoidHeavyCasualties"] call BIS_fnc_taskState) == "SUCCEEDED"
		) then {
			"DecisiveVictoryEnding" call BIS_fnc_endMissionServer;
		} else {
			"MinorVictoryEnding" call BIS_fnc_endMissionServer;
		};
	};

	sleep 1;
};

diag_log "endings.sqf finished";
