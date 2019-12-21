function siSession_focus_queueData(varargin)
%siSession_focus_queueData: Puts the data in the queue to drive mirrors and
%   pcells while focusing

	global state focusOutput pcellFocusOutput
	
    if state.pcell.pcellOn
        if state.pcell.usingOutputBoard
            % they are the same board 
            % only one output
            focusOutput.queueOutputData([...
                state.acq.rotatedMirrorData ...
                state.acq.pcellPowerOutput ...
                ]);		
        else % different boards
            auxOutputChannels=get(pcellFocusOutput, 'Channels');
            if length(auxOutputChannels)>2*state.pcell.numberOfPcells
                pcellFocusOutput.removeChannel((2*state.pcell.numberOfPcells+1):length(auxOutputChannels));
            end  
                        
            focusOutput.queueOutputData(state.acq.rotatedMirrorData);	
            pcellFocusOutput.queueOutputData(state.acq.pcellPowerOutput);		
        end            
    else
        focusOutput.queueOutputData(state.acq.rotatedMirrorData);	
    end

