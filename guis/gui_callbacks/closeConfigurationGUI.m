function closeConfigurationGUI
	global state gh

% Closes the configuration GUI and rebuilds DAQ devices if necesary
%
% Written By: Thomas Pologruto & Bernardo Sabatini
% Cold Spring Harbor Labs
% Harvard Medical School
% HHMI
% 2001-2009


	try
		setStatusString('');
		uicontrol(gh.basicConfigurationGUI.text1);
	catch
	end

	if state.internal.configurationChanged 
		recordWindowPositions;
        siSession_setup(1); % force flag set to 1
        siFigures_resetVisible
    end
	state.internal.configurationChanged=0;

	hideGUI('gh.basicConfigurationGUI.figure1');
