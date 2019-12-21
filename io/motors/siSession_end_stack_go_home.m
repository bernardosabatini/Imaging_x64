function moved=siSession_end_stack_go_home
	moved=0;
    
	global state
	
	if (state.acq.numberOfZSlices > 1) && state.acq.returnHome
		if state.piezo.usePiezo
			state.piezo.next_pos=state.piezo.start_stack;
			siPiezo_move
        end
        
        if state.motor.motorOn
            if length(state.internal.initialMotorPosition) ~= 3
                if state.motor.motorOn
                    disp('siSession_end_stack_go_home: attempt to return to initial position but initial position is corrupted.');
                end
            else
                setStatusString('Moving to home...');
                state.motor.absXPosition=state.internal.initialMotorPosition(1);
                state.motor.absYPosition=state.internal.initialMotorPosition(2);
                state.motor.absZPosition=state.internal.initialMotorPosition(3);
                mp285SetVelocity(state.motor.velocityFast);
                setMotorPosition;
                mp285SetVelocity(state.motor.velocitySlow);
                updateRelativeMotorPosition;
                moved=1;
                setStatusString('');
            end
        end
    end
