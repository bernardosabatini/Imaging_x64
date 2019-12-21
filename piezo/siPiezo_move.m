function siPiezo_move(position)
%siPiezo_move_next_slice move pieze to next position in stack
%   Detailed explanation goes here
    
    global state
    if nargin<1
        position=state.piezo.next_pos;
    end
    
    if state.piezo.useUSBControl
        siPiezo_move_USB(position)
    else
        siPiezo_move_analog(position)
    end
	