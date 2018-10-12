function makeNewRotatedMirrorOutput
	global state 

	c = cos(state.acq.scanRotation*pi/180);
	s = sin(state.acq.scanRotation*pi/180);
	cLine = (1-state.acq.lineScan) * cos(state.acq.scanRotation*pi/180);
	sLine = (1-state.acq.lineScan) * sin(state.acq.scanRotation*pi/180);
	
	state.acq.rotatedMirrorData2D = 1/state.acq.zoomFactor * ...
		( c * state.acq.scanAmplitudeX * state.acq.rawSawtoothMirrorOutput(:,1)...
		+ state.acq.scanAmplitudeY * s * state.acq.rawSawtoothMirrorOutput(:,2))...
		+ state.acq.postRotOffsetX ...
		+ state.acq.scanOffsetX;
	state.acq.rotatedMirrorData2D(:,2) = 1/state.acq.zoomFactor * ...
		(state.acq.scanAmplitudeY * c * state.acq.rawSawtoothMirrorOutput(:,2)...
		- s * state.acq.scanAmplitudeX * state.acq.rawSawtoothMirrorOutput(:,1))...
		+ state.acq.postRotOffsetY ...
		+ state.acq.scanOffsetY;

	state.acq.rotatedMirrorData = 1/state.acq.zoomFactor * ...
		( c * state.acq.scanAmplitudeX * state.acq.rawSawtoothMirrorOutput(:,1)...
		+ state.acq.scanAmplitudeY * sLine * state.acq.rawSawtoothMirrorOutput(:,2))...
		+ state.acq.postRotOffsetX ...
		+ state.acq.scanOffsetX;
	state.acq.rotatedMirrorData(:,2) = 1/state.acq.zoomFactor * ...
		(state.acq.scanAmplitudeY * cLine * state.acq.rawSawtoothMirrorOutput(:,2)...
		- s * state.acq.scanAmplitudeX * state.acq.rawSawtoothMirrorOutput(:,1))...
		+ state.acq.postRotOffsetY ...
		+ state.acq.scanOffsetY;

	state.internal.fieldSizeX=floor(state.internal.unitFieldSizeX * state.internal.currentObjective / state.internal.definingObjective ...
		* state.acq.scanAmplitudeX / state.acq.zoomFactor);
	
	state.internal.fieldSizeY=floor(state.internal.unitFieldSizeX * state.internal.currentObjective / state.internal.definingObjective ...
		* state.acq.scanAmplitudeY / state.acq.zoomFactor);

	updateGuiByGlobal('state.internal.fieldSizeX');
	updateGuiByGlobal('state.internal.fieldSizeY');	
	
