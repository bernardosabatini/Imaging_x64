function siSet_compositeChannels
	global state
	
	state.internal.compositeChannelSelections=[state.internal.redCompositeChannel state.internal.greenCompositeChannel state.internal.blueCompositeChannel]-1;
	
	for channelCounter=1:3
		if state.internal.compositeChannelSelections(channelCounter)>state.imaging.daq.maximumNumberOfInputChannels
			if state.internal.compositeChannelSelections(channelCounter)==9
				state.internal.compositeChannelSelections(channelCounter)=99; % code for reference image
			else
				state.internal.compositeChannelSelections(channelCounter)=...
					state.internal.compositeChannelSelections(channelCounter)-state.imaging.daq.maximumNumberOfInputChannels+10;
			end
		end
	end