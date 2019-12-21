function siSession_restart_stack(varargin)
%siSession_restart_stack Starts next stack slice

    global focusInput focusOutput pcellFocusOutput state
    focusInput.stop()
    focusOutput.stop()
    if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
        pcellFocusOutput.stop();
    end
    
    siSession_flushData
    siSession_grab_queueData
    timerStart_Imaging
    timerTrigger_Imaging

end

