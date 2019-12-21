function siSession_grab_flushData
	global state grabOutput pcellGrabOutput

    if grabOutput.ScansQueued>0
        'flushed needed'
		grabOutput.stop()
        if grabOutput.ScansQueued>0
            grabOutput.release()
        end
        if grabOutput.ScansQueued>0
            error('siSession_grab_flushData: grabOutput flush failed');
        end
    end

