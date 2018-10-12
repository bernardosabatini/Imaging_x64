function siSession_grab_flushData
	global state
	global grabOutput pcellGrabOutput
	
    if grabOutput.ScansQueued>0
		grabOutput.stop()
        if grabOutput.ScansQueued>0
            grabOutput.release()
        end
        if grabOutput.ScansQueued>0
            error('siSession_grab_flushData: grabOutput flush failed');
        end
    end

	if state.pcell.pcellOn
        if pcellGrabOutput.ScansQueued>0
            pcellGrabOutput.stop()
            if pcellGrabOutput.ScansQueued>0
                pcellGrabOutput.release()
            end
            if pcellGrabOutput.ScansQueued>0
                error('siSession_grab_flushData: pcellGrabOutput flush failed');
            end
        end
    end            
        