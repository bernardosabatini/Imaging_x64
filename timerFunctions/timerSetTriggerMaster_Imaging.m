function timerSetTriggerMaster_Imaging
    global state focusInput focusOutput pcellFocusOutput

    madeChanges=...
        timerSession_ensureTriggerConnections(focusInput, 1, state.timer.triggerLine);

    madeChanges=...
        timerSession_ensureTriggerConnections(focusOutput, 0, state.timer.triggerLine);

    if state.pcell.pcellOn
        madeChanges=...
            timerSession_ensureTriggerConnections(pcellFocusOutput, 0, state.timer.triggerLine);
    end

    if madeChanges
        state.phys.internal.needNewOutputChannels=1;
        state.phys.internal.needNewOutputData=1;
    end

    state.imaging.daq.triggerSetToMaster=1;
