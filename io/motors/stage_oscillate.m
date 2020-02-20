function stage_oscillate(mm)

if nargin<1
    mm=0.1;
end

global state
mp285SetVelocity(round(state.motor.velocityFast))

updateMotorPosition;
setStatusString('Oscillating stage...');
newPos(1,1) = state.motor.absXPosition;		% Set X Position to new value
newPos(1,2) = state.motor.absYPosition;		% Set X Position to new value
newPos(1,3) = state.motor.absZPosition;		% Set X Position to new value

initPos=state.motor.absYPosition;
oldStatus=state.internal.statusString;

try
    for c=1:10
        mm=mm*-1;
        newPos(1,2) = initPos + mm*1000; % Calcualte New value
        mp285StartMove(newPos);
        mp285FinishMove;
    end
catch

end

newPos(1,2) = initPos;%     mp285StartMove(newPos);
mp285StartMove(newPos);
mp285FinishMove;
mp285SetVelocity(state.motor.velocitySlow)
updateMotorPosition;
setStatusString(oldStatus);

