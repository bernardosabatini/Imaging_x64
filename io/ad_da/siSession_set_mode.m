function siSession_set_mode(focusOrGrab, force)
    global state
    global focusInput focusOutput pcellFocusOutput

    if nargin<1
        focusOrGrab='default';
    end

    if nargin<2
        force=0;
    end

    persistent oldMode

    if ~exist('oldMode')
        oldMode='';
    end

    if force==1
        oldMode='';
    end

    switch focusOrGrab
        case 'focus'
            if ~strcmp(oldMode, 'focus')
                focusInput.IsContinuous=1;
                state.internal.lh_focus.Enabled=true;
                state.internal.lh_grab.Enabled=false;
                focusInput.NotifyWhenDataAvailableExceeds=state.internal.samplesPerStripe;

                state.internal.lh_focusOutput.Enabled=true;
                focusOutput.IsContinuous=1;
                if state.pcell.pcellOn && state.pcell.usingOutputBoard ...% pcell on and different board?
                    pcellFocusOutput.IsContinuous=1;
                end
            end
            oldMode=focusOrGrab;
            siSession_flushData
            siSession_focus_queueData
        case 'grab'
            if ~strcmp(oldMode, 'grab')
                focusInput.IsContinuous=0;
                state.internal.lh_focus.Enabled=false;
                state.internal.lh_grab.Enabled=true;
                focusInput.NotifyWhenDataAvailableExceeds=state.internal.samplesPerStripe;

                state.internal.lh_focusOutput.Enabled=false;
                focusOutput.IsContinuous=1;
                if state.pcell.pcellOn && state.pcell.usingOutputBoard ...% pcell on and different board?
                    pcellFocusOutput.IsContinuous=0;
                end
            end
            oldMode=focusOrGrab;
            focusInput.NumberOfScans=state.internal.extraSampleFactor*state.internal.samplesPerFrame*state.acq.numberOfFrames;
            siSession_allocateMemory
            siSession_flushData
            siSession_grab_queueData
        otherwise
            disp(['unknown mode: ' focusOrGrab]);
            oldMode='';
    end
