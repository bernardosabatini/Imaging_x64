function siMaxProjections_calcAndSave
	global state imageData projectionData
	% Calculate and display any projections
	if ((state.acq.numberOfFrames==1) || state.acq.averaging) && any(state.acq.maxImage)
		if state.internal.keepAllSlicesInMemory % BSMOD 1/18/2
			position = state.internal.zSliceCounter + 1;
		else
			position = 1;
		end

        channelList=find(state.acq.acquiringChannel.*state.acq.maxImage);
        if state.acq.dualLaserMode==2   % lasers go simulataneously therefor one image window per laser
            channelList=[channelList channelList+10];
        end

		for channel = channelList
			inputChannel=mod(channel, 10);
			if state.internal.zSliceCounter==0			% BSMOD2 2/27/2
				projectionData{channel} = imageData{channel}(:,:,position);
			else
				if state.acq.maxMode==0
					projectionData{channel} = max(imageData{channel}(:,:,position), ...
						projectionData{channel});
				else
					projectionData{channel} = ...
						(imageData{channel}(:,:,state.internal.zSliceCounter + 1) + ...
						state.internal.zSliceCounter*projectionData{channel})/(state.internal.zSliceCounter + 1);
					%  BSMOD 1/18/2 eliminated reliance on position for above 2 lines
				end
			end
			% Displays the current Max images on the screen as they are acquired.
			set(state.imaging.internal.maxImageHandle{channel, 1}, 'CData', ...
				projectionData{channel});
		end
		
		drawnow;	
		setStatusString('Saving projections');
		writeMaxData;
    end