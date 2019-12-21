function siPiezo_move_analog(pos)

    global state
    
    if ~state.piezo.usePiezo
        return
    end
    
    if state.piezo.useUSBControl
        return
    end

    global piezoOutput

    if nargin>0
        state.piezo.next_pos=pos;
    end
    
    if(state.piezo.next_pos<0)
        state.piezo.next_pos=0;
    end

    if isempty(state.piezo.last_pos)
        disp('*** PIEZO START MISSING.  ABRUPT MOVE ***');
        state.piezo.last_pos=state.piezo.next_pos;
    end

    vstart=state.piezo.last_pos/state.piezo.gain ;
    vend=state.piezo.next_pos/state.piezo.gain ;

    state.piezo.tsec=abs(state.piezo.last_pos-state.piezo.next_pos)/state.piezo.velocity ;
    nsamples=round(state.piezo.tsec*10000) ; %10 kHz
    vdata=linspace(vstart, vend, nsamples)' ;

    if(nsamples>0)
        piezoOutput.queueOutputData(vdata);
        piezoOutput.startForeground;
    end
    piezoOutput.release();
    state.piezo.last_pos=state.piezo.next_pos ;
    updateGuiByGlobal('state.piezo.next_pos');