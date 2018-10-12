function timerInitGUI_Imaging
    global gh state

    gh.imageGUI = guihandles(imageGUI);
    gh.channelGUI = guihandles(channelGUI);
    gh.basicConfigurationGUI=guihandles(basicConfigurationGUI);
    gh.motorGUI =guihandles(motorGUI);
    gh.siGUI_ImagingControls=guihandles(siGUI_ImagingControls);
    gh.pcellControl = guihandles(pcellControl);
    gh.fieldAdjustGUI = guihandles(fieldAdjustGUI);

    set(gh.fieldAdjustGUI.scanRotationSlider, 'SliderStep', [5/360 15/360]);	% 5 degree changes for slider
    
	openini('imaging.ini');
    
    state.cycle.functionNameList={''};
    state.timer.triggerPackage='Imaging'; % take control of the trigger