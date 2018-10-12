function timerSetTriggerMaster_Imaging
    global state grabInput grabOutput pcellGrabOutput

    madeChanges=...
        timerSession_ensureTriggerConnections(grabInput, 1, state.timer.triggerLine);
    
    madeChanges=...
        timerSession_ensureTriggerConnections(grabOutput, 0, state.timer.triggerLine);

     if state.pcell.pcellOn
        madeChanges=...
            timerSession_ensureTriggerConnections(pcellGrabOutput, 0, state.timer.triggerLine);
     end

     if madeChanges
         state.phys.internal.needNewOutputChannels=1;
         state.phys.internal.needNewOutputData=1;
     end

    state.imaging.daq.triggerSetToMaster=1;
        