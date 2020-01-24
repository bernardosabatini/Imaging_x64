function moveObjectiveUp(mm)

if nargin<1
    mm=1;
end

global state
mp285SetVelocity(state.motor.velocityFast*25)

updateMotorPosition
state.motor.absZPosition = state.motor.absZPosition + mm*1000; % Calcualte New value

newPos(1,1) = state.motor.absXPosition;		% Set X Position to new value
newPos(1,2) = state.motor.absYPosition;		% Set X Position to new value
newPos(1,3) = state.motor.absZPosition;		% Set X Position to new value

oldStatus=state.internal.statusString;
setStatusString('Moving stage...');

mp285StartMove(newPos);
setStatusString(oldStatus);
mp285FinishMove
mp285SetVelocity(state.motor.velocitySlow)
updateMotorPosition

