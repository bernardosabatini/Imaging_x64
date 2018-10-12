function closeChannelGUI
	global state gh

	uicontrol(gh.channelGUI.text4);
	if state.internal.channelChanged
		hideGUI('gh.channelGUI.figure1');
		siSet_channelFlags
        siSet_lutSliders
		siSession_buildInput
        siFigures_resetVisible
		state.internal.channelChanged=0;
	else
		hideGUI('gh.channelGUI.figure1');
		state.internal.channelChanged=0;
	end
	