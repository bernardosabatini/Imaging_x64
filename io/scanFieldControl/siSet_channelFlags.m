function siSet_channelFlags
	global state
	
	for counter = 1:state.imaging.daq.maximumNumberOfInputChannels
		state.acq.acquiringChannel(counter) = state.acq.(['acquiringChannel' num2str(counter)]);
		state.acq.savingChannel(counter) = state.acq.(['savingChannel' num2str(counter)]);
		state.acq.imagingChannel(counter) = state.acq.(['imagingChannel' num2str(counter)]);
		state.acq.maxImage(counter) = state.acq.(['maxImage' num2str(counter)]);
	end

