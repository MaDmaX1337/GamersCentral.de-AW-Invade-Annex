if (PARAMS_CreditsReward == 1) then {
if(isServer) then { 

private ["_creditsSmall","_creditsMedium","_creditsBig"];
	// Get the current credits of my_factory
	_creditsSmall = my_factory_small getVariable "R3F_LOG_CF_credits";
	_creditsMedium = my_factory_medium getVariable "R3F_LOG_CF_credits";
	_creditsBig = my_factory_big getVariable "R3F_LOG_CF_credits";
	
	// Add 15 000 to the value
	_creditsSmall = _creditsSmall + PARAMS_AOCompleteCredits;
	_creditsMedium = _creditsMedium + PARAMS_AOCompleteCredits;
	_creditsBig = _creditsBig + PARAMS_AOCompleteCredits;
	
	// Set the new credits
	my_factory_small setVariable ["R3F_LOG_CF_credits", _creditsSmall, true];
	my_factory_medium setVariable ["R3F_LOG_CF_credits", _creditsMedium, true];
	my_factory_big setVariable ["R3F_LOG_CF_credits", _creditsBig, true];
	
	getCreditsFactory = PARAMS_AOCompleteCredits;
	
	//showNotification = ["GetCredits", "80000 Credits added to Factory"]; publicVariable "showNotification";
	};
	showNotification = ["GetCredits", getCreditsFactory]; publicVariable "showNotification";
	my_factory_small setVariable ["R3F_LOG_CF_disabled", false];
	my_factory_medium setVariable ["R3F_LOG_CF_disabled", false];
	my_factory_big setVariable ["R3F_LOG_CF_disabled", false];
	};