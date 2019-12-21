function timerTrigger_Imaging

    global focusInput state
    
    focusInput.startBackground() 
    if state.imaging.daq.imagingForcesDigitalTrigger
        siSession_do_digital_trigger
    end
