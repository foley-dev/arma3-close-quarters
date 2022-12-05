player addEventHandler [
	"respawn",
	{
		execVM "scripts\player\radioSilence.sqf";
		execVM "scripts\player\loadout.sqf";
		execVM "scripts\player\triggerHostility.sqf";
		execVM "scripts\player\neutralMedic.sqf";
	}
];

player addEventHandler [
	"FiredMan",
	{
		params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

		private _vectorToCenter = (getPosASL _unit) vectorFromTo (getPosASL Foley_hotArea1);
		private _edgeVector1 = (getPosASL _unit) vectorFromTo ((getPosASL Foley_hotArea1) vectorAdd [0, 0, 50]);
		private _edgeVector2 = (getPosASL _unit) vectorFromTo ((getPosASL Foley_hotArea1) vectorAdd [0, 50, 0]);
		private _edgeVector3 = (getPosASL _unit) vectorFromTo ((getPosASL Foley_hotArea1) vectorAdd [50, 0, 0]);

		private _minCos = selectMin ([_edgeVector1, _edgeVector2, _edgeVector3] apply {_x vectorCos _vectorToCenter});
		private _actualCos = (velocity _projectile) vectorCos _vectorToCenter;

		if (_actualCos > _minCos) then {
			Foley_suspectsHostile = true;
			publicVariable "Foley_suspectsHostile";
			player removeEventHandler ["FiredMan", _thisEventHandler];
		};
	}
];
