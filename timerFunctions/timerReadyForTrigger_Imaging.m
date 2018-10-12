function status=timerReadyForTrigger_Imaging
	global state grabOutput pcellGrabOutput
	
	status=1;	% good to do
	
	if state.pcell.pcellOn
		if ~pcellGrabOutput.IsRunning
			status=0; % not ready
			disp('timerReadyForTrigger_Imaging: pcellGrabOutput device not ready');
		end
	end	

	if ~grabOutput.IsRunning
		status=0; % not ready
		disp('timerReadyForTrigger_Imaging: grabOutput device not ready');
	end


