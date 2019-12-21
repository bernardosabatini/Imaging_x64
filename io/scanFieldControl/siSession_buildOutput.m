function siSession_buildOutput
    global state

    % setups components of AO Objects that are config independent
    if state.analysisMode
        return
    end

    global  focusOutput  pcellFocusOutput

    % Mirror Output (FOCUS)
    if ~isempty(focusOutput)
        setStatusString('delete focusOutput')
        delete(focusOutput);
    end

    setStatusString('create focusOutput')
    focusOutput=daq.createSession('ni');
    focusOutput.Rate=state.acq.outputRate;
    state.acq.actualOutputRate=focusOutput.Rate;
    if state.acq.actualOutputRate~=state.acq.outputRate
        disp('*** siSession_buildOutput : Desired output rate not achieved')
        disp(['    acutal rate is ' num2str(state.acq.actualOutputRate)]);
    end

    setStatusString('add channels')

    % output channel for X scan
    ch=focusOutput.addAnalogOutputChannel(...
        state.imaging.daq.outputBoard, ...
        ['ao' num2str(state.imaging.daq.XMirrorChannelIndex)],...
        'Voltage'...
        );
    ch.Range=[-10 10];

    % output channel for Y scan
    ch=focusOutput.addAnalogOutputChannel(...
        state.imaging.daq.outputBoard, ...
        ['ao' num2str(state.imaging.daq.YMirrorChannelIndex)],...
        'Voltage'...
        );
    ch.Range=[-10 10];

    % will be triggered by the input board
    focusOutput.addTriggerConnection(...
        'external', ...
        [state.imaging.daq.outputBoard '/' state.imaging.daq.outputTrigger], ...
        'StartTrigger'...
        );

    state.pcell.usingOutputBoard=0;
    if state.pcell.pcellOn	% if using pockel cells
        state.pcell.usingOutputBoard=... set flag is same board used
            strcmp(state.pcell.pcellBoard, state.imaging.daq.outputBoard);
        setStatusString('pcell device')

        if ~isempty(pcellFocusOutput)
            delete(pcellFocusOutput);
        end

        setStatusString('create pcellFocusOutput')
        if ~state.pcell.usingOutputBoard % different boards
            pcellFocusOutput=daq.createSession('ni');
            pcellFocusOutput.Rate=state.acq.outputRate;
            outputRate=pcellFocusOutput.Rate;
            if state.acq.actualOutputRate~=state.acq.outputRate
                disp('*** siSession_buildOutput : Desired output rate not achieved')
                disp(['    acutal rate is ' num2str(outputRate)]);
            end

        end

        setStatusString('addchannels')
        for counter=1:state.pcell.numberOfPcells % add the lower channels for the pcells
            if state.pcell.usingOutputBoard % it is the same board
                ch=focusOutput.addAnalogOutputChannel(...
                    state.pcell.pcellBoard, ...
                    ['ao' num2str(counter-1)],...
                    'Voltage'...
                    );
            else
                ch=pcellFocusOutput.addAnalogOutputChannel(...
                    state.pcell.pcellBoard, ...
                    ['ao' num2str(counter-1)],...
                    'Voltage'...
                    );
            end

            ch.Range=[-10 10];

        end

        for counter=1:state.pcell.numberOfPcells % add another set of channels for the shutters
            if state.pcell.usingOutputBoard % it is the same board
                ch=focusOutput.addAnalogOutputChannel(...
                    state.pcell.pcellBoard, ...
                    ['ao' num2str(counter-1+state.pcell.numberOfPcells)],...
                    'Voltage'...
                    );
            else
                ch=pcellFocusOutput.addAnalogOutputChannel(...
                    state.pcell.pcellBoard, ...
                    ['ao' num2str(counter-1+state.pcell.numberOfPcells)],...
                    'Voltage'...
                    );
            end
            ch.Range=[-10 10];
        end

        % are they the same board? Do we need more triggers and clocks?
        if ~state.pcell.usingOutputBoard
            % will be triggered by the input board
            setStatusString('triggers')
            pcellFocusOutput.addTriggerConnection(...
                'external', ...
                [state.pcell.pcellBoard '/' state.imaging.daq.outputTrigger], ...
                'StartTrigger'...
                );

            pcellFocusOutput.IsContinuous=1;
        end

        if ~strcmp(state.imaging.daq.inputBoard, state.pcell.pcellBoard) && ...
                ~state.pcell.usingOutputBoard
            % the scan clock will be controlled by the input board
            setStatusString('clocks')
            %             pcellFocusOutput.addClockConnection(...
            %                 'external', ...
            %                 [state.pcell.pcellBoard '/RTSI5'], ...
            %                 'ScanClock'...
            %                 );
        end
    end

    state.internal.lh_focusOutput=focusOutput.addlistener('DataRequired', @siSession_focus_queueData);
    state.internal.lh_focusOutput.Enabled=false;
        
    setStatusString('done')

    state.imaging.daq.needNewOutputSession=0;

