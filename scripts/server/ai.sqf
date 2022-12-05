#define MINIMUM_ENEMY_COUNT 3
#define BUILDING_MAX_FILL_PCT 0.8

private _secondBuildingExactPos = getPos Foley_placeholderBuilding;
private _secondBuildingExactDir = getDir Foley_placeholderBuilding;
private _secondBuildingOptions = [
	"jbad_opx2_complex1",
	"jbad_opx2_complex3",
	"jbad_opx2_complex9",
	"jbad_opx2_corner1",
	"jbad_opx2_h1",
	"jbad_opx2_big_f",
	"jbad_opx2_apartmentcomplex4",
	"jbad_opx2_big_c",
	"jbad_opx2_big_d",
	"jbad_opx2_block1"
];

deleteVehicle nearestBuilding _secondBuildingExactPos;
private _secondBuilding = createVehicle [_secondBuildingOptions select Foley_param_buildingType, _secondBuildingExactPos, [], 0, "CAN_COLLIDE"];

_secondBuilding setPos _secondBuildingExactPos;
_secondBuilding setDir _secondBuildingExactDir;

private _staircasePositions = [25, 26, 27, 28, 37, 48, 59, 60, 70, 71];
private _balconyPositions = [74, 75, 76, 78, 79, 80, 81, 84];
private _roofEdgePositions = [41, 42, 43, 44, 62, 63, 64, 65];
private _unsafeBuildingPositions = (_staircasePositions + _balconyPositions + _roofEdgePositions) apply {
	(nearestBuilding getMarkerPos "objectiveMarker") buildingPos _x
};

private _deployments = [
	[
		"Foley_enemyGroup",
		getMarkerPos "objectiveMarker",
		_unsafeBuildingPositions,
		"Terrorists (Main Building)"
	],
	[
		"Foley_enemyGroup2",
		getMarkerPos "objectiveMarker2",
		[],
		"Terrorists (Tenement Building)"
	]
];

Foley_suspectsHostile = false;
publicVariable "Foley_suspectsHostile";
Foley_skillHard = Foley_param_enemySkill in [3, 4, 5, 6];
Foley_skillUnfair = Foley_param_enemySkill in [5, 6];
Foley_lambsDisabled = !(Foley_param_enemySkill in [2, 4, 6]);

{
	_x params ["_groupVarName", "_buildingPosition", "_unsafeBuildingPositions", "_groupName"];
	
	private _buildingPositions = [_buildingPosition] call Foley_fnc_generateBuildingPositions;

	private _lc = [
		0,
		100,
		Foley_param_enemyCount,
		MINIMUM_ENEMY_COUNT,
		(count _buildingPositions) * BUILDING_MAX_FILL_PCT,
		true
	];
	private _enemyCount = linearConversion _lc;

	private _loadouts = [_enemyCount, Foley_param_enemyEquipment] call Foley_fnc_generateLoadouts;
	private _group = [_buildingPosition, _loadouts, _groupName] call Foley_fnc_createGroup;
	[_group, _buildingPositions, _unsafeBuildingPositions] call Foley_fnc_deployGroup;

	missionNamespace setVariable [_groupVarName, _group];
} forEach _deployments;

private _patrolWaypoints = (entities "Logic") select {_x getVariable ["Foley_patrolWaypoint", false]};
private _patrolCount = selectRandomWeighted [
	0, 60,
	1, 5,
	2, 30,
	3, 5
];
_patrolCount = _patrolCount min round (((count units Foley_enemyGroup) + (count units Foley_enemyGroup2)) / 10);
private _patrolLoadouts = [_patrolCount, Foley_param_enemyEquipment] call Foley_fnc_generateLoadouts;
Foley_enemyPatrolGroup = [getMarkerPos "objectiveMarker", _patrolLoadouts, "Terrorists (Patrol)"] call Foley_fnc_createPatrol;
[Foley_enemyPatrolGroup] call Foley_fnc_deployPatrol;

private _hostageLocations = (entities "Logic") select {_x getVariable ["Foley_hostageSpawnPoint", false]};
_hostageLocations = _hostageLocations call BIS_fnc_arrayShuffle;
private _secondBuildingPositions = [getMarkerPos "objectiveMarker2"] call Foley_fnc_generateBuildingPositions;
_secondBuildingPositions = _secondBuildingPositions call BIS_fnc_arrayShuffle;

{
	_x setPos (_secondBuildingPositions select _forEachIndex);
} forEach (
	_hostageLocations select [
		0,
		((count _hostageLocations) / 2) min (count _secondBuildingPositions)
	]
);

[Foley_hostages] call Foley_fnc_setupHostageGroup;
