#define ATTACHED_HOSTAGE_PCT 20
#define HOSTAGE_BLUFOR_DISTANCE 10
#define HOSTAGE_INDEP_DISTANCE 15
#define HOSTAGE_SITUATION_TIME_MIN 2
#define HOSTAGE_SITUATION_TIME_MAX 10

Foley_fnc_hostageDaemon = {
	params ["_hostage"];

	// Hostage is held captive

	if (random 100 < ATTACHED_HOSTAGE_PCT) then {
		waitUntil {
			sleep 1;
			{side _x == independent} count allUnits > 1;
		};

		sleep 1;

		private _hostagePos = getPosASL _hostage;
		private _assailant = selectRandom (allUnits select {group _x in [Foley_enemyGroup, Foley_enemyGroup2] && (count attachedObjects _x) == 0});
		[_assailant, _hostage, true] call ACE_captives_fnc_doEscortCaptive;
		_hostage attachTo [_assailant, [-0.6, 0.7, 0]];  // Readjust attachment point
		_assailant setPosASL _hostagePos;
		_assailant forceWalk true;
	};

	waitUntil {
		sleep 0.1;
		!alive _hostage ||
		count ([_hostage] call Foley_fnc_getNearbyOfficers) > 0
	};

	if (!alive _hostage) exitWith {};

	// Hostage approached by SWAT

	sleep random 2;
	doStop _hostage;
	[
		_hostage,
		"hostage" + str (_hostage getVariable "Foley_voiceId")
	] remoteExecCall ["say3D"];

	waitUntil {
		(
			[
				[_hostage] call Foley_fnc_getNearbyOfficers,
				[_hostage] call Foley_fnc_getNearbySuspects
			] call Foley_fnc_filterSuspectsAndOfficers
		) params ["_nearbyOfficers", "_nearbySuspects"];

		sleep 0.1;
		!alive _hostage ||
		(
			count _nearbyOfficers > 0 && count _nearbySuspects > 0 && (count _nearbySuspects) - 1 <= count _nearbyOfficers
		)
	};

	if (!alive _hostage) exitWith {};

	// Suspect threatening execution

	private _nearbySuspects = [_hostage] call Foley_fnc_getNearbySuspects;

	if (count _nearbySuspects > 0) then {
		private _suspect = selectRandom _nearbySuspects;
		doStop _suspect;
		_suspect doTarget _hostage;
		[
			_suspect,
			"suspect" + str (_hostage getVariable "Foley_suspectVoiceId")
		] remoteExecCall ["say3D"];
		_suspect playActionNow "gestureFreeze";
	};

	private _suspectCount = {
		alive _x && 
		side _x == independent &&
		_x distance getMarkerPos "objectiveMarker" < 100 && 
		!(_x getVariable ["ace_captives_isHandcuffed", false])
	} count allUnits;

	private _sleepTime = linearConversion [
		1,
		20,
		_suspectCount,
		HOSTAGE_SITUATION_TIME_MIN,
		HOSTAGE_SITUATION_TIME_MAX - 3,
		true
	];

	if (Foley_skillHard || Foley_skillUnfair) then {
		_sleepTime = 0.5;
	};
	
	sleep _sleepTime;

	[
		_hostage,
		"hostageThreatened" + str (_hostage getVariable "Foley_threatenedVoiceId")
	] remoteExecCall ["say3D"];
	sleep 1 + random 2;

	// Hostage becomes a target

	detach _hostage;
	_hostage setCaptive false;
	{
		_x reveal [_hostage, 4];
		_x doFire _hostage;
	} forEach ([_hostage] call Foley_fnc_getNearbySuspects);
};

Foley_fnc_getNearbySuspects = {
	params ["_hostage"];

	allUnits select {
		alive _x &&
		!(_x getVariable ["ace_captives_isHandcuffed", false]) &&
		side _x == independent && 
		(getPosASL _hostage) distance getPosASL _x < HOSTAGE_INDEP_DISTANCE && 
		[objNull, "VIEW"] checkVisibility [eyePos _x, eyePos _hostage] > 0.5
	};
};

Foley_fnc_getNearbyOfficers = {
	params ["_hostage"];

	allUnits select {
		alive _x &&
		side _x == blufor && 
		(getPosASL _hostage) distance getPosASL _x < HOSTAGE_BLUFOR_DISTANCE && 
		[objNull, "VIEW"] checkVisibility [eyePos _x, eyePos _hostage] > 0.2
	};
};

Foley_fnc_filterSuspectsAndOfficers = {
	params ["_officers", "_suspects"];

	private _seenOfficers = _officers select {
		private _officer = _x;

		{
			[objNull, "VIEW"] checkVisibility [eyePos _x, eyePos _officer] > 0.5
		} count _suspects > 0
	};
	
	private _seenSuspects = _suspects select {
		private _suspect = _x;

		{
			[objNull, "VIEW"] checkVisibility [eyePos _x, eyePos _suspect] > 0.5
		} count _officers > 0
	};

	[_seenOfficers, _seenSuspects]
};

Foley_fnc_setupHostageGroup = {
	params ["_hostageGroup"];

	_hostageGroup setCombatMode "BLUE";
	_hostageGroup setBehaviourStrong "SAFE";
	_hostageGroup allowFleeing 0;  // Civis navigate the building very poorly
	_hostageGroup setVariable ["VCM_Skilldisable", true];
	_hostageGroup setVariable ["Vcm_Disable", true];
	_hostageGroup setGroupIdGlobal ["Hostages"];
	
	private _voiceIds = [1,2,3,4,5,6,7,8,9,10,11,12,13,14] call BIS_fnc_arrayShuffle;
	private _threatenedVoiceIds = [1,2,3,4,5,6] call BIS_fnc_arrayShuffle;
	private _suspectVoiceIds = [1,2,3,4,5,6] call BIS_fnc_arrayShuffle;

	private _locations = (entities "Logic") select {_x getVariable ["Foley_hostageSpawnPoint", false]};
	_locations = _locations call BIS_fnc_arrayShuffle;

	assert (count _locations > count units _hostageGroup);

	{
		_x disableAI "MOVE";
		_x disableAI "PATH";
		_x disableAI "CHECKVISIBLE";
		_x disableAI "FSM";
		_x disableAI "AUTOCOMBAT";
		_x disableAI "RADIOPROTOCOL";
		_x setVariable ["lambs_danger_disableAI", true];
		_x setVariable ["Foley_voiceId", _voiceIds select (_forEachIndex % count _voiceIds)];
		_x setVariable ["Foley_threatenedVoiceId", _threatenedVoiceIds select (_forEachIndex % count _threatenedVoiceIds)];
		_x setVariable ["Foley_suspectVoiceId", _suspectVoiceIds select (_forEachIndex % count _suspectVoiceIds)];
		
		_x setPosASL getPosASL (_locations select _forEachIndex);
		_x setDir random 360;

		doStop _x;
		removeAllWeapons _x;
		_x setCaptive true;
		[_x] spawn Foley_fnc_hostageDaemon;

		[
			true,
			["saveHostages" + str _forEachIndex, "saveHostages"],
			[
				"Save " + name _x,
				"Save " + name _x
			],
			objNull,
			"CREATED",
			-1,
			false,
			"meet"
		] call BIS_fnc_taskCreate;

		_x setVariable ["Foley_hostageTaskId", "saveHostages" + str _forEachIndex];
		_x addEventHandler [
			"Killed",
			{
				params ["_unit", "_killer", "_instigator", "_useEffects"];

				private _reason = "Cause of death unknown";

				if (!isNull _instigator && _instigator != _unit) then {
					_reason = "He was shot by " + groupId group _instigator;
				} else {
					if (!isNull _killer && _killer != _unit) then {
						_reason = "He was killed by " + groupId group _killer;
					};
				};

				[_unit getVariable "Foley_hostageTaskId", "FAILED", true] spawn BIS_fnc_taskSetState;
				[
					_unit getVariable "Foley_hostageTaskId",
					[
						(name _unit) + " didn't survive. " + _reason,
						"Save " + name _unit,
						""
					]
				] spawn BIS_fnc_taskSetDescription;
			}
		];
	} forEach units _hostageGroup;
};
