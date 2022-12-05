private _modules = [
	"enemyStereotypes.sqf",
	"enemyDeployment.sqf",
	"hostages.sqf",
	"utils.sqf"
];

{
	call compile preprocessFileLineNumbers ("scripts\server\modules\" + _x);
} forEach _modules;
