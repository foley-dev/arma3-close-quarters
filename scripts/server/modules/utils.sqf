Foley_fnc_nearestBuildingPosition = {
	params ["_unit", "_buildingPositions"];

	private _sorted = [
		_buildingPositions,
		[getPosATL _unit],
		{
			[_input0, _x] call Foley_fnc_indoorsDistance
		},
		"ASCEND"
	] call BIS_fnc_sortBy;

	_sorted select 0
};

Foley_fnc_sampleNearbyPosition = {
	params ["_from", "_positions"];

	private _weights = _positions apply {
		1 / ([_from, _x] call Foley_fnc_indoorsDistance)
	};

	_positions selectRandomWeighted _weights
};

Foley_fnc_indoorsDistance = {
	params ["_from", "_to"];

	(_from distance2D _to) + 10 * abs ((_from select 2) - (_to select 2))
};	
