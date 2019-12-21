function siSession_piezo_interupt_and_move
% siSession_piezo_interupt_and_move: Move pizeo.  Stop scan if necessary

	global state

    if ~state.piezo.usePiezo
        return
    end
    
    if state.internal.status==0 || state.internal.status==4 % nothing or waiting then change grab parameters
		siPiezo_move;
	elseif state.internal.status==2 % if focusing, leave flags set for future change.  Let makeStripe catch the need to change
		state.internal.pauseAndRotate=1;
        global focusInput focusOutput  
        focusInput.stop()
        focusOutput.stop()
        focusOutput.release()
        siPiezo_move;
        siSession_focus_stopAndRestart

	elseif state.internal.status==3 % grabbing -- recognize that they hit the button, but do nothing until next acquisition
		if state.internal.needNewRepeatedMirrorOutput || state.internal.needNewPcellRepeatedOutput
			disp('siSession_prepareOutput : Changes will be applied after grab is complete');
		end
    end		
    
    

