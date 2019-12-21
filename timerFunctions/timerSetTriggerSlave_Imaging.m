function timerSetTriggerSlave_Imaging
    global state focusInput focusOutput pcellFocusOutput
    
    madeChanges=...
        timerSession_ensureTriggerConnections(focusInput, 0, state.timer.triggerLine);
    
    madeChanges=...
        timerSession_ensureTriggerConnections(focusOutput, 0, state.timer.triggerLine);

    madeChanges=...
        timerSession_ensureTriggerConnections(pcellFocusOutput, 0, state.timer.triggerLine);

%     if madeChanges
%         state.phys.internal.needNewOutputChannels=1;
%         state.phys.internal.needNewOutputData=1;
%     end

    state.imaging.daq.triggerSetToMaster=0;
        
    
    
        