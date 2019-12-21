function status=timerReadyForTrigger_Imaging
	global state focusOutput pcellFocusOutput
	
	status=1;	% good to do
	
	if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
		if ~pcellFocusOutput.IsRunning
			status=0; % not ready
			disp('timerReadyForTrigger_Imaging: pcellFocusOutput device not ready');
		end
	end	

	if ~focusOutput.IsRunning
		status=0; % not ready
		disp('timerReadyForTrigger_Imaging: focusOutput device not ready');
	end


