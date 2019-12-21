function trig=timerTriggerLine_Imaging
    global state
    if state.imaging.daq.imagingForcesDigitalTrigger
        trig=[state.imaging.daq.inputBoard '/' state.imaging.daq.triggerLine];
    else
        trig=[state.imaging.daq.inputBoard '/' state.imaging.daq.inputExportTriggerLine];
    end