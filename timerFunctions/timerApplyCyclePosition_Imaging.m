function timerApplyCyclePosition_Imaging
	global state
	global gh
	
	redo=0;
%	'timerApplyCyclePosition_Imaging'
    
	state.acq.zStepSize = state.cycle.zStepSizeList(state.cycle.currentCyclePosition);
	updateGuiByGlobal('state.acq.zStepSize');
	
	if state.acq.autoTrack ~= state.cycle.trackerList(state.cycle.currentCyclePosition)
		state.acq.autoTrack=state.cycle.trackerList(state.cycle.currentCyclePosition);
		updateGuiByGlobal('state.acq.autoTrack');
	end
		
	if state.cycle.blasterList(state.cycle.currentCyclePosition)>0
		if ~state.blaster.active
			state.blaster.active=1;
			updateGuiByGlobal('state.blaster.active');
			if state.blaster.blankImaging
				state.internal.needNewPcellPowerOutput=1;
			end	
			redo=1;
		end
		if state.blaster.currentConfig ~= state.cycle.blasterList(state.cycle.currentCyclePosition)
			redo=1;
			c=get(gh.blaster.Config, 'Children');
			set(c, 'Checked', 'off');
			f=find(strcmp(get(c, 'Label'), [num2str(state.cycle.blasterList(state.cycle.currentCyclePosition))...
					' ' state.blaster.allConfigs{state.cycle.blasterList(state.cycle.currentCyclePosition),1}]));
			if ~isempty(f)
				set(c(f(1)), 'Checked', 'on');
			end
		end
	elseif state.blaster.active
		state.blaster.active=0;
		updateGuiByGlobal('state.blaster.active');
		if state.blaster.blankImaging
			state.internal.needNewPcellPowerOutput=1;
		end	
		redo=1;
	end
	state.blaster.currentConfig = state.cycle.blasterList(state.cycle.currentCyclePosition);

	if state.acq.lineScan ~= state.cycle.linescanList(state.cycle.currentCyclePosition)
		state.acq.lineScan = state.cycle.linescanList(state.cycle.currentCyclePosition);
		state.internal.needNewRotatedMirrorOutput=1;
		updateGuiByGlobal('state.acq.lineScan');
		redo=1;
	end
	
	if state.acq.numberOfZSlices ~= state.cycle.numberOfZSlicesList(state.cycle.currentCyclePosition)
		state.acq.numberOfZSlices = state.cycle.numberOfZSlicesList(state.cycle.currentCyclePosition);
		updateGuiByGlobal('state.acq.numberOfZSlices');
	end
	
	if state.acq.numberOfFrames ~= state.cycle.framesList(state.cycle.currentCyclePosition)
		state.acq.numberOfFrames = state.cycle.framesList(state.cycle.currentCyclePosition);
		updateGuiByGlobal('state.acq.numberOfFrames');
		redo=1;
	end
	
	if state.acq.averaging~=state.cycle.avgFramesList(state.cycle.currentCyclePosition)
		state.acq.averaging=state.cycle.avgFramesList(state.cycle.currentCyclePosition);
		updateGuiByGlobal('state.acq.averaging');
    end

	if redo
		state.internal.needNewRepeatedMirrorOutput=1;
		state.internal.needNewPcellRepeatedOutput=1;
    end
    
    siSession_prepareOutput
	


	
	