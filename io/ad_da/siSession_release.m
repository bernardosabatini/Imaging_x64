function [outputArg1,outputArg2] = siSession_release
%siSession_release_all release data acquisition devices from the sessions
    global focusInput focusOutput pcellFocusOutput

    focusInput.release()
    focusOutput.release()
    global state
    if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
        pcellFocusOutput.release()
    end
    
end

