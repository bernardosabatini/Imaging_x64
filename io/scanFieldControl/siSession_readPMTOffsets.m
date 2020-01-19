function siSession_readPMTOffsets
	global state focusInput

	setStatusString('Reading PMT offsets...');
%	siSession_release;
    
    tempData=zeros(length(find(state.acq.acquiringChannel)),10);
    for counter=1:100
        tempData(:, counter)=focusInput.inputSingleScan()/state.imaging.internal.intensityScaleFactor;
    end
    focusInput.release();
    
    if state.imaging.daq.invertInput
        tempData=-1*tempData;
    end
    
    tempDataAvg=mean(tempData, 2);
    
    inputChannelCounter = 0;
	for channelCounter=find(state.acq.acquiringChannel)
		inputChannelCounter = inputChannelCounter + 1;
		state.acq.(['pmtOffsetChannel' num2str(channelCounter)]) = tempDataAvg(inputChannelCounter);
		updateHeaderString(['state.acq.pmtOffsetChannel' num2str(channelCounter)]);
	end
	
	setStatusString('');
	
	
