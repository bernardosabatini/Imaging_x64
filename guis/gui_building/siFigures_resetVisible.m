function siFigures_resetVisible(moveWindows)
	global state 
    
	if nargin<1
		moveWindows=1;
    end
    
	% This loop sets up the aspect ratios for the figures
	siFigures_udpateCLim;
	
	setupScanImageFigurePositions;
    
	for channelCounter = 1:state.imaging.daq.maximumNumberOfInputChannels % Count through all the channels
        inputChannelCounter=mod(channelCounter, 10);

        if moveWindows
			set(state.imaging.internal.figureHandle{channelCounter}, ...
				'Position', eval(['state.windowPositions.image' num2str(channelCounter) '_position'])...
				);
			set(state.imaging.internal.maxFigureHandle{channelCounter}, ...
				'Position', eval(['state.windowPositions.maxImage' num2str(channelCounter) '_position'])...
				);
            set(state.imaging.internal.figureHandle{channelCounter+10}, ...
                'Position', eval(['state.windowPositions.image' num2str(channelCounter+10) '_position'])...
                );
			set(state.imaging.internal.maxFigureHandle{channelCounter+10}, ...
				'Position', eval(['state.windowPositions.maxImage' num2str(channelCounter+10) '_position'])...
				);
        end
        
		if state.acq.imagingChannel(channelCounter) && state.acq.imagingChannel(channelCounter)	% is this one to be imaged and displayed?
			set(state.imaging.internal.figureHandle{channelCounter}, 'Visible', 'on');
    		if state.acq.maxImage(channelCounter)	% is this one to be calculated?
    			set(state.imaging.internal.maxFigureHandle{channelCounter}, 'Visible', 'on');
            end
            
            if state.acq.dualLaserMode==2   
    			set(state.imaging.internal.figureHandle{channelCounter+10}, 'Visible', 'on');
        		if state.acq.maxImage(channelCounter)	% is this one to be calculated?
        			set(state.imaging.internal.maxFigureHandle{channelCounter+10}, 'Visible', 'on');
                end
            end
        else
			set(state.imaging.internal.figureHandle{channelCounter}, 'Visible', 'off');
   			set(state.imaging.internal.figureHandle{channelCounter+10}, 'Visible', 'off');
			set(state.imaging.internal.maxFigureHandle{channelCounter}, 'Visible', 'off');
   			set(state.imaging.internal.maxFigureHandle{channelCounter+10}, 'Visible', 'off');
        end
	end

	if moveWindows
		set(state.imaging.internal.compositeFigureHandle, ...
			'Position', state.windowPositions.compositeImage_position...
			);
    end
    
	if state.internal.composite	% is thsi one to be imaged?
		set(state.imaging.internal.compositeFigureHandle, 'Visible', 'on');
	else
		set(state.imaging.internal.compositeFigureHandle, 'Visible', 'off');
    end
	
	setStatusString('');
