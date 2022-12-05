private _buildingFeatures = [
	"elevator_marker",
	"ladder1_marker",
	"ladder2_marker",
	"door1_marker",
	"door2_3_marker",
	"door4_marker"
];

{
	_x setMarkerShadowLocal false;
} forEach _buildingFeatures;

[] spawn {
	private _unitMarkers = [
		"command_marker",
		"tac_marker",
		"sierra_marker",
		"hotel_marker",
		"emt_marker",
		"police_marker"
	];

	waitUntil {
		sleep 1;
		time > 30
	};

	{
		_x setMarkerAlphaLocal 0;
	} forEach _unitMarkers;
};
