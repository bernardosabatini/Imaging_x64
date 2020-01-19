function siListener_grabStripe(~, event)
	global state imageData

% makeFrame.m*****
% Data Acquisition (SamplesAcquired) Action Function
% Used with the contMode.m script to update frames on the screen after each frame.
% Takes data from data acquisition engine and formats it into a proper intensity image.
%
% This function will take the datainput from the DAQ engine and remove the data for the
% lines that are acquired.  It will then bin the matrix along the columns to produce a final image
% 
% The image will update every frame on the screen as data is recorded.
% The data is stored in the cell array imageData{X}(:,:,frames)(X = 1,2,3...) , where X is the channel Acquired the frames are indexed in the third dimension.
% 
% This action function also handles averaging over frames.
% 
% Written by: Thomas Pologruto and Bernardo Sabatini
% Cold Spring Harbor Labs
% January 31, 2001
% Rewritten 2010-2018 Bernardo Sabatini HMS/HHMI
% updgraded to 64 bit 2018

% Write complete header string  for only the first frame
	
    if state.imaging.daq.invertInput
    	stripeData = -1*event.Data;
    else
        stripeData = event.Data;
    end   
    
    if state.internal.abortActionFunctions
        siSession_abort
        return
    end
    
    if state.internal.stripeCounter==0
		if state.cycle.loopingStatus==1
			state.internal.secondsCounter=floor(state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime));
        else
			state.internal.secondsCounter=floor(etime(clock,state.internal.triggerTime));
		end
		updateGuiByGlobal('state.internal.secondsCounter');
    end
	
 	try
		siProcessImageStripe(stripeData, state.acq.averaging);
		state.internal.stripeCounter = state.internal.stripeCounter + 1;
	catch
        setStatusString('Error in frame by stripes');
        disp('makeFrameByStripes: Error in action function');
        disp(lasterr);
    end
    
    if state.internal.stripeCounter==state.internal.numberOfStripes % we finished a frame
		state.internal.frameCounter=state.internal.frameCounter + 1;	% Increments the frameCounter to ensure proper image storage and display
		updateGuiByGlobal('state.internal.frameCounter');	% Updates the frame Counter on the main controls GUI.
		state.internal.stripeCounter=0;
		
		if state.internal.keepAllSlicesInMemory
			if state.acq.averaging
				framePosition=state.internal.zSliceCounter + 1;
			else
				framePosition=(state.internal.frameCounter + state.internal.zSliceCounter*state.acq.numberOfFrames);
			end
		else
			if state.acq.averaging
				framePosition=1;
			else
				framePosition = state.internal.frameCounter;
			end
		end
		
		global lastAcquiredFrame
		for channel=find(state.acq.acquiringChannel)
			imageData{channel}(:,:,framePosition)=lastAcquiredFrame{channel}(:,:);
			if state.acq.dualLaserMode==2
				imageData{channel+10}(:,:,framePosition)=lastAcquiredFrame{channel+10}(:,:);
			end
        end

        if state.internal.abortActionFunctions
            siSession_abort
            return
        end
        
        if state.internal.frameCounter >= state.acq.numberOfFrames
             global  focusInput 
             focusInput.stop();
        % we finished the required frames for this slice 	
		end
	end


