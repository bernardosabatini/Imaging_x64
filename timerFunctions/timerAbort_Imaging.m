function timerAbort_Imaging
	global state 

	state.internal.abortActionFunctions=1;
	state.internal.status=0;
    siSession_abort
    
