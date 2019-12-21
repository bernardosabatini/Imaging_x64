function siPiezo_move_next_slice
%siPiezo_move_next_slice move pieze to next position in stack
%   Detailed explanation goes here
    
    global state
    state.piezo.next_pos=state.piezo.next_pos+state.acq.zStepSize;
    siPiezo_move;
  