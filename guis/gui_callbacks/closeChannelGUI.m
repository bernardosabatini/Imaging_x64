function closeChannelGUI
	global state gh

	uicontrol(gh.channelGUI.text4);
	if state.internal.channelChanged
		hideGUI('gh.channelGUI.figure1');
		siSet_channelFlags
        siSet_lutSliders
        siFigures_resetVisible
    	siFigures_updateCLim
		siSession_buildInput

		state.internal.channelChanged=0;
	else
		hideGUI('gh.channelGUI.figure1');
		state.internal.channelChanged=0;
	end
	