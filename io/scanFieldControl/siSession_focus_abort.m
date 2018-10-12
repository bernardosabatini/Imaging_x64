function siSession_focus_abort
	global state gh
	state.internal.abortActionFunctions=0;
	
	global focusInput focusOutput pcellFocusOutput
    focusInput.stop()
    focusOutput.stop()
    if state.pcell.pcellOn
        pcellFocusOutput.stop()
    	siSession_pcellsToDefault;
    end
	
	setStatusString('Aborting Focus...');
	set(gh.siGUI_ImagingControls.focusButton, 'Enable', 'off');

    siSession_focus_flushData
	mp285Flush;
	
	set(gh.siGUI_ImagingControls.focusButton, 'String', 'FOCUS');
	set(gh.siGUI_ImagingControls.focusButton, 'Enable', 'on');
	set(gh.fieldAdjustGUI.focusButton, 'String', 'focus');	

	if ~state.internal.looping
		set(gh.siGUI_ImagingControls.grabOneButton, 'Visible', 'On');
		turnOnMenus;
		state.internal.status=0;
%		siSession_prepareOutput;
	else
		state.internal.status=4;
	%	siSession_prepareOutput;
		turnOffMenus;

		state.internal.abortActionFunctions=0;
		setStatusString('Resuming loop...');
	
		updateGuiByGlobal('state.internal.frameCounter');
		updateGuiByGlobal('state.internal.zSliceCounter');

		state.internal.abort=0;
		state.internal.currentMode=3;

		mainLoop;
	end

	siRedrawImages;
	setStatusString('');
	timerReleasePause('Imaging');
	
