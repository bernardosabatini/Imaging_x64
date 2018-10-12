function siSession_readPMTOffsets
	global state focusInput
   
	setStatusString('Reading PMT offsets...');
	
    tempData=focusInput.inputSingleScan()/state.internal.intensityScaleFactor;
    focusInput.release();
    
    inputChannelCounter = 0;
	for channelCounter=find(state.acq.acquiringChannel)
		inputChannelCounter = inputChannelCounter + 1;
		state.acq.(['pmtOffsetChannel' num2str(channelCounter)]) = tempData(inputChannelCounter);
		updateHeaderString(['state.acq.pmtOffsetChannel' num2str(channelCounter)]);
	end
	
	setStatusString('');
	
	
