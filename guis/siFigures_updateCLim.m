function siFigures_updateCLim(channelList, frame)
	global state
	
	if nargin<2
		frame=[];
	end
	
	if (nargin<1) || isempty(channelList)
		channelList=find(state.acq.acquiringChannel);
		if state.acq.dualLaserMode==2
			channelList=[channelList channelList+10];
		end
	end
	
	for counter=channelList
        low = state.internal.(['lowPixelValue' num2str(counter)]);
        high = state.internal.(['highPixelValue' num2str(counter)]);
        for sCounter=1:state.internal.numberOfStripes
            state.imaging.internal.axisHandle{counter,sCounter}.CLim = [low high];
            state.imaging.internal.maxAxisHandle{counter,sCounter}.CLim = [low high];
        end
    end
    
    siFigures_drawComposite(frame);