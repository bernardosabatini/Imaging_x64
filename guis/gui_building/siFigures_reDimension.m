function siFigures_reDimension
	global state 

	setStatusString('Fixing windows...');
	
	startImageData = int16(zeros(state.internal.linesPerStripe, state.acq.pixelsPerLine));
	axisYStep=1/state.internal.numberOfStripes;
    
    axisPosition = [0 1-axisYStep 1 axisYStep];
    axisOffset = [0 axisYStep 0 0];
	aspectRatio = (state.internal.imageAspectRatioBias*state.acq.scanAmplitudeY/state.acq.scanAmplitudeX); % /(state.acq.linesPerFrame/state.acq.pixelsPerLine);
	
%	setupScanImageFigurePositions;
	
	% This loop creates the appropriate images, figures and axes.
	
    channelList=[1:state.imaging.daq.maximumNumberOfInputChannels 11:10+state.imaging.daq.maximumNumberOfInputChannels];

    for channelCounter = channelList
        
        set(state.imaging.internal.maxAxisHandle{channelCounter, 1}, ...
            'XLim', [1 state.acq.pixelsPerLine], ...
            'YLim', [1 state.acq.linesPerFrame]...
            );
        
        state.imaging.internal.maxImageHandle{channelCounter, 1}.CData= ...
            int16(zeros(state.acq.linesPerFrame, state.acq.pixelsPerLine));
    
        for stripeCounter=1:state.internal.numberOfStripes
            set(state.imaging.internal.axisHandle{channelCounter, stripeCounter}, ...
                'XLim', [1 state.acq.pixelsPerLine], ...
                'YLim', [1 state.internal.linesPerStripe] ...
            );
  
            state.imaging.internal.imageHandle{channelCounter, stripeCounter}.CData = ...
                startImageData;  
        end
        
	end
		
    for stripeCounter=1:state.internal.numberOfStripes
        set(state.imaging.internal.compositeAxisHandle{stripeCounter}, ...
            'XLim', [1 state.acq.pixelsPerLine], ...
            'YLim', [1 state.internal.linesPerStripe] ...
        );

        state.imaging.internal.compositeImageHandle{stripeCounter}.CData= ...
            startImageData;
    end
    
	setStatusString('');
