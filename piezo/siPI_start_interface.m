%% Load PI MATLAB Driver GCS2
%  (if not already loaded)
addpath ( 'C:\Users\Public\PI\PI_MATLAB_Driver_GCS2' ); % If you are still using XP, please look at the manual for the right path to include.

global PIcontroller PIdevice
evalin('base', 'global PIcontroller PIdevice')

if ( ~exist ( 'PIcontroller', 'var' ) || ~isa ( PIcontroller, 'PI_GCS_Controller' ) )
    PIcontroller = PI_GCS_Controller ();
end

%% Start connection
%(if not already connected)

boolPIdeviceConnected = false; 
if ( exist ( 'PIdevice', 'var' ) )
    if ~isempty(PIdevice) && ( PIdevice.IsConnected )
        boolPIdeviceConnected = true; 
    end
end

if ( ~(boolPIdeviceConnected ) )
    PIdevice = PIcontroller.ConnectRS232 ( state.piezo.port, state.piezo.baudRate );
end

% Query controller identification string
connectedControllerName = PIdevice.qIDN()

% initialize PIdevice object for use in MATLAB
PIdevice = PIdevice.InitializeController ();


%% Show connected stages

% query names of all controller axes
availableAxes = PIdevice.qSAI_ALL

% Show for all axes: which stage is connected to which axis
% qCST gets the name of the 
stageName = PIdevice.qCST(state.piezo.axis);
disp(['Axis ' state.piezo.axis ': ' stageName]);


%% Startup Stage

% This sections performs the startup commands valid for most but not all
% PI devices. Depending on you sepcific device you will need to remove some
% commands or add one of the following (list might be incomplete. Please
% look at the manual if necessary):
% - PIdevice.EAX ( axis, true );
% - PIdevice.ATZ ( ... )
% - You may need to interchange the order of FRF and SVO (this is the case for C-891)

axis = state.piezo.axis;

% switch servo on for axis
PIdevice.SVO ( axis, 1);

% reference axis
PIdevice.FRF ( axis );  % find reference



%% Move Stage

% determine the allowed travel range of the stage
state.piezo.min = PIdevice.qTMN ( axis );
state.piezo.max = PIdevice.qTMX ( axis );
disp(['Piezo range ' num2str(state.piezo.min) ' to ' num2str(state.piezo.max) ]);
siPiezo_move_USB(0)

