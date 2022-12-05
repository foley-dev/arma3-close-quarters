Foley_fnc_generateBuildingPositions = {
	params ["_buildingPosition"];

	private _building = nearestBuilding _buildingPosition;
	assert (!isNull _building);

	private _positions = [_building] call BIS_fnc_buildingPositions;
	assert (count _positions > 0);
	
	_positions = _positions call BIS_fnc_arrayShuffle;

	_positions
};

#define GRENADE_CHANCE 10
#define SECOND_BANDAGE_CHANCE 50
#define CIG_CHANCE 25
#define CIG_MAX_DELAY 900

Foley_fnc_applyEnemyLoadout = {
	_this params ["_unit", "_loadout"];
	_loadout params ["_uniform", "_vest", "_headgear", "_facewear", "_weapon", "_ammo"];
	
	removeBackpack _unit;

	removeUniform _unit;
	_unit forceAddUniform _uniform;

	removeVest _unit;
	_unit addVest _vest;

	removeHeadgear _unit;
	_unit addHeadgear _headgear;

	removeGoggles _unit;
	_unit addGoggles _facewear;

	removeAllWeapons _unit;
	_unit addMagazines [_ammo, 3];
	_unit addWeapon _weapon;
	
	_unit addItem "ACE_fieldDressing";
	if (random 100 < SECOND_BANDAGE_CHANCE) then {
		_unit addItem "ACE_fieldDressing";
	};
	
	if (random 100 < CIG_CHANCE) then {
		[_unit] spawn {
			params ["_unit"];

			sleep random CIG_MAX_DELAY;

			if (alive _unit) then {
				_unit linkItem "murshun_cigs_cig0_nv";
				[_unit] spawn murshun_cigs_fnc_start_cig;
			};
		};
	};

	if (random 100 < GRENADE_CHANCE || Foley_skillUnfair && random 100 < GRENADE_CHANCE * 3) then {
		_unit addItem "rhs_mag_rgn";
	};
};

Foley_fnc_createGroup = {
	params ["_position", "_loadouts", "_groupName"];
	
	private _suspects = createGroup independent;
	_suspects setVariable ["lambs_danger_disableGroupAI", Foley_lambsDisabled];
	_suspects setBehaviour "AWARE";
	_suspects setCombatMode "YELLOW";
	_suspects setGroupIdGlobal [_groupName];

	{
		private _unit = _suspects createUnit ["I_G_Soldier_F", _position, [], 20, "NONE"]; 
		_unit setVariable ["lambs_danger_disableAI", true];  // Always disabled on start
		_unit setVariable ["lambs_danger_disableGroupAI", Foley_lambsDisabled];
		[_unit, _x] call Foley_fnc_applyEnemyLoadout;
	} forEach _loadouts;

	_suspects
};

Foley_fnc_deployGroup = {
	params ["_group", "_buildingPositions", "_unsafeBuildingPositions", "_patrolWaypoints"];
	assert (count _buildingPositions >= count units _group);
	{
		doStop _x;
		_x setPos (_buildingPositions select _forEachIndex);
		[_x, _buildingPositions, _unsafeBuildingPositions] spawn Foley_daemon_manageCqbBehaviour;
		[_x, _buildingPositions, _unsafeBuildingPositions] spawn Foley_daemon_movementFixes;
	} forEach units _group;

	[_group] spawn Foley_daemon_adjustSkill;
	[_group] spawn Foley_daemon_monitorHostility;
	[_group] spawn Foley_daemon_triggerHostility;
};

Foley_fnc_createPatrol = {
	params ["_position", "_loadouts", "_groupName"];
	
	private _suspects = createGroup independent;
	_suspects setVariable ["lambs_danger_disableGroupAI", Foley_lambsDisabled];
	_suspects setBehaviour "SAFE";
	_suspects setCombatMode "YELLOW";
	_suspects setGroupIdGlobal [_groupName];

	{
		private _unit = _suspects createUnit ["I_G_Soldier_F", _position, [], 20, "NONE"]; 
		_unit setVariable ["lambs_danger_disableAI", Foley_lambsDisabled];
		_unit setVariable ["lambs_danger_disableGroupAI", Foley_lambsDisabled];
		[_unit, _x] call Foley_fnc_applyEnemyLoadout;
	} forEach _loadouts;

	_suspects
};

Foley_fnc_deployPatrol = {
	params ["_group"];

	private _wp = Foley_patrolSpawn;

	{
		_x setPosASL ((getPosASL _wp) getPos [1 + random 2, random 360]);
	} forEach units _group;

	[_group, _wp] spawn Foley_daemon_managePatrolBehaviour;
	
	[_group] spawn Foley_daemon_adjustSkill;
};

Foley_daemon_monitorHostility = {
	params ["_group"];

	private _patience = 60 * random [10, 15, 30];

	while {!Foley_suspectsHostile} do {
		private _encroaching = (allPlayers inAreaArray Foley_hotArea1) + (allPlayers inAreaArray Foley_hotArea2);
		private _encroachingAndDetected = {
			((leader _group) targetKnowledge (vehicle _x)) params [
				"_knownByGroup",
				"_knownByUnit",
				"_lastSeen",
				"_lastEndangered",
				"_targetSide",
				"_positionError",
				"_perceivedPosition"
			];
			
			_knownByGroup && 
			(
				(ASLToAGL _perceivedPosition) inArea Foley_hotArea1 || 
				(ASLToAGL _perceivedPosition) inArea Foley_hotArea2
			)
		} count _encroaching;

		private _encroachingAndDetectedByPatrol = {
			((leader Foley_enemyPatrolGroup) targetKnowledge (vehicle _x)) params [
				"_knownByGroup",
				"_knownByUnit",
				"_lastSeen",
				"_lastEndangered",
				"_targetSide",
				"_positionError",
				"_perceivedPosition"
			];
			
			_knownByGroup && 
			(
				(ASLToAGL _perceivedPosition) inArea Foley_hotArea1 || 
				(ASLToAGL _perceivedPosition) inArea Foley_hotArea2
			)
		} count _encroaching;
		
		if (_encroachingAndDetected + _encroachingAndDetectedByPatrol > 0 || time > _patience) then {
			Foley_suspectsHostile = true;
			publicVariable "Foley_suspectsHostile";
		};

		sleep 0.25;
	};
};

Foley_daemon_triggerHostility = {
	params ["_group"];

	waitUntil {
		Foley_suspectsHostile 
	};
	
	independent setFriend [blufor, 0];
};

#define TICK_INTERVAL 0.25
#define MOVEMENT_INTERVAL [60, 300, 1800]
#define MOVEMENT_COOLDOWN 10
#define ADJUSTMENT_INTERVAL [1, 15, 60]
#define ADJUSTMENT_DURATION [0.5, 1.5, 5]
#define STANCE_INTERVAL [1, 10, 20]

Foley_daemon_manageCqbBehaviour = {
	params ["_unit", "_buildingPositions", "_unsafeBuildingPositions"];

	if (random 100 < 80) then {
		_unit disableAI "TARGET";  // Don't chase players or vehicles outside the building
	};

	private _watchPoints = (entities "Logic") select {_x getVariable ["Foley_watchPoint", false]};

	private _nextMovement = time + random MOVEMENT_INTERVAL;
	private _nextAdjustment = time + random ADJUSTMENT_INTERVAL;
	private _nextStance = time + random STANCE_INTERVAL;
	private _isNearbyAnotherUnit = false;
	private _previousDamage = damage _unit;

	sleep random 2;

	while {alive _unit} do {
		waitUntil {
			sleep TICK_INTERVAL;
			_isNearbyAnotherUnit = ({_x distance _unit < 0.8} count allUnits) > 1;

			time > _nextMovement || time > _nextStance || time > _nextAdjustment || _isNearbyAnotherUnit || damage _unit > _previousDamage
		};

		private _randomGesture = selectRandomWeighted [
			"gestureAdvance",
			1,
			"gestureCover",
			1,
			"gestureFreeze",
			1,
			"gestureGo",
			5,
			"gestureGoB",
			5,
			"gestureCeaseFire",
			5,
			"gestureHi",
			5,
			"gestureHiB",
			5,
			"gestureHiC",
			5,
			"gestureUp",
			10,
			"gestureNo",
			10,
			"gestureNod",
			10,
			"gestureYes",
			10,
			"gestureFollow",
			10,
			"",
			[100, 250] select Foley_suspectsHostile
		];
		
		if (time >= _nextAdjustment || _isNearbyAnotherUnit || damage _unit > _previousDamage) then {
			_unit doMove selectRandom _buildingPositions;
			sleep random ADJUSTMENT_DURATION;
			_unit playAction _randomGesture;
			doStop _unit;
			_nextAdjustment = time + random ADJUSTMENT_INTERVAL;

			if ((getPosATL _unit) select 2 < 0.1) then {
				_nextMovement = time;
			};
		};
		
		if (time >= _nextMovement) then {
			// Favor near destinations but no closer than 5m
			private _destinations = _buildingPositions select {_x distance _unit > 5};

			if (count attachedObjects _unit > 0) then {
				_destinations = _destinations select {!(_x in _unsafeBuildingPositions)};
			};

			private _destination = [getPosATL _unit, _destinations] call Foley_fnc_sampleNearbyPosition;

			_unit doMove _destination;
			_nextMovement = time + MOVEMENT_COOLDOWN + random MOVEMENT_INTERVAL;
			_nextAdjustment = time + MOVEMENT_COOLDOWN + random ADJUSTMENT_INTERVAL;
		};
		
		if (time >= _nextStance) then {
			_unit setUnitPos (selectRandom ["UP", "MIDDLE"]);

			if (count attachedObjects _unit > 0) then {
				_unit setUnitPos "UP"; 
			};

			_nextStance = time + random STANCE_INTERVAL;
			private _watchPointsWeights = _watchPoints apply {1 / (_unit distance _x)};
			_unit lookAt getPos (_watchPoints selectRandomWeighted _watchPointsWeights);
			sleep 1;
			_unit playAction _randomGesture;
		};

		_previousDamage = damage _unit;
	};
};

Foley_daemon_movementFixes = {
	params ["_unit", "_buildingPositions", "_unsafeBuildingPositions"];

	while {alive _unit} do {
		private _nearest = [_unit, _buildingPositions] call Foley_fnc_nearestBuildingPosition;

		if (_nearest in _unsafeBuildingPositions || count attachedObjects _unit > 0) then {
			_unit forceWalk true;
		} else {
			_unit forceWalk false;
		};

		if (stance _unit != "UNDEFINED") then {
			private _isStuckFalling = abs ((velocity _unit) select 2) > 4;
			private _isOutOfBounds = ({_unit inArea _x} count [
				Foley_oob1, Foley_oob2, Foley_oob3, Foley_oob4, Foley_oob5, Foley_oob6, Foley_oob7, Foley_oob8, Foley_oob9
			]) > 0;

			if (_isStuckFalling || _isOutOfBounds) then {
				_unit setDir ((getPosATL _unit) getDir _nearest);
				_unit setPosATL _nearest;
			} else {
				if (speed _unit < 0.1) then {
					private _fromPos = AGLToASL (_unit modelToWorld [0, 0, 1]);
					private _vectors = [
						[0, 0.7, 0.5],
						[0, -0.3, 0.5],
						[0.4, 0, 0.5],
						[-0.3, 0, 0.5]
					];

					if (count attachedObjects _unit > 0) then {
						_vectors = [
							[0, 1.2, 0.5],
							[0, -0.3, 0.5],
							[0.4, 0, 0.5],
							[-0.9, 0, 0.5],
							[-0.9, 1.2, 1.5]
						];
					};

					{					
						private _objs = lineIntersectsObjs [
							_fromPos,
							AGLToASL (_unit modelToWorld _x),
							_unit,
							objNull,
							false,
							16 + 4
						];

						if (count _objs > 0) then {
							private _shiftVector = (_x vectorMultiply -0.2);
							_shiftVector set [2, 0];

							private _objs = lineIntersectsObjs [
								_fromPos,
								AGLToASL (_unit modelToWorld _shiftVector),
								_unit,
								objNull,
								false,
								16 + 4
							];

							if (count _objs == 0) then {
								_unit setPosASL AGLToASL (_unit modelToWorld _shiftVector);
							};
						};
					} forEach _vectors;
				};
			};
		};
	
		sleep TICK_INTERVAL;
	};
};

Foley_daemon_managePatrolBehaviour = {
	params ["_group", "_patrolWaypoint"];

	_group setBehaviour "SAFE";
	_group setSpeedMode "LIMITED";

	private _watchPoints = (entities "Logic") select {_x getVariable ["Foley_watchPoint", false]};
	private _previous = [_patrolWaypoint];

	while {count units _group > 0 && behaviour leader _group == "SAFE"} do {
		private _choices = (synchronizedObjects _patrolWaypoint) - _previous;

		if (count _choices == 0) then {
			_previous = [];
			continue;
		};

		_patrolWaypoint = selectRandom _choices;
		_previous pushBack _patrolWaypoint;
		_group move getPosATL _patrolWaypoint;
		(leader _group) doMove getPosATL _patrolWaypoint;

		private _watchables = allUnits select {
			side _x == blufor && _x distance (leader _group) < 100 && _group knowsAbout _x >= 1.5
		};

		if (count _watchables > 0 && Foley_suspectsHostile) then {
			_group setBehaviour "COMBAT";

			{
				_x doTarget selectRandom _watchables;
			} forEach units _group;

			break;
		};

		_watchables = _watchables + _watchPoints;
		private _watchablesWeights = _watchables apply {1 / ((leader _group) distance _x)};

		{
			_x lookAt getPos (_watchables selectRandomWeighted _watchablesWeights);
			_x doMove getPosATL leader _group;
			_x doFollow leader _group;
		} forEach units _group;

		sleep 5;

		waitUntil {
			sleep 0.5;
			speed leader _group < 1
		};

		{
			_x lookAt getPos (_watchables selectRandomWeighted _watchablesWeights);
		} forEach units _group;
		sleep random [0, 2, 20];
	};
};

#define SPOT_TIME_SKILL 1.0
#define AIMING_SPEED_SKILL 1.0 
#define INITIAL_GENERAL_SKILL 0.4
#define ULTIMATE_GENERAL_SKILL 1.0

Foley_daemon_adjustSkill = {
	params ["_group"];
	
	_group setVariable ["VCM_Skilldisable", true];
	_group setVariable ["Vcm_Disable", true];

	private _initialCount = count units _group;

	if (Foley_skillUnfair) then {
		[_group] spawn {
			params ["_group"];

			while {({alive _x} count units _group) > 0} do {
				{
					private _unit = _x;

					private _nearbyPlayers = allPlayers select {_x distance _unit < 50};
					private _visiblePlayers = _nearbyPlayers select {
    					[_unit, "VIEW", _x] checkVisibility [eyePos _unit, aimPos _x] > 0.01
					};
					private _dangerClosePlayers = _nearbyPlayers select {_x distance _unit < 3};

					{
						_unit reveal [_x, 4];
					} forEach (_visiblePlayers + _dangerClosePlayers);

					if (count _visiblePlayers > 0) then {
						_unit doTarget selectRandom _visiblePlayers;
					} else {
						if (count _dangerClosePlayers > 0) then {
							_unit doTarget selectRandom _dangerClosePlayers;
						};
					};
				} forEach units _group;

				sleep 0.1;
			};
		};
	};

	if (!Foley_lambsDisabled) then {
		[_group] spawn {
			params ["_group"];

			{
				private _unit = _x;
			
				_unit setVariable ["lambs_danger_disableAI", _forEachIndex % 10 != 0];
			} forEach units _group;

			while {({alive _x} count units _group) > 0} do {
				{
					private _unit = _x;
					
					private _nearbyPlayers = {
						_x distance _unit < 3 ||
						_x distance _unit < 20 && [_unit, "VIEW", _x] checkVisibility [eyePos _unit, aimPos _x] > 0.01
					} count allPlayers;

					if (_nearbyPlayers > 0) then {
						_unit setVariable ["lambs_danger_disableAI", false];
					};
				} forEach (
					(units _group) select {
						alive _x && _x getVariable ["lambs_danger_disableAI", false]
					}
				);

				sleep 1;
			};
		};
	};

	while {({alive _x} count units _group) > 0} do {
		if (Foley_skillUnfair) then {
			{
				private _unit = _x;

				{
					_unit setSkill [_x, 1];
				} forEach [
					"aimingAccuracy",
					"aimingShake",
					"aimingSpeed",
					"endurance",
					"spotDistance",
					"spotTime",
					"courage",
					"reloadSpeed",
					"commanding",
					"general"
				];
				
				_x disableAI "AIMINGERROR";
				_x enableFatigue false;
			} forEach units _group;
		} else {
			// Starts off easy, gets harder as bodies drop
			private _toMin = 1.0 - ULTIMATE_GENERAL_SKILL;
			private _toMax = 1.0 - INITIAL_GENERAL_SKILL;
			private _skill = 1.0 - (linearConversion [0, _initialCount, ({alive _x;} count units _group), _toMin, _toMax]);

			if (Foley_skillHard) then {
				_skill = 1;
			};
			
			{
				private _unit = _x;

				_unit setSkill ["general", _skill];
				_unit setSkill ["spotTime", SPOT_TIME_SKILL];
				_unit setSkill ["aimingSpeed", AIMING_SPEED_SKILL];

				if (_skill > 0.6) then {
					_unit disableAI "AIMINGERROR";
				};
			} forEach units _group;
		};

		sleep 15;
	};
};
