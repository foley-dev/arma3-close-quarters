{
	doStop _x;
	_x disableAI "PATH";
	
	if (side _x == blufor) then {
		[_x] execVM "scripts\player\loadout.sqf";
	};
} forEach (playableUnits + switchableUnits);
