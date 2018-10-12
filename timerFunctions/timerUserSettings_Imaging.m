function timerUserSettings_Imaging
    global state
    
	loadConfig;
	siSet_keepAllSlicesCheckMark; % 
	makeConfigurationMenu;
	reloadPcellTables;

    if ~isempty(state.blaster.setupName) & ~isempty(state.blaster.setupPath)
		loadBlasterSetup(state.blaster.setupPath, state.blaster.setupName)
	end
	