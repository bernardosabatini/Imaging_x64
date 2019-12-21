function siSession_end_acquisition(varargin)
	% endAcquisition.m*****
	% Function called at the end of the acquistion that will park the laser, close the shutter,
	% write the data to disk, reset the counters (internal), reset the currentMode, and make the 
	% Grab One and Loop buttons visible.
	%
	% Written By: Thomas Pologruto and Bernardo Sabatini
	% Harvard Medical School
	% Cold Spring Harbor Labs
	% 2001-2009, 2019 updated to 64 bit by Bernardo Sabatini
	
	global state imageData projectionData
    
    'in end acquisiotn' 
    
    siSession_release
         
    if state.acq.numberOfZSlices > 1
		siSession_start_slice_move      % start movement - focal plane down one step
    end
    
	siSession_outputs_to_default % close shutters and pcells
	siMaxProjections_calcAndSave

	state.internal.zSliceCounter = state.internal.zSliceCounter + 1;
	updateGuiByGlobal('state.internal.zSliceCounter');
	
	if state.internal.zSliceCounter >= state.acq.numberOfZSlices
	% Done Acquisition.
		if state.files.autoSave		% BSMOD - Check status of autoSave option
			setStatusString('Saving images');
			writeData;
        end
        		
		if state.acq.numberOfZSlices > 1
			if state.piezo.usePiezo
			else
				mp285FinishMove(1);	% check that movement worked during stack
			end
			siSession_end_stack_go_home;
		end				

%		siFigures_redraw
		setStatusString('Cleaning up');
		timerRegisterPackageDone('Imaging');	
	else
	% Between Acquisitions or ZSlices
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
	end
	

	
	
	