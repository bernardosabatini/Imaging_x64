function siSession_parkMirrors(xy)
	global state focusOutput
	
	if nargin~=1
		focusOutput.outputSingleScan(...
            [state.acq.scanOffsetX state.acq.scanOffsetY]);
        focusOutput.release()
	else
		if length(xy)~=2
			error('siSession_parkMirrors: expected [x y] as input');
		else
            focusOutput.outputSingleScan(...
                [state.acq.scanOffsetX state.acq.scanOffsetY]+xy);
            focusOutput.release()
		end
	end
	
	
