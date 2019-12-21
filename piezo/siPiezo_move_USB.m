function siPiezo_move_USB(position)
%siPiezo_move_USB Move the piezo to the position

    global state 

    if ~state.piezo.usePiezo || ~state.piezo.useUSBControl
        return
    end
    
    if nargin<1
        position=state.piezo.next_pos;
    end
    
    state.piezo.next_pos=position;    
    updateGuiByGlobal('state.piezo.next_pos');
    
    global PIdevice
    
    PIdevice.MOV ( state.piezo.axis, position );
    setStatusString( 'Piezo moving')
    % wait for motion to stop
    while(PIdevice.IsMoving ( state.piezo.axis ) )
        pause ( 0.1 );
        fprintf('.');
    end

    positionReached = PIdevice.qPOS(state.piezo.axis)
    setStatusString( '')
    state.piezo.last_pos=position;
end

