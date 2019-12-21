function siSession_focus_stopAndRestart
	global state

	state.internal.pauseAndRotate=0;

    global focusInput focusOutput pcellFocusOutput
    focusInput.stop()
    focusOutput.stop()
    if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
        pcellFocusOutput.stop()
    end

	siSession_outputs_to_default
	siSession_flushData
    siSession_focus_queueData
	
	state.internal.stripeCounter=0;
	state.internal.frameCounter = 0;
	updateGuiByGlobal('state.internal.frameCounter');
	
    focusOutput.startBackground();
    if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
        pcellFocusOutput.startBackground()
    end    
    focusInput.startBackground();


	