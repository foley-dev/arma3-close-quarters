setViewDistance 2000;

if (isServer) then {
	_hour = 4;
	_minute = 0;

	if (Foley_param_timeOfDay == 2) then {
		_hour = 19;
		_minute = 0;
	};

	if (Foley_param_timeOfDay == 3) then {
		_hour = 22;
		_minute = 30;
	};

	setDate [2013, 6, 9, _hour, _minute];
};
