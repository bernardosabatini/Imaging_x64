function siSet_lineParameters
global state 

% setAcquisitionParameter.m****
% Function that sets the samplesAcquiredPerLine and inputRate when the user sets the 
% Fillfractiona dn the msPerLine.

		
switch state.acq.msPerLineGUI % 1 = 1 ms, 2 = 2ms, 3 = 4 ms, 4 = 8 ms
case 1
	state.acq.samplesUsedPerLine = 1024*state.acq.inputRate/1250000;
    updateGuiByGlobal('state.acq.samplesUsedPerLine');
	
	switch state.acq.fillFractionGUI
	case 1 % fillFraction = 0.71234782608696
		state.acq.fillFraction =0.71234782608696;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.1500;
		updateGuiByGlobal('state.acq.msPerLine');

	case 2 % fillFraction =  0.74472727272727
		state.acq.fillFraction = 0.7447272727272720000;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.10;
		updateGuiByGlobal('state.acq.msPerLine');

	case 3 % fillFraction = 0.78019047619048
		state.acq.fillFraction = 0.7801904761904800000;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.0500;
		updateGuiByGlobal('state.acq.msPerLine');

	case 4 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.8192000000000000000;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.0;
		updateGuiByGlobal('state.acq.msPerLine');

	case 5 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.8192000000000000000;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.fillFractionGUI = 4;
		updateGuiByGlobal('state.acq.fillFractionGUI');
		state.acq.msPerLine = 1.0;
		updateGuiByGlobal('state.acq.msPerLine');

	case 6 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.8192000000000000000;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.fillFractionGUI = 4;
		updateGuiByGlobal('state.acq.fillFractionGUI');
		state.acq.msPerLine = 1.0;
		updateGuiByGlobal('state.acq.msPerLine');

	case 7 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.8192000000000000000;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.fillFractionGUI = 4;
		updateGuiByGlobal('state.acq.fillFractionGUI');
		state.acq.msPerLine = 1.0;
		updateGuiByGlobal('state.acq.msPerLine');

		
	otherwise 
	end
	
case 2
	state.acq.samplesUsedPerLine = 2048*state.acq.inputRate/1250000;
    updateGuiByGlobal('state.acq.samplesUsedPerLine');
	
	switch state.acq.fillFractionGUI
	case 1 % fillFraction = 0.71234782608696
		state.acq.fillFraction = 0.71234782608696;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 2.30;
		updateGuiByGlobal('state.acq.msPerLine');

	case 2 % fillFraction =  0.74472727272727
		state.acq.fillFraction = 0.74472727272727;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 2.20;
		updateGuiByGlobal('state.acq.msPerLine');

	case 3 % fillFraction = 0.78019047619048
		state.acq.fillFraction = 0.78019047619048;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 2.10;
		updateGuiByGlobal('state.acq.msPerLine');

	case 4 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.81920000000000;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 2.0;
		updateGuiByGlobal('state.acq.msPerLine');

	case 5 % fillFraction = 0.86231578947368
		state.acq.fillFraction = 0.86231578947368;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.90;
		updateGuiByGlobal('state.acq.msPerLine');

	case 6 % fillFraction = 0.91022222222222
		state.acq.fillFraction = 0.91022222222222;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 1.80;
		updateGuiByGlobal('state.acq.msPerLine');

	case 7  % fillFraction = 0.91022222222222
		state.acq.fillFraction = 0.91022222222222;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.fillFractionGUI = 6;
		updateGuiByGlobal('state.acq.fillFractionGUI');
		state.acq.msPerLine = 1.80;
		updateGuiByGlobal('state.acq.msPerLine');

		
	otherwise 
	end
	
case 3
	setStatusString('');
	state.acq.samplesUsedPerLine = 4096*state.acq.inputRate/1250000;
    updateGuiByGlobal('state.acq.samplesUsedPerLine');
		
	switch state.acq.fillFractionGUI
	case 1 % fillFraction = 0.71234782608696
		state.acq.fillFraction = 0.71234782608696;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 4.60;
		updateGuiByGlobal('state.acq.msPerLine');
	case 2 % fillFraction =  0.74472727272727
		state.acq.fillFraction = 0.74472727272727;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 4.40;
		updateGuiByGlobal('state.acq.msPerLine');
	case 3 % fillFraction = 0.78019047619048
		state.acq.fillFraction = 0.78019047619048;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 4.20;
		updateGuiByGlobal('state.acq.msPerLine');
	case 4 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.81920000000000;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 4.00;
		updateGuiByGlobal('state.acq.msPerLine');
	case 5 % fillFraction = 0.86231578947368
		state.acq.fillFraction = 0.86231578947368;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 3.80;
		updateGuiByGlobal('state.acq.msPerLine');
	case 6 % fillFraction = 0.91022222222222
		state.acq.fillFraction = 0.91022222222222;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 3.60;
		updateGuiByGlobal('state.acq.msPerLine');
	case 7  % fillFraction = 0.96376470588235
		state.acq.fillFraction = 0.96376470588235;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 3.400;
		updateGuiByGlobal('state.acq.msPerLine');
		
	otherwise 
	end
	
case 4
	setStatusString('');
	state.acq.samplesUsedPerLine = 8192*state.acq.inputRate/1250000;
    updateGuiByGlobal('state.acq.samplesUsedPerLine');
	
	switch state.acq.fillFractionGUI
	case 1 % fillFraction = 0.71234782608696
		state.acq.fillFraction = 0.71234782608696;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 9.20;
		updateGuiByGlobal('state.acq.msPerLine');
	case 2 % fillFraction =  0.74472727272727
		state.acq.fillFraction = 0.74472727272727;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 8.80;
		updateGuiByGlobal('state.acq.msPerLine');
	case 3 % fillFraction = 0.78019047619048
		state.acq.fillFraction = 0.78019047619048;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 8.40;
		updateGuiByGlobal('state.acq.msPerLine');
	case 4 % fillFraction = 0.81920000000000
		state.acq.fillFraction = 0.81920000000000;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 8.0;
		updateGuiByGlobal('state.acq.msPerLine');
	case 5 % fillFraction = 0.86231578947368
		state.acq.fillFraction = 0.86231578947368;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 7.60;
		updateGuiByGlobal('state.acq.msPerLine');
	case 6 % fillFraction = 0.91022222222222
		state.acq.fillFraction = 0.91022222222222;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 7.20;
		updateGuiByGlobal('state.acq.msPerLine');
	case 7  % fillFraction = 0.96376470588235
		state.acq.fillFraction = 0.96376470588235;
		updateGuiByGlobal('state.acq.fillFraction');
		state.acq.msPerLine = 6.800;
		updateGuiByGlobal('state.acq.msPerLine');
		
	otherwise 
	end
	
	
otherwise
end



