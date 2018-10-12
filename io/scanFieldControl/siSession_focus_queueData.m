function siSession_focus_queueData(source, event)

	global state
	global focusOutput pcellFocusOutput
	
	focusOutput.queueOutputData(state.acq.rotatedMirrorData);	
    if state.pcell.pcellOn
        pcellFocusOutput.queueOutputData(state.acq.pcellPowerOutput);		
    end
