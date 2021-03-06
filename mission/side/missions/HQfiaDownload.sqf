/*
@file: HQfia.sqf
Author:

	Quiksilver
	
Last modified:

	3/08/2014
	
Description:

	Download enemy File data from Laptop by MaDmaX[GC]

____________________________________*/

private ["_flatPos","_accepted","_position","_enemiesArray","_fuzzyPos","_x","_briefing","_unitsArray","_object","_SMveh","_SMaa","_tower1","_tower2","_tower3","_c4Message"];

_c4Message = ["Supply crate secured. The charge has been set! 15 seconds until detonation.","Weapons secured. The explosives have been set! 15 seconds until detonation.","Insurgents supply secured. The charge is planted! 15 seconds until detonation."] call BIS_fnc_selectRandom;

//-------------------- FIND POSITION FOR OBJECTIVE

	_flatPos = [0,0,0];
	_accepted = false;
	while {!_accepted} do {
		_position = [] call BIS_fnc_randomPos;
		_flatPos = _position isFlatEmpty [10,1,0.2,sizeOf "Land_Dome_Small_F",0,false];

		while {(count _flatPos) < 2} do {
			_position = [] call BIS_fnc_randomPos;
			_flatPos = _position isFlatEmpty [10,1,0.2,sizeOf "Land_Dome_Small_F",0,false];
		};

		if ((_flatPos distance (getMarkerPos "respawn")) > 1700 && (_flatPos distance (getMarkerPos currentAO)) > 500) then {
			_accepted = true;
		};
	};

//-------------------- SPAWN OBJECTIVE

	sideObj = "Box_East_WpsSpecial_F" createVehicle _flatPos;
	waitUntil {alive sideObj};
	sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), (getPos sideObj select 2)];
	sideObj setVectorUp [0,0,1];
	sideObj allowDamage false;
	
	_object = [crate5,crate6] call BIS_fnc_selectRandom;
	_object setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) + 2)];
	sleep 0.3;
	_tower1 = [sideObj, 50, 0] call BIS_fnc_relPos;
	_tower2 = [sideObj, 50, 120] call BIS_fnc_relPos;
	_tower3 = [sideObj, 50, 240] call BIS_fnc_relPos;
	sleep 0.3;
	tower1 = "Land_Cargo_Patrol_V2_F" createVehicle _tower1;
	tower2 = "Land_Cargo_Patrol_V2_F" createVehicle _tower2;
	tower3 = "Land_Cargo_Patrol_V2_F" createVehicle _tower3;
	sleep 0.3;
	tower1 setDir 180;
	tower2 setDir 300;
	tower3 setDir 60;
	sideObj setVelocity [0,10,0];
	
	{ _x allowDamage false } forEach [tower1,tower2,tower3];
	sleep 0.3;
	
	
	
//-------------------- SPAWN FORCE PROTECTION

	
	_enemiesArray = [sideObj] call QS_fnc_SMenemyFIA;
	
//-------------------- SPAWN BRIEFING

	_fuzzyPos = [((_flatPos select 0) - 300) + (random 600),((_flatPos select 1) - 300) + (random 600),0];

	{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
	"sideMarker" setMarkerText "Side Mission: Download Enemy File Data"; publicVariable "sideMarker";
	publicVariable "sideObj";
	
	_briefing = "<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Download Enemy File Data</t><br/>____________________<br/>OPFOR are training an insurgency on Altis.<br/><br/>We've marked the position on your map; head over there, sanitize the area and secure their files on the computer.</t>";
	GlobalHint = _briefing; hint parseText GlobalHint; publicVariable "GlobalHint";
	showNotification = ["NewSideMissionFileData", "Download Enemy File Data"]; publicVariable "showNotification";
	sideMarkerText = "Download Enemy File Data"; publicVariable "sideMarkerText";
	
//-------------------- [ CORE LOOPS ] ------------------------ [ CORE LOOPS ]

	sideMissionUp = true; publicVariable "sideMissionUp";
	SM_SUCCESS = false; publicVariable "SM_SUCCESS";

while { sideMissionUp } do {

	//--------------------------------------------- IF PACKAGE DESTROYED [FAIL]

	if (!alive sideObj) exitWith {
	
		
		
		//-------------------- DE-BRIEFING
		
		sideMissionUp = false; publicVariable "sideMissionUp";
		
		showNotification = ["NewSideMissionFileDataComplete", "Well done, we got the Files."]; publicVariable "showNotification";
		hqSideChat = "Objective complete!"; publicVariable "hqSideChat"; [WEST,"HQ"] sideChat hqSideChat;
		[] spawn QS_fnc_SMhintSUCCESS;
		{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker", "sideCircle"]; publicVariable "sideMarker";
		
		//-------------------- DELETE
		
		_object setPos [-10000,-10000,0];
		sleep 120;
		{ deleteVehicle _x } forEach [sideObj,tower1,tower2,tower3];
		deleteVehicle nearestObject [getPos sideObj,"Land_Cargo_HQ_V2_ruins_F"];
		[_enemiesArray] spawn QS_fnc_SMdelete;
	};
	
	//----------------------------------------------- IF PACKAGE SECURED [SUCCESS]
	
	if (SM_SUCCESS) exitWith {
		
		hqSideChat = _c4Message; publicVariable "hqSideChat"; [WEST,"HQ"] sideChat hqSideChat;
	
		//-------------------- BOOM!
	
		sleep 12;											// ghetto bomb timer
		"Bo_Mk82" createVehicle getPos _object; 			// default "Bo_Mk82"
		sleep 0.1;
		_object setPos [-10000,-10000,0];					// hide objective
	
		//-------------------- DE-BRIEFING

		sideMissionUp = false; publicVariable "sideMissionUp";
		[] call QS_fnc_SMhintSUCCESS;
		{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker", "sideCircle"]; publicVariable "sideMarker";
	
		sleep 4;
	
	[] execVM "mission\ressources\SMCredits.sqf";
	
	/*
	// Get the current credits of my_factory
	_creditsSmall = my_factory_small getVariable "R3F_LOG_CF_credits";
	_creditsMedium = my_factory_medium getVariable "R3F_LOG_CF_credits";
	_creditsBig = my_factory_big getVariable "R3F_LOG_CF_credits";
	
	// Add 15 000 to the value
	_creditsSmall = _creditsSmall + PARAMS_SMCredits;
	_creditsMedium = _creditsMedium + PARAMS_SMCredits;
	_creditsBig = _creditsBig + PARAMS_SMCredits;
	
	// Set the new credits
	my_factory_small setVariable ["R3F_LOG_CF_credits", _creditsSmall, true];
	my_factory_medium setVariable ["R3F_LOG_CF_credits", _creditsMedium, true];
	my_factory_big setVariable ["R3F_LOG_CF_credits", _creditsBig, true];
	
	getCreditsFactory = PARAMS_SMCredits;
	
	//showNotification = ["GetCredits", "80000 Credits added to Factory"]; publicVariable "showNotification";
	
	showNotification = ["GetCredits", getCreditsFactory]; publicVariable "showNotification";
	*/
		
		//--------------------- DELETE
		sleep 120;
		{ deleteVehicle _x } forEach [sideObj,tower1,tower2,tower3];
		deleteVehicle nearestObject [getPos sideObj,"Land_Cargo_HQ_V1_ruins_F"];
		[_enemiesArray] spawn QS_fnc_SMdelete;
	};
};