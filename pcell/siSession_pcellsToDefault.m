function siSession_pcellsToDefault
	global state pcellFocusOutput 
    if ~state.pcell.pcellOn
        return
    end
    
	for counter=1:state.pcell.numberOfPcells
        pow=getfield(state.pcell, ['pcellDefaultLevel' num2str(counter)]);
        if pow==-1
          pow=getfield(state.pcell, ['pcellScanning' num2str(counter)]);          
        end
		vec(counter)=powerToPcellVoltage(pow, counter);
		vec(counter+state.pcell.numberOfPcells) = 5 * state.shutter.closed;
	end

	pcellFocusOutput.outputSingleScan(vec);
    
    


			