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
        if state.internal.configurationMajorChange
            siSession_setup(1); % force flag set to 1
            state.internal.configurationMajorChange=0;
        end
        siSet_acquisitionParameters
        siSession_prepareOutput(1)
        siSession_set_mode('focus', 1)
        siSession_allocateMemory
    
        siFigures_make
        siFigures_resetVisible
        siFigures_updateCLim
    end
	state.internal.configurationChanged=0;

	hideGUI('gh.basicConfigurationGUI.figure1');
