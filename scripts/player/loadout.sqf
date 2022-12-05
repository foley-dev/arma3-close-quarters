params [["_unit", player]];

waitUntil {
	!isNull player
};


private _loadouts = [
	[
		"B_officer_F",
		[[],[],["rhsusf_weap_glock17g4","","acc_flashlight_pistol","",["rhsusf_mag_17Rnd_9x19_FMJ",17],[],""],["UK3CB_TKP_I_U_Officer_BLK",[["ACE_EarPlugs",1],["ACE_fieldDressing",5],["ACE_tourniquet",1],["ACE_morphine",1],["ACE_CableTie",5],["ACRE_PRC148",1]]],["UK3CB_ADP_B_V_6b23_ml_TAN",[["rhsusf_mag_17Rnd_9x19_FMJ",2,17],["SmokeShellPurple",2,1],["SmokeShell",2,1]]],[],"UK3CB_CPD_B_H_Beret","",["rhsusf_bino_m24","","","",[],[],""],["ItemMap","ItemGPS","","ItemCompass","ItemWatch",""]]
	],
	[
		"B_medic_F",
		[[],[],["rhsusf_weap_glock17g4","","acc_flashlight_pistol","",["rhsusf_mag_17Rnd_9x19_FMJ",17],[],""],["UK3CB_TKP_I_U_CombatUniform_BLK",[["ACE_EarPlugs",1],["ACE_CableTie",5],["ACRE_PRC148",1]]],["UK3CB_ADP_B_V_6b23_medic_TAN",[["rhsusf_mag_17Rnd_9x19_FMJ",2,17],["SmokeShell",5,1],["ACE_fieldDressing",20],["ACE_elasticBandage",10],["ACE_packingBandage",10],["ACE_tourniquet",10],["ACE_morphine",10],["ACE_epinephrine",10],["ACE_adenosine",5]]],["UK3CB_UN_B_B_ASS",[["ACE_bloodIV",5],["ACE_bloodIV_500",5],["ACE_splint",5],["ACE_surgicalKit",1],["ACE_bodyBag",10]]],"UK3CB_TKP_B_H_Patrolcap_Off_TAN","",[],["ItemMap","ItemGPS","","ItemCompass","ItemWatch",""]]
	],
	[
		"B_soldier_M_F",
		[["srifle_DMR_02_F","","bipod_01_f_blk","rhsusf_acc_m8541",["ACE_10Rnd_762x67_Mk248_Mod_1_Mag",10],[],""],[],["rhsusf_weap_glock17g4","","acc_flashlight_pistol","",["rhsusf_mag_17Rnd_9x19_FMJ",17],[],""],["UK3CB_TKP_I_U_CIB_CombatUniform_DBLU",[["ACE_EarPlugs",1],["ACE_fieldDressing",5],["ACE_tourniquet",1],["ACE_morphine",1],["ACE_CableTie",5],["ACE_Kestrel4500",1],["ACE_RangeCard",1],["optic_mrco",1],["ACRE_PRC148",1]]],["UK3CB_ADP_B_V_6b23_ml_TAN",[["ACE_10Rnd_762x67_Mk248_Mod_1_Mag",1,10],["rhsusf_mag_17Rnd_9x19_FMJ",2,17],["SmokeShell",2,1]]],[],"H_Watchcap_blk","",["rhsusf_bino_lerca_1200_black","","","",[],[],""],["ItemMap","","","ItemCompass","ItemWatch",""]]
	],
	[
		"B_spotter_F",
		[["rhs_weap_m4a1_carryhandle","","rhsusf_acc_wmx_bk","rhsusf_acc_ACOG_USMC",["rhs_mag_30Rnd_556x45_M855_Stanag_Tracer_Red",30],[],""],[],["rhsusf_weap_glock17g4","","acc_flashlight_pistol","",["rhsusf_mag_17Rnd_9x19_FMJ",17],[],""],["UK3CB_TKP_I_U_CIB_CombatUniform_DBLU",[["ACE_EarPlugs",1],["ACE_fieldDressing",5],["ACE_tourniquet",1],["ACE_morphine",1],["ACE_CableTie",5],["ACE_Kestrel4500",1],["ACE_RangeCard",1],["ACRE_PRC148",1]]],["UK3CB_ADP_B_V_6b23_ml_TAN",[["rhs_mag_30Rnd_556x45_M855_Stanag_Tracer_Red",1,30],["rhsusf_mag_17Rnd_9x19_FMJ",2,17],["SmokeShell",2,1]]],[],"H_Watchcap_blk","",["rhsusf_bino_lerca_1200_black","","","",[],[],""],["ItemMap","ItemGPS","","ItemCompass","ItemWatch",""]]
	],
	[
		"B_Soldier_TL_F",
		[["rhs_weap_m4a1_carryhandle","","rhsusf_acc_wmx_bk","rhsusf_acc_eotech_552",["rhs_mag_30Rnd_556x45_M855_Stanag",30],[],""],[],["rhsusf_weap_glock17g4","","acc_flashlight_pistol","",["rhsusf_mag_17Rnd_9x19_FMJ",17],[],""],["UK3CB_TKP_I_U_CIB_CombatUniform_DBLU",[["ACE_EarPlugs",1],["ACE_fieldDressing",5],["ACE_tourniquet",1],["ACE_morphine",1],["ACE_CableTie",5],["ACE_acc_pointer_green",1],["ACRE_PRC148",1]]],["UK3CB_ADP_B_V_6b23_ML_6sh92_radio_TAN",[["rhs_mag_30Rnd_556x45_M855_Stanag",5,30],["rhsusf_mag_17Rnd_9x19_FMJ",2,17],["ACE_M84",3,1]]],[],"rhsusf_ach_bare_des_headset","",["rhsusf_bino_m24","","","",[],[],""],["ItemMap","ItemGPS","","ItemCompass","ItemWatch",""]]
	],
	[
		"B_Soldier_F",
		[["rhs_weap_m4a1_carryhandle","","rhsusf_acc_wmx_bk","rhsusf_acc_eotech_552",["rhs_mag_30Rnd_556x45_M855_Stanag",30],[],""],[],["rhsusf_weap_glock17g4","","acc_flashlight_pistol","",["rhsusf_mag_17Rnd_9x19_FMJ",17],[],""],["UK3CB_TKP_I_U_CIB_CombatUniform_DBLU",[["ACE_EarPlugs",1],["ACE_fieldDressing",5],["ACE_tourniquet",1],["ACE_morphine",1],["ACE_CableTie",5],["ACE_acc_pointer_green",1],["ACRE_PRC148",1]]],["UK3CB_ADP_B_V_6b23_ML_6sh92_radio_TAN",[["rhs_mag_30Rnd_556x45_M855_Stanag",5,30],["rhsusf_mag_17Rnd_9x19_FMJ",2,17],["ACE_M84",3,1]]],[],"rhsusf_ach_bare_des","",[],["ItemMap","","","ItemCompass","ItemWatch",""]]
	],
	[
		"B_Soldier_lite_F",
		[["UK3CB_MP5A4","","rhsusf_acc_wmx_bk","rhsusf_acc_mrds",["UK3CB_MP5_30Rnd_9x19_Magazine_R",30],[],""],[],["rhsusf_weap_glock17g4","","acc_flashlight_pistol","",["rhsusf_mag_17Rnd_9x19_FMJ",17],[],""],["UK3CB_TKP_I_U_CIB_CombatUniform_DBLU",[["ACE_EarPlugs",1],["ACE_fieldDressing",5],["ACE_tourniquet",1],["ACE_morphine",1],["ACE_CableTie",5],["ACE_acc_pointer_green",1],["ACRE_PRC148",1]]],["UK3CB_ADP_B_V_6b23_ML_6sh92_radio_TAN",[["UK3CB_MP5_30Rnd_9x19_Magazine_R",5,30],["rhsusf_mag_17Rnd_9x19_FMJ",2,17],["ACE_M84",3,1]]],[],"rhsusf_ach_bare_des","",[],["ItemMap","","","ItemCompass","ItemWatch",""]]
	],
	[
		"B_Soldier_SL_F",
		[[],[],["rhsusf_weap_glock17g4","","acc_flashlight_pistol","",["rhsusf_mag_17Rnd_9x19_JHP",17],[],""],["UK3CB_CPD_B_U_Policeman_01",[["ACE_CableTie",5],["ACE_fieldDressing",2],["ACE_tourniquet",1],["ACRE_PRC148",1],["rhsusf_mag_17Rnd_9x19_JHP",1,17]]],["UK3CB_BAF_V_Osprey_HiVis",[]],[],"UK3CB_CPD_B_H_Beret","",["Binocular","","","",[],[],""],["ItemMap","","","","ItemWatch",""]]
	],
	[
		"B_crew_F",
		[[],[],["rhsusf_weap_glock17g4","","acc_flashlight_pistol","",["rhsusf_mag_17Rnd_9x19_JHP",17],[],""],["UK3CB_CPD_B_U_Policeman_01",[["ACE_CableTie",5],["ACE_fieldDressing",2],["ACE_tourniquet",1],["ACRE_PRC148",1],["rhsusf_mag_17Rnd_9x19_JHP",1,17]]],["UK3CB_BAF_V_Osprey_HiVis",[]],[],"UK3CB_H_Police_Cap","",[],["ItemMap","","","","ItemWatch",""]]
	],
	[
		"C_Man_Paramedic_01_F",
		[[],[],[],["U_C_Paramedic_01_F",[["ACRE_PRC148",1],["ACE_Chemlight_HiWhite",1,1]]],[],["UK3CB_CHC_C_B_MED",[["ACE_fieldDressing",15],["ACE_elasticBandage",15],["ACE_packingBandage",15],["ACE_quikclot",15],["ACE_bloodIV_500",5],["ACE_splint",5],["ACE_surgicalKit",1],["ACE_morphine",10],["ACE_epinephrine",10],["ACE_adenosine",5],["ACE_tourniquet",10]]],"","",[],["ItemMap","","","","ItemWatch",""]]
	],
	[
		"B_Helipilot_F",
		[[],[],[],["UK3CB_TKP_I_U_Officer_BLK",[["ACE_fieldDressing",2],["ACE_EarPlugs",1],["ACRE_PRC148",1]]],["UK3CB_V_Pilot_Vest_Black",[["ACE_Chemlight_HiWhite",1,1]]],[],"H_Cap_headphones","G_Sport_BlackWhite",[],["ItemMap","","","ItemCompass","ItemWatch",""]]
	],
	[
		"B_helicrew_F",
		[[],[],[],["UK3CB_TKP_I_U_QRF_CombatUniform_BLK",[["ACE_fieldDressing",2],["ACE_EarPlugs",1],["ACRE_PRC148",1]]],["UK3CB_V_Pilot_Vest_Black",[["ACE_Chemlight_HiWhite",1,1]]],[],"UK3CB_BAF_H_Earphone","G_Sport_BlackWhite",[],["ItemMap","","","ItemCompass","ItemWatch",""]]
	]
];

private _loadout = (_loadouts select {(_x select 0) isEqualTo typeOf _unit}) select 0;
private _profileFacewear = goggles _unit;
_unit setUnitLoadout (_loadout select 1);
removeGoggles _unit;
_unit addGoggles _profileFacewear;

0 = [_unit] spawn {
	params ["_unit"];
	
	sleep 0.5;

	if (primaryWeapon _unit != "") exitWith {
		_unit playMoveNow "AmovPercMstpSlowWrflDnon";
	};

	if (handgunWeapon _unit != "") exitWith {
		_unit playMoveNow "AmovPercMstpSlowWpstDnon";
	};
};
