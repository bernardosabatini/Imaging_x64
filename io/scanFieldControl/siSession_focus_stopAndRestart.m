function siSession_focus_stopAndRestart
	global state

	state.internal.pauseAndRotate=0;

	global focusInput focusOutput pcellFocusOutput
    focusInput.stop()
    focusOutput.stop()
    if state.pcell.pcellOn
        pcellFocusOutput.stop();
    end

	siSession_pcellsToDefault
	siSession_focus_flushData
    siSession_focus_queueData
	
	state.internal.stripeCounter=0;
	state.internal.frameCounter = 0;
	updateGuiByGlobal('state.internal.frameCounter');
	
    focusOutput.startBackground();
    if state.pcell.pcellOn
        pcellFocusOutput.startBackground();
    end
    focusInput.startBackground();

	