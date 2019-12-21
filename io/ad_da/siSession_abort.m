function siSession_abort
	global state gh
	global focusInput focusOutput pcellFocusOutput
	setStatusString('Aborting Grab...');

	focusInput.stop();
    focusOutput.stop();
    if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
        pcellFocusOutput.stop();
    end

    set(gh.siGUI_ImagingControls.grabOneButton, 'Enable', 'off');

    if focusInput.IsRunning
        setStatusString('waiting for input');
        disp(' WARNING: If does not progress from this state, ^C and siSession_hardKill');
        focusInput.wait();
    end

    if focusOutput.IsRunning
        setStatusString('waiting for output');
        disp(' WARNING: If does not progress from this state, ^C and siSession_hardKill');
        focusOutput.wait();
    end

    if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
        if pcellFocusOutput.IsRunning
            setStatusString('waiting for pcell output');
            disp(' WARNING: If does not progress from this state, ^C and siSession_hardKill');
            pcellFocusOutput.wait();
        end
        pcellFocusOutput.release();
    end
    
    focusOutput.release();
    focusInput.release();
    siSession_outputs_to_default;
    
	state.internal.abortActionFunctions=0;
   
	state.internal.status=0;
		
    % reset motors
	mp285Flush;
	siSession_end_stack_go_home;

	set(gh.siGUI_ImagingControls.grabOneButton, 'String', 'GRAB');
	set(gh.siGUI_ImagingControls.grabOneButton, 'Enable', 'on');
	set(gh.siGUI_ImagingControls.grabOneButton, 'Visible', 'On');
	set(gh.siGUI_ImagingControls.focusButton, 'String', 'FOCUS');
	set(gh.siGUI_ImagingControls.focusButton, 'Visible', 'On');
	set(gh.siGUI_ImagingControls.focusButton, 'Enable', 'on');
    turnOnMenus
    timerReleasePause('Imaging')
    
%	siFigures_redraw([], max(state.internal.frameCounter,1));
	timerSetPackageStatus(0, 'Imaging');
	timerCheckIfAllAborted;
	setStatusString('');

