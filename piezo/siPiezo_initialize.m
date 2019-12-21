function siPiezo_initialize
%siSession_make_piezo Makes the session that handles analog output to the
%piezo

    global state piezoOutput
    if ~state.piezo.usePiezo
        return
    end

    if ~isempty(piezoOutput)
        delete(piezoOutput);
    end

    if state.piezo.useUSBControl
        'siPiezo_initialize should not be here'
    else
        piezoOutput=daq.createSession('ni');
        ch=addAnalogOutputChannel(piezoOutput,  ...
            state.piezo.piezoBoard, ...
            ['ao' num2str(state.piezo.piezoChannelIndex)], ...
            'Voltage');
        ch.Range=[-10 10];
        piezoOutput.Rate=10000;
        state.piezo.last_pos=0;
        state.piezo.next_pos=0;
        outputSingleScan(piezoOutput, 0)
        piezoOutput.release();
        updateGuiByGlobal('state.piezo.next_pos')
    end
    
end

