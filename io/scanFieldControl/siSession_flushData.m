function siSession_flushData

    global focusOutput pcellFocusOutput state
	
    if focusOutput.ScansQueued>0
		focusOutput.stop()
        if focusOutput.ScansQueued>0
            focusOutput.release()
        end
        if focusOutput.ScansQueued>0
            error('siSession_flushData: focusOutput flush failed');
        end
    end
	
    if state.pcell.pcellOn && ~state.pcell.usingOutputBoard && pcellFocusOutput.ScansQueued>0
		pcellFocusOutput.stop()
        if pcellFocusOutput.ScansQueued>0
            pcellFocusOutput.release()
        end
        if pcellFocusOutput.ScansQueued>0
            error('siSession_flushData: pcellFocusOutput flush failed');
        end
    end
