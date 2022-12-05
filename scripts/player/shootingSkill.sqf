if (player getVariable ["Foley_isCivilian", false]) exitWith {
	[] spawn {
		while {alive player} do {
			player setCustomAimCoef 1000;
			sleep 1;
		};
	};
	player setUnitRecoilCoefficient 3;
};

if (player getVariable ["Foley_badShootingSkill", false]) exitWith {
	[] spawn {
		while {alive player} do {
			player setCustomAimCoef 1.5;
			sleep 1;
		};
	};
	player setUnitRecoilCoefficient 1.5;
};
