sleep 3;

waitUntil {
	sleep 1;
	Foley_suspectsHostile || player inArea Foley_hotArea1 || player inArea Foley_hotArea2
};

private _text = "<t font='PuristaBold' size='1.6'>25 [Tour] Close Quarters</t><br />by Foley";
[parseText _text, true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
