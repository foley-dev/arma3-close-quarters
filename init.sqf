call compile preprocessFileLineNumbers "scripts\common\params.sqf";
call compile preprocessFileLineNumbers "scripts\common\timeAndWeather.sqf";
call compile preprocessFileLineNumbers "scripts\common\markers.sqf";
independent setFriend [blufor, 1];
blufor setFriend [independent, 0];
calculatePlayerVisibilityByFriendly true;

if (isServer) then {
	call compile preprocessFileLineNumbers "scripts\server\tasks.sqf";
	call compile preprocessFileLineNumbers "scripts\server\modules\init.sqf";
	call compile preprocessFileLineNumbers "scripts\server\ai.sqf";
	call compile preprocessFileLineNumbers "scripts\server\vehicles.sqf";
	execVM "scripts\server\endings.sqf";
};

if (hasInterface) then {
	waitUntil {
		!isNull player
	};

	player addRating 100000;

	call compile preprocessFileLineNumbers "scripts\player\briefing.sqf";
	call compile preprocessFileLineNumbers "scripts\player\shootingSkill.sqf";
	execVM "scripts\player\loadout.sqf";
	execVM "scripts\player\intro.sqf";
	execVM "scripts\player\radioSilence.sqf";
	execVM "scripts\player\outOfBounds.sqf";
	execVM "scripts\player\eventHandlers.sqf";
	execVM "scripts\player\neutralMedic.sqf";
};

[TOUR_respawnTickets, TOUR_respawnTime] execVM "scripts\TOUR_RC\init.sqf";

if (!isMultiplayer) then {
	execVM "scripts\common\singleplayerSetup.sqf";
};
