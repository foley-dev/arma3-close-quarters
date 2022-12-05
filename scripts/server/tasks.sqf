#define TIME_TO_LET_THINGS_SETTLE 15
#define ACCEPTABLE_CASUALTIES_PCT 0.2

if (!isServer) exitWith {};

[
	true,
	"bringOrderToChaos",
	[
		"Neutralize terrorists barricaded in the <marker name='objectiveMarker'>broadcast station</marker> and the adjacent <marker name='objectiveMarker2'>tenement</marker>.",
		"Bring order to chaos"
	],
	objNull,
	"ASSIGNED",
	10,
	false,
	"attack"
] call BIS_fnc_taskCreate;

[
	true,
	"saveHostages",
	[
		"Prevent further civilian casualties. You are required to protect each hostage you encounter. The terrorists are likely to shoot a hostage that was approached by SWAT.",
		"Save hostages"
	],
	objNull,
	"CREATED",
	-1,
	false,
	"meet"
] call BIS_fnc_taskCreate;

[
	true,
	"avoidHeavyCasualties",
	[
		"Chief is expecting a high survivability rate of the operators. Be deliberate.",
		"Avoid heavy casualties"
	],
	objNull,
	"CREATED",
	-1,
	false,
	"defend"
] call BIS_fnc_taskCreate;

// Resolve "Bring order to chaos"
0 = [] spawn {
	waitUntil { time > 0 };
	sleep TIME_TO_LET_THINGS_SETTLE;
	
	waitUntil {
		sleep 1;
		private _effectiveEnemyCount = {
			alive _x && 
			side _x == independent &&
			_x distance getMarkerPos "objectiveMarker" < 100 && 
			!(_x getVariable ["ace_captives_isHandcuffed", false])
		} count allUnits;

		_effectiveEnemyCount == 0
	};

	sleep 10 + random 10;  // A moment of uncertainty ;)
	0 = ["bringOrderToChaos", "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
};

// Resolve "Avoid heavy casualties"
0 = [] spawn {
	waitUntil {
		{alive _x} count allPlayers > 0
	};
	waitUntil { time > 0 };
	sleep TIME_TO_LET_THINGS_SETTLE;

	private _peakPlayerCount = {alive _x} count allPlayers;

	waitUntil {
		sleep 1;
	
		private _currentPlayerCount = {alive _x} count allPlayers;

		if (_currentPlayerCount > _peakPlayerCount) then {
			_peakPlayerCount = _currentPlayerCount;
		};

		private _percentDead = ((_peakPlayerCount max 1) - _currentPlayerCount) / (_peakPlayerCount max 1);

		_percentDead > ACCEPTABLE_CASUALTIES_PCT
	};

	0 = ["avoidHeavyCasualties", "FAILED", true] spawn BIS_fnc_taskSetState;
};
