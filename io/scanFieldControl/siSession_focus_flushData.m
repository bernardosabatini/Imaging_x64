function siSession_focus_flushData
	global state
	global focusOutput pcellFocusOutput
	
    if focusOutput.ScansQueued>0
		focusOutput.stop()
        if focusOutput.ScansQueued>0
            focusOutput.release()
        end
        if focusOutput.ScansQueued>0
            error('siSession_focus_flushData: focusOutput flush failed');
        end
    end

	if state.pcell.pcellOn
        if pcellFocusOutput.ScansQueued>0
            pcellFocusOutput.stop()
            if pcellFocusOutput.ScansQueued>0
                pcellFocusOutput.release()
            end
            if pcellFocusOutput.ScansQueued>0
                error('siSession_focus_flushData: pcellFocusOutput flush failed');
            end
        end
    end            
        