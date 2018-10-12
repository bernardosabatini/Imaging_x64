function executeFocusCallback
	global state gh
    global focusInput focusOutput pcellFocusOutput 
    
	persistent multipleAbortAttempts
	
	if (exist('multipleAbortAttempts', 'var')~=1)
		multipleAbortAttempts=0;
    end
    
    if isempty(multipleAbortAttempts)
        multipleAbortAttempts=0;
    end
    
	if strcmp(get(gh.siGUI_ImagingControls.focusButton, 'String'), 'FOCUS')
		if strcmp(get(gh.basicConfigurationGUI.figure1, 'Visible'), 'on')
			beep;
			setStatusString('Close ConfigurationGUI');
			return
		end
		
		if timerGetPackageStatus('Imaging')
			beep;
			setStatusString('Running. Stop processes');
			return
		end

		timerRequestPause('Imaging');
		setStatusString('Focusing...');
		set(gh.siGUI_ImagingControls.focusButton, 'String', 'ABORT');
		set(gh.fieldAdjustGUI.focusButton, 'String', 'abort');

		set(gh.siGUI_ImagingControls.grabOneButton, 'Visible', 'Off');

		if state.internal.looping
			state.internal.cyclePaused=1;
		end
		turnOffMenus;
		
		if state.imaging.daq.autoReadPMTOffsets
			siSession_readPMTOffsets;
		end
		
		mp285Flush;
		siSet_counters
        siSession_focus_flushData
        siSession_focus_queueData
        
        if state.internal.updatedZoomOrRot % need to reput the data with the approprite rotation and zoom.
            state.internal.updatedZoomOrRot=0;
 		end

		
		state.internal.abortActionFunctions=0;
		multipleAbortAttempts=0;
	
        state.internal.status=2;
        state.internal.lastTaskDone=2;
    
        focusOutput.startBackground();
        if state.pcell.pcellOn
            pcellFocusOutput.startBackground();
        end
        focusInput.startBackground();
	else
		multipleAbortAttempts=multipleAbortAttempts+1;
		if focusInput.IsRunning
            siSession_focus_abort;
		else
			state.internal.abortActionFunctions=1;
			if multipleAbortAttempts>1
				siSession_focus_abort;
    			if multipleAbortAttempts>2
                    disp('Multiple abort attempts.  Will force abort.');
                end
			end
		end
	end
	

