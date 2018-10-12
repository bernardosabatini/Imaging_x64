function timerSetup_Imaging
	global state
    
    siSession_setup
	siSession_calculateOutput		
    
    
    gotoCycleStagePosition(state.internal.firstTimeThroughLoop);

	if state.imaging.daq.autoReadPMTOffsets
		siSession_readPMTOffsets;
	end
	mp285Flush;
	if state.acq.numberOfZSlices > 1	
		state.internal.initialMotorPosition=updateMotorPosition;
	else
		state.internal.initialMotorPosition=[];
	end
	
	siSet_counters
	state.files.lastAcquisition=state.files.fileCounter;
	state.internal.abortActionFunctions=0;
	
	turnOffMenus;
	
	
		
