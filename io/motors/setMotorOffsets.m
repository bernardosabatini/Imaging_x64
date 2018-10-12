function setMotorOffsets
global state gh

% setMotorOffsets.m*****
% Function that will upate the Motor offsets, Relative, and Absolute Positions.


currentPos = MP285GetPos;	% Get current Position

% Set the Offsets
state.motor.offsetX = currentPos(1,1);
state.motor.offsetY = currentPos(1,2);
state.motor.offsetZ = currentPos(1,3);

% Set the relative values
state.motor.relXPosition = state.motor.absXPosition - state.motor.offsetX; 
updateGuiByGlobal('state.motor.relXPosition');
state.motor.relYPosition = state.motor.absYPosition - state.motor.offsetY; 
updateGuiByGlobal('state.motor.relYPosition');
state.motor.relZPosition = state.motor.absZPosition - state.motor.offsetZ;
updateGuiByGlobal('state.motor.relZPosition');

% Set the absolute Positions
state.motor.absXPosition = currentPos(1,1);
updateGuiByGlobal('state.motor.absXPosition');
state.motor.absYPosition = currentPos(1,2);
updateGuiByGlobal('state.motor.absYPosition');
state.motor.absZPosition = currentPos(1,3);
updateGuiByGlobal('state.motor.absZPosition');