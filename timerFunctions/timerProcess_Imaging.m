function timerProcess_Imaging
	global state gh

    trackImage;
	siFigures_updateReferenceImage;

	if any(state.internal.excelChannel) && (state.files.autoSave==1)
		try
			r=['r' num2str(25 + state.files.lastAcquisition)];
			ddepoke(state.internal.excelChannel, [r 'c10:' r 'c12'], [state.files.lastAcquisition state.epoch state.motor.distance]);
			ddepoke(state.internal.excelChannel, [r 'c13'], state.configName);
			ddepoke(state.internal.excelChannel, [r 'c14:' r 'c20'], ...
				[state.acq.numberOfFrames state.acq.averaging state.acq.numberOfZSlices ...
					state.acq.zoomFactor state.acq.scanRotation state.acq.lineScan state.blaster.active]);
			if state.blaster.active
				ddepoke(state.internal.excelChannel, [r 'c21'], state.blaster.setupName);
				if state.blaster.currentConfig
					ddepoke(state.internal.excelChannel, [r 'c22'], state.blaster.currentConfig);
					ddepoke(state.internal.excelChannel, [r 'c23'], state.blaster.allConfigs{state.blaster.currentConfig, 1});	
				end
			end
			ddepoke(state.internal.excelChannel, [r 'c24:' r 'c28'], ...
				[state.acq.autoTrack ...
					state.acq.pmtOffsetChannel1 ...
					state.acq.pmtOffsetChannel2 ...
					state.acq.pmtOffsetChannel3 ...
					state.acq.binFactor]);
		catch
			disp('timerProcess_Imaging : unable to link to excel');
		end
	end
	
	try
		if isfield(state, 'analysis')
			if isfield(state.analysis, 'analysisMode')
				setStatusString('Analyze Fluor....');
				runFluorAnalysis(state.files.fileCounter);
			end
		end
	catch
		setStatusString('ERROR in fluor analysis');
		disp('*** endAcquisition: error in fluor analysis');
		disp(lasterr);
	end	

	state.internal.status=0;

	if state.cycle.loopingStatus==0		% not a loop, just a single 
		set(gh.siGUI_ImagingControls.focusButton, 'Visible', 'On');
		set(gh.siGUI_ImagingControls.grabOneButton, 'String', 'GRAB');
		set(gh.siGUI_ImagingControls.grabOneButton, 'Visible', 'On');	
		turnOnMenus;
    else
		set(gh.siGUI_ImagingControls.focusButton, 'Visible', 'On');
	end
	
	if state.blaster.active && any(state.blaster.allConfigs{state.blaster.currentConfig, 2}(:, 6))
		state.blaster.acqList(state.blaster.tileCounter)=state.files.lastAcquisition;
		state.blaster.tileCounter = state.blaster.tileCounter + 1;
		if state.blaster.tileCounter>state.blaster.nTiles^2
			beep;
			disp('*** FINISHED TILER LOOP. ***')
			state.blaster.tileCounter=1;
		end
		updateGuiByGlobal('state.blaster.tileCounter')
		state.internal.needNewRepeatedMirrorOutput=1;
	end	

	if state.db.conn~=0
		fileName = [state.files.fullFileName '.tif'];
		state.db.imaging.tiff_lo_oid=lo_import(state.db.conn, fileName);
		addRecordByTable('imagingAcq');
	end

	siSet_counters

   	% if there is slice specific pcell control, ensure that it gets
	% remade with slice=1 in the next grab
	if state.pcell.boxSliceSpecific
		state.internal.needNewPcellRepeatedOutput=1;
	end
	
	if state.internal.abortActionFunctions
		siSession_abort
		return
	end
	
