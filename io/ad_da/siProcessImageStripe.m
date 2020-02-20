function siProcessImageStripe(stripeData, averaging)

% siProcessImageStripe.m*****
% Takes data from data acquisition engine,
% formats it into a proper intensity image,
% and displays it
%
% Written by: Bernardo Sabatini
% Harvard Medical School
% HHMI
% 2009

	global state lastAcquiredFrame compositeData
	if nargin<2
		averaging=0;
	end
	
	if state.acq.dualLaserMode==2	% we are acquiring with alternating
		tempStripe=cell(1, state.imaging.daq.maximumNumberOfInputChannels);
	else
		tempStripe=cell(1, state.imaging.daq.maximumNumberOfInputChannels+10);
	end
	
	channelList=find(state.acq.acquiringChannel);
	startLine = 1 + state.acq.linesPerFrame/state.internal.numberOfStripes*state.internal.stripeCounter;
	stopLine = startLine + state.acq.linesPerFrame/state.internal.numberOfStripes - 1;

    for channelCounter = 1:length(channelList)
		channel=channelList(channelCounter);
		if state.acq.acquiringChannel(channel)  % are we acquiring data on this channel?
			if state.acq.(['pmtOffsetAutoSubtractChannel' num2str(channelCounter)])
				offset=state.acq.(['pmtOffsetChannel' num2str(channelCounter)]); % get PMT offset for channel
			else
				offset=0;
			end
								
			if state.acq.dualLaserMode==1 % both lasers are on at once
				displayChannel=channel;
				
				processedData = reshape(stripeData(:, channelCounter)/state.imaging.internal.intensityScaleFactor,  ...
					state.internal.samplesPerLine, ...
					(state.acq.linesPerFrame/state.internal.numberOfStripes))' ...
					- offset;
				
				if state.acq.bidi		% We are acquiring in both directions
					% so flip every other line
					vStripeW=state.test;
 					processedData(2:2:end,:)=fliplr(processedData(2:2:end,:));
					if vStripeW>0
						vStripe=processedData(2:2:end,end-vStripeW:end);
						processedData(2:2:end, :)=[vStripe processedData(2:2:end, 1:end-vStripeW-1)];
					end
				end
				
				tempStripe{channel}=...
					add2d(...
					processedData(:, state.internal.startDataColumnInLine:state.internal.endDataColumnInLine), ...
					state.acq.binFactor...
					);  
			elseif state.acq.dualLaserMode==2 % we are acquiring with alternating
				% lasers.  So process as two separate channels
				displayChannel=[channel channel+10];
				
				processedData=reshape(stripeData(:, channelCounter)/state.imaging.internal.intensityScaleFactor,  ...
					state.internal.samplesPerLine, ...
					(2*state.acq.linesPerFrame/state.internal.numberOfStripes))' ...
					- offset; % get twice as much data

				if state.acq.bidi		% We are acquiring in both directions
					% so flip every other line
 					processedData(2:2:end,:)=fliplr(processedData(2:2:end,:));
				end
				
				tempStripe{channel}=...
					add2d(...
					processedData(1:2:end-1, state.internal.startDataColumnInLine:state.internal.endDataColumnInLine), ...
					state.acq.binFactor...
					);  
				
				tempStripe{channel+10}=...
					add2d(...
					processedData(2:2:end, state.internal.startDataColumnInLine:state.internal.endDataColumnInLine), ...
					state.acq.binFactor...
					);  
			else
				disp('error')
			end
			
			clear processedData

			for channelToDisplay=displayChannel
				if averaging && (state.internal.frameCounter>1)
					lastAcquiredFrame{channelToDisplay}(startLine:stopLine,:) = ...
						(((state.internal.frameCounter - 1) ...	
						* lastAcquiredFrame{channelToDisplay}(startLine:stopLine,:))...
						+ tempStripe{channelToDisplay})...
						/state.internal.frameCounter;					
				else
					lastAcquiredFrame{channelToDisplay}(startLine:stopLine,:) = tempStripe{channelToDisplay};
				end
				
				if state.acq.imagingChannel(channel)
                    state.imaging.internal.imageHandle{channelToDisplay, state.internal.stripeCounter+1}.CData = ...
 						lastAcquiredFrame{channelToDisplay}(startLine:stopLine,:);
				end
			end
		end	
	end
	

	if state.internal.composite
		for counter=1:3
			channel=state.internal.compositeChannelSelections(counter);
			
			if channel>0 && channel<99 && state.acq.acquiringChannel(mod(channel,10)) && ...
					(state.acq.dualLaserMode==2 || (state.acq.dualLaserMode==1 && channel<=4))
				
				low = state.internal.(['lowPixelValue' num2str(channel)]);
				high = state.internal.(['highPixelValue' num2str(channel)]);

				compositeData(startLine:stopLine,:,counter)=...
					min(max(...
					(lastAcquiredFrame{channel}(startLine:stopLine,:) - low) / ...
					max(high-low,1)...
					,0)...
					,1);
			end
		end
		state.imaging.internal.compositeImageHandle{state.internal.stripeCounter+1}.CData= ...
            compositeData(startLine:stopLine,:,:);
    end
	
	clear tempStripe displayChannel




		