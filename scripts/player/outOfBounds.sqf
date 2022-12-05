#define INITIAL_WAIT 1
#define RECOVERY_WAIT 5

if (!hasInterface) exitWith {};

// You can glitch through the wall into unreachable part of the building
private _zones = [Foley_oob1, Foley_oob2, Foley_oob3, Foley_oob4, Foley_oob5, Foley_oob6, Foley_oob7, Foley_oob8, Foley_oob9];
private _lastLegalPosition = getPosATL player;

while {true} do {
	if (player inArea Foley_ladderOob && alive player) then {
		player setPosASL getPosASL Foley_ladderOobRecovery;
		player setDir getDir Foley_ladderOobRecovery;
	};

	{
		private _zone = _x;

		if (player inArea _zone) then {
			sleep INITIAL_WAIT;

			if (player inArea _zone && alive player) then {
				hint "You appear to have clipped through the wall, stand by for teleport...";
				sleep RECOVERY_WAIT;
				
				if (player inArea _zone && alive player) then {
					private _building = nearestBuilding (getMarkerPos "objectiveMarker");
					private _positions = [_building] call BIS_fnc_buildingPositions;
					private _sorted = [
						_positions,
						[_lastLegalPosition],
						{
							_input0 distance _x
						},
						"ASCEND"
					] call BIS_fnc_sortBy;
					player setPosATL (_sorted select 0);
					hintSilent "";
				} else {
					// If you recover by yourself
					hintSilent "Teleport cancelled";
				};
			};
		};
	} forEach _zones;

	_lastLegalPosition = getPosATL player;

	sleep 1;
};
