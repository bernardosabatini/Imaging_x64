function timerStart_Imaging
	global state gh focusOutput pcellFocusOutput 

	timerSetPackageStatus(1, 'Imaging');
		
	set(gh.siGUI_ImagingControls.grabOneButton, 'String', 'ABORT');
	set(gh.siGUI_ImagingControls.focusButton, 'Visible', 'Off');

    siSession_set_mode('grab')
    
    focusOutput.startBackground();
    if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
        pcellFocusOutput.startBackground();
    end

	state.internal.status=3;
	state.internal.lastTaskDone=3;

    



 	
