function out=timerIsSessionDone_Imaging
    global focusInput focusOutput pcellFocusOutput state
    
    out=0;
    if focusInput.IsContinuous    
        return
    end
    
    if state.timer.abort
        out=1;
        return
    end
    
    if focusInput.IsRunning
    	out=0;
        return
    else
        out=1;
        focusOutput.stop();
        if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
            pcellFocusOutput.stop();
        end
    end
    
    siSession_release % release the sessions
	siSession_outputs_to_default % close shutters and pcells
    siMaxProjections_calcAndSave

    state.internal.zSliceCounter = state.internal.zSliceCounter + 1;
	updateGuiByGlobal('state.internal.zSliceCounter');
	
	if state.internal.zSliceCounter >= state.acq.numberOfZSlices
	% Done Acquisition.
		if state.files.autoSave		% BSMOD - Check status of autoSave option
			setStatusString('Saving data');
			writeData;
        end
        		
		if state.acq.numberOfZSlices > 1
			if state.piezo.usePiezo
			else
				mp285FinishMove(1);	% check that movement worked during stack
			end
			siSession_end_stack_go_home;
        end				
        out=1;
	else
	% Between Acquisitions or ZSlices
        if state.acq.numberOfZSlices > 1
            siSession_start_slice_move      % start movement - focal plane down one step
        end
        setStatusString('Next Slice...');

		if state.files.autoSave		% BSMOD - Check status of autoSave option
			setStatusString('Saving images');
			writeData;
		end
	
		state.internal.frameCounter = 0;
		updateGuiByGlobal('state.internal.frameCounter');
				
		% if there is slice specific pcell control, remake the pcell output
		if state.pcell.boxSliceSpecific
			makeNewPcellRepeatedOutput;
		end

		setStatusString('Acquiring...');

		if state.piezo.usePiezo
		else
			mp285FinishMove(0);	% check that movement worked during stack
        end
		
        siSession_restart_stack
        out=0;
	end
 
