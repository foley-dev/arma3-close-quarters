if (typeOf player != "C_Man_Paramedic_01_F") exitWith {};

player setCaptive true;

waitUntil {
	sleep 0.1;

	{side _x == independent && _x distance player < 3} count allUnits > 0 || !(currentWeapon player in ["", "ACE_Flashlight_Maglite_ML300L"])
};

player setCaptive false;
