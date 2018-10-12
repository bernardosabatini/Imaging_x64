function siFigures_drawComposite(frame)
% siFigures_drawComposite Redraws the composite imaging window.  
% No argument draws the last acquired frame.  If frame is specified,  

	global state 
    if ~state.internal.composite	
        return
    end
    
    global imageData compositeData lastAcquiredFrame

    if nargin<1
        frame=[];
    end
    
	if state.internal.composite			
		compositeData = (zeros(state.acq.linesPerFrame, state.acq.pixelsPerLine, 3)); 	% BSMOD 7/17/2
		for counter=1:3
			channel=state.internal.compositeChannelSelections(counter);
			
			if channel==99 % they want the reference image
				if all([state.acq.linesPerFrame, state.acq.pixelsPerLine]==size(state.acq.trackerReferenceAll))
					low = getfield(state.internal, ['lowPixelValue' num2str(state.acq.trackerChannel)]);
					high = getfield(state.internal, ['highPixelValue' num2str(state.acq.trackerChannel)]);

					compositeData(:,:,counter)=...
						min(max(...
						(state.acq.trackerReferenceAll - low) / ...
						max(high-low,1)...
						,0)...
						,1);
				end
			elseif channel>0 && state.acq.acquiringChannel(mod(channel,10)) && ...
					(state.acq.dualLaserMode==2 || (state.acq.dualLaserMode==1 && channel<=4))
				
				low = getfield(state.internal, ['lowPixelValue' num2str(channel)]);
				high = getfield(state.internal, ['highPixelValue' num2str(channel)]);

				if isempty(frame)
					compositeData(:,:,counter)=...
						min(max(...
						(lastAcquiredFrame{channel} - low) / ...
						max(high-low,1)...
						,0)...
						,1);
				else
					frame=min(size(imageData{channel},3), frame);
					compositeData(:,:,counter)=...
						min(max(...
						(imageData{channel}(:,:,frame) - low) / ...
						max(high-low,1)...
						,0)...
						,1);
				end
			end
		end
    end
    
    for stripe=1:state.internal.numberOfStripes
		state.imaging.internal.compositeImageHandle{stripe}.CData= ...
            compositeData((stripe-1)*state.internal.linesPerStripe+1:stripe*state.internal.linesPerStripe,...
            :,...
            :);
    end
