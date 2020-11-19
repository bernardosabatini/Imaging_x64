function siSession_outputs_to_default(parkXY)
% siSession_outputs_to_default: Outputs voltages to park the mirrors, put
% the pcells to default, and close the shutters


    global state focusOutput pcellFocusOutput  
    focusOutput.stop()
    focusOutput.release()

    if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
        pcellFocusOutput.stop()
        pcellFocusOutput.release()
    end
    
    
    if nargin<1
        dataOut= [state.acq.scanOffsetX state.acq.scanOffsetY];
    else
        dataOut=parkXY;
    end
    
    if state.pcell.pcellOn
        dataOutPcell=zeros(1, state.pcell.numberOfPcells);
        for counter=1:state.pcell.numberOfPcells
            pow=state.pcell.(['pcellDefaultLevel' num2str(counter)]);
            if pow==-1
                pow=state.pcell.(['pcellScanning' num2str(counter)]);
            end
            dataOutPcell(counter)=powerToPcellVoltage(pow, counter);
            dataOutPcell(counter+state.pcell.numberOfPcells)=state.shutter.closed;
        end
    end
    
    try 
        if state.pcell.pcellOn
            if state.pcell.usingOutputBoard
            % they are the same board 
            % only one output        
                focusOutput.outputSingleScan([dataOut dataOutPcell])
            else
                focusOutput.outputSingleScan(dataOut)
                pcellFocusOutput.outputSingleScan(dataOutPcell)
            end
        else
            focusOutput.outputSingleScan(dataOut)
        end
    catch
        disp('error in siSession_outputs_to_default')
        disp('unclear why')
    end
