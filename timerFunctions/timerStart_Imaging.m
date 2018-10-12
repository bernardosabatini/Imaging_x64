function timerStart_Imaging
	global state gh

	timerSetPackageStatus(1, 'Imaging');
		
	set(gh.siGUI_ImagingControls.grabOneButton, 'String', 'ABORT');
	set(gh.siGUI_ImagingControls.focusButton, 'Visible', 'Off');

    
	global grabOutput pcellGrabOutput
        
    siSession_grab_flushData
	siSession_grab_queueData

    grabOutput.startBackground();
    if state.pcell.pcellOn
        pcellGrabOutput.startBackground();
    end

	state.internal.status=3;
	state.internal.lastTaskDone=3;




 	
