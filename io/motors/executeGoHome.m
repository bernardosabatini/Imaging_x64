function moved=executeGoHome
	moved=0;

	global state
	
	if (state.acq.numberOfZSlices > 1) && state.acq.returnHome
		if state.piezo.usePiezo
			state.piezo.next_pos=state.motor.stackStart;
			siPiezo_move
		else
            if ~state.motor.motorOn
                return 
            end
			if length(state.internal.initialMotorPosition) ~= 3
				if state.motor.motorOn
					disp('executeGoHome: attempt to return to initial position but initial position is corrupted.');
				end
			else
				setStatusString('Moving to home...');
				state.motor.absXPosition=state.internal.initialMotorPosition(1);
				state.motor.absYPosition=state.internal.initialMotorPosition(2);
				state.motor.absZPosition=state.internal.initialMotorPosition(3);
				MP285SetVelocity(state.motor.velocityFast);
				setMotorPosition;
				MP285SetVelocity(state.motor.velocitySlow);
				updateRelativeMotorPosition;
				moved=1;
				setStatusString('');
			end
		end
		
	end				
