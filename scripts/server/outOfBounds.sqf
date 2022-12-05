#define TIME_TO_LET_THINGS_SETTLE 15
#define KILL_OOB_AFTER 1

if (!isServer) exitWith {};

// AI can glitch through the wall into unreachable part of the building
private _zones = [Foley_oob1, Foley_oob2, Foley_oob3, Foley_oob4, Foley_oob5, Foley_oob6, Foley_oob7, Foley_oob8, Foley_oob9];

waitUntil { time > 0 };
sleep TIME_TO_LET_THINGS_SETTLE;

while {true} do {
	{
		private _zone = _x;
		private _aiUnitsInside = (allUnits select {!isPlayer _x && isNull attachedTo _x}) inAreaArray _zone;
		{
			sleep KILL_OOB_AFTER;
			
			if (_x inArea _zone) then {
				_x setDamage 1;
			};
		} forEach _aiUnitsInside;
	} forEach _zones;

	sleep 1;
};
