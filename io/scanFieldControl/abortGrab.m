function abortGrab
	global state gh
	global grabInput grabOutput pcellGrabOutput
	setStatusString('Aborting Grab...');

	grabInput.stop();
    grabOutput.stop();

    if state.pcell.pcellOn
        pcellGrabOutput.stop();
        if pcellGrabOutput.IsRunning
            setStatusString('waiting for output');
            disp(' WARNING: If does not progress from this state, ^C and siSession_hardKill');
            pcellGrabOutput.wait();
        end
        pcellGrabOutput.release();
        siSession_pcellsToDefault;
    end
    
    set(gh.siGUI_ImagingControls.grabOneButton, 'Enable', 'off');

    if grabInput.IsRunning
        setStatusString('waiting for input');
        disp(' WARNING: If does not progress from this state, ^C and siSession_hardKill');
        grabInput.wait();
    end

    if grabOutput.IsRunning
        setStatusString('waiting for output');
        disp(' WARNING: If does not progress from this state, ^C and siSession_hardKill');
        grabOutput.wait();
    end

    grabInput.release();
    grabOutput.release();
    
	state.internal.abortActionFunctions=0;
   
	state.internal.status=0;
% 	try
% 		flushData(grabInput);
% 	catch
% %		disp('abortGrab: error in input flush data.  proceeding...');
% 	end
		
    % reset motors
	mp285Flush;
	executeGoHome;

	set(gh.siGUI_ImagingControls.grabOneButton, 'String', 'GRAB');
	set(gh.siGUI_ImagingControls.grabOneButton, 'Enable', 'on');
	set(gh.siGUI_ImagingControls.focusButton, 'Visible', 'On');

%	siRedrawImages([], max(state.internal.frameCounter,1));
	timerSetPackageStatus(0, 'Imaging');
	timerCheckIfAllAborted;
	setStatusString('');

