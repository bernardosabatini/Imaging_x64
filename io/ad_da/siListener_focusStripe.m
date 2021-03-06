function siListener_focusStripe(~, event)
% makeStripe.m*****
% Action Function
% Called during the focusMode.m script execution.
% Takes data from data acquisition engine and formats it into a proper intensity image.
%
% This function will take the datainput from the DAQ engine and remove the data for the
% lines that are acquired.  It will then bin the matrix along the columns to produce a final 1024 x 1024 image
%
% Written by: Thomas Pologruto & Bernardo Sabatini
% Harvard Medical School
% HHMI
% Cold Spring Harbor Labs
% 2002 - 2009


	global state
	
	if state.internal.pauseAndRotate
		siSession_focus_stopAndRestart
		return
	end

	if state.internal.stripeCounter==0
		if state.internal.looping==1
			state.internal.secondsCounter=floor(state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime));
		else
			state.internal.secondsCounter=floor(etime(clock,state.internal.triggerTime));
        end
		updateGuiByGlobal('state.internal.secondsCounter');
    end
    
    if state.imaging.daq.invertInput
    	stripeData = -1*event.Data;
    else
        stripeData = event.Data;
    end        
    round(1000*mean(stripeData))
    
	siProcessImageStripe(stripeData, 0);
	
	if state.internal.pauseAndRotate
		siSession_focus_stopAndRestart
		return
	end
	
	if state.internal.abortActionFunctions
		siSession_abort
	end

	state.internal.stripeCounter = state.internal.stripeCounter + 1; % increments the stripecounter to ensure proper image displays
	if  state.internal.stripeCounter == state.internal.numberOfStripes			
		state.internal.stripeCounter = 0;
		state.internal.frameCounter = state.internal.frameCounter + 1;
		updateGuiByGlobal('state.internal.frameCounter');
	end
	
	if state.internal.abortActionFunctions
		siSession_abort
		return
	end




		