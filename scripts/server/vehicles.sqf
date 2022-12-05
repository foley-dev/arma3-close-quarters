addMissionEventHandler [
	"EachFrame",
	{
		private _vehicles = vehicles select {
			side _x == blufor && 
			side driver _x != blufor && 
			side currentPilot _x != blufor
		};

		{
			Foley_enemyGroup forgetTarget _x;
			Foley_enemyGroup2 forgetTarget _x;
		} forEach _vehicles;
	}
];

private _vehicleTypes = [
	"C_Van_02_medevac_F",
	"B_GEN_Van_02_vehicle_F",
	"B_GEN_Offroad_01_comms_F",
	"B_GEN_Offroad_01_gen_F",
	"B_GEN_Offroad_01_covered_F",
	"UK3CB_ADP_B_YAVA",
	"UK3CB_ADP_B_Datsun_Pickup"
];

{
	_x addEventHandler [
		"Engine",
		{
			params ["_vehicle", "_engineState"];

			{
    			_vehicle animateDoor [_x, 0];
			} forEach [
				"Door_1_source",
				"Door_2_source",
				"Door_3_source",
				"Door_4_source",
				"OpenDoor3"
			];

			_vehicle removeEventHandler ["Engine", _thisEventHandler];
		}
	];

	_x addEventHandler [
		"GetOut",
		{
			params ["_vehicle", "_role", "_unit", "_turret"];

			if (isNull driver _vehicle || !alive driver _vehicle) then {
				[[_vehicle, 'CustomSoundController1', 0]] remoteExec ["setCustomSoundController"];
				_vehicle setVariable ['UK3CB_Siren_Active', false, true];
			};
		}
	];

	_x addEventHandler [
		"Dammaged",
		{
			params ["_unit", "_selection", "_damage", "_hitIndex", "_hitPoint", "_shooter", "_projectile"];

			if (damage _unit == 1) then {
				[[_vehicle, 'CustomSoundController1', 0]] remoteExec ["setCustomSoundController"];
				_vehicle setVariable ['UK3CB_Siren_Active', false, true];
			};
		}
	];
	
	[_x] spawn {
		params ["_vehicle"];
		while {alive _vehicle} do {
			if (
				getCustomSoundController [_vehicle, 'CustomSoundController1'] > 0.5 ||
				_vehicle getVariable ['UK3CB_Siren_Active', false]
			) then {
				_vehicle animateSource ['lights_em_hide', 1];
				_vehicle animateSource ['Beacons', 1];
			};

			sleep 1;
		};
	};
} forEach (vehicles select {(typeOf _x) in _vehicleTypes});

[Foley_helicopter] spawn {
	params ["_helicopter"];

	private _allowedUnitClasses = ["B_Helipilot_F", "B_helicrew_F"];

	while {alive _helicopter} do {
		sleep 0.5;

		private _pilot = currentPilot _helicopter;

		if (isNull _pilot) then {
			continue;
		};

		if (vectorMagnitude velocity _helicopter > 1) then {
			continue;
		};

		if ((typeOf _pilot) in _allowedUnitClasses) then {
			continue;
		};
		
		moveOut _pilot;
		_helicopter engineOn false;
	};
};
