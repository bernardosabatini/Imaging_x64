function siSession_prepareOutput(force)
	global state
	
	if state.analysisMode
		return
    end

    if nargin<1
        force=0;
    end
    
    siSession_calculateOutput(force)
	global grabInput
	grabInput.NumberOfScans=sampleFactor*state.internal.samplesPerFrame*state.acq.numberOfFrames;

	if state.internal.status==0 || state.internal.status==4 % nothing or waiting then change grab parameters
		siSession_focus_flushData
		siSession_grab_flushData
        if state.pcell.pcellOn
            siSession_pcellsToDefault
        end
	elseif state.internal.status==2 % if focusing, leave flags set for future change.  Let makeStripe catch the need to change
		state.internal.pauseAndRotate=1;
	elseif state.internal.status==3 % grabbing -- recognize that they hit the button, but do nothing until next acquisition
		if state.internal.needNewRepeatedMirrorOutput || state.internal.needNewPcellRepeatedOutput
			disp('siSession_prepareOutput : Changes will be applied after grab is complete');
		end
	end		

	
	