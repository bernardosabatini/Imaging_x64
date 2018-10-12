function siSet_acquisitionParameters
global state 

% setAcquisitionParameter.m****
% Function that sets the samplesAcquiredPerLine and inputRate when the user sets the 
% Fill fraction and the msPerLine.

siSet_lineParameters
siSet_numberOfStripes

if state.acq.dualLaserMode==1 % if the lasers are on simulataneously then nothing special
	state.internal.extraSampleFactor=1;
elseif state.acq.dualLaserMode==2
	state.internal.extraSampleFactor=2;	% if they are alternating, then double the number of acqs before trigger the trigger function
end

% state.internal.samplesUsedPerLine is set in siSet_LineParameters
state.internal.samplesPerLine=state.acq.msPerLine*state.acq.inputRate/1000;
state.internal.linesPerStripe=state.acq.linesPerFrame/state.internal.numberOfStripes;
state.internal.samplesPerStripe = state.internal.extraSampleFactor...
    *state.internal.samplesPerLine*state.internal.linesPerStripe;
state.internal.samplesPerFrame=state.internal.extraSampleFactor...
    *state.internal.samplesPerLine*state.acq.linesPerFrame;

if state.internal.trimImageEdges
	state.acq.binFactor=state.acq.samplesUsedPerLine/state.acq.pixelsPerLine;
	state.acq.pixelTime=state.acq.msPerLine*state.acq.fillFraction/state.acq.pixelsPerLine;
	if state.acq.bidi
		state.internal.startDataColumnInLine = ...
			1+round(...
			state.internal.samplesPerLine*...
			((1-state.acq.fillFraction)/2+...			
			(state.acq.lineDelay/2+state.acq.mirrorLag)/state.acq.msPerLine));
		state.internal.endDataColumnInLine = state.internal.startDataColumnInLine...
			+ state.acq.pixelsPerLine*state.acq.binFactor-1;	
	else
		state.internal.startDataColumnInLine = ...
			1+round((state.acq.lineDelay+state.acq.mirrorLag)/state.acq.msPerLine*state.internal.samplesPerLine);
		state.internal.endDataColumnInLine = state.internal.startDataColumnInLine ....
			+ state.acq.pixelsPerLine*state.acq.binFactor-1;	
	end
else
	state.acq.binFactor=state.internal.samplesPerLine/state.acq.pixelsPerLine;
	state.acq.pixelTime=state.acq.msPerLine/state.acq.pixelsPerLine;
	state.internal.startDataColumnInLine = 1;
	state.internal.endDataColumnInLine = state.internal.samplesPerLine;	
end

state.internal.fractionStart = state.internal.startDataColumnInLine/state.internal.samplesPerLine;
state.internal.fractionEnd = state.internal.endDataColumnInLine/state.internal.samplesPerLine;
state.internal.fractionPerPixel=(state.internal.fractionEnd - state.internal.fractionStart)/state.acq.pixelsPerLine;

updateGuiByGlobal('state.internal.startDataColumnInLine');
updateGuiByGlobal('state.internal.endDataColumnInLine');
updateGuiByGlobal('state.acq.binFactor');
updateGuiByGlobal('state.acq.pixelTime');




