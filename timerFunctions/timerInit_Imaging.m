function timerInit_Imaging(userFile,analysisMode)
    global state
% 	initImaging('', state.analysisMode);	
    
	
	if nargin<2
		userFile='';
		analysisMode=0;
	end
	
	if nargin==1
		if isnumeric(userFile) && ~isempty(userFile)
			analysisMode=userFile;
			userFile='';
		else
			analysisMode=0;
		end
	end
			
	if analysisMode
		h = waitbar(0, 'Starting ScanImage in Analysis Mode...', 'Name', 'ScanImage Analysis Initialization', 'WindowStyle', 'modal', 'Pointer', 'watch');
	else
		h = waitbar(0, 'Starting ScanImage...', 'Name', 'ScanImage Software Initialization', 'WindowStyle', 'modal', 'Pointer', 'watch');
	end
	
	% Open the waitbar for loading
	waitbar(.1,h, 'Reading Initialization File...');

	if analysisMode
		state.analysisMode=1;
		state.motor.motorOn=0;
	else
		state.analysisMode=0;
	end
	
	setStatusString('Initializing...');
	
	global lastAcquiredFrame imageData projectionData
	evalin('base', 'global state gh lastAcquiredFrame projectionData imageData compositeData')
	lastAcquiredFrame=cell(1,10+state.imaging.daq.maximumNumberOfInputChannels);
	imageData=cell(1,10+state.imaging.daq.maximumNumberOfInputChannels);
	projectionData=cell(1,10+state.imaging.daq.maximumNumberOfInputChannels);
	
	initPcellBoxSettingsManager;

	waitbar(.25,h, 'Creating Figures for Imaging');
    siSet_numberOfStripes
    siFigures_make	% config independent...relies only on the .ini file for maxNumberOfChannles.
	
	setStatusString('Initializing...');

    siMotor_config;
    
	global focusInput focusOutput piezoOutput pcellFocusOutput
	evalin('base','global focusInput focusOutput piezoOutput pcellFocusOutput');

	siSet_channelFlags;
    siSet_keepAllSlicesCheckMark
    siSet_acquisitionParameters;

    if ~analysisMode
		waitbar(.4,h, 'Setting Up Data Acquisition Devices...');
		
        siSession_buildOutput
        siSession_buildInput
    end

    if state.piezo.usePiezo
        if state.piezo.useUSBControl
            siPI_start_interface
        else
            siPiezo_initialize
        end
    end
            
    siSession_allocateMemory
    
    siSet_compositeChannels
	siSet_counters
    siSet_lutSliders		
    
    siFigures_resetVisible
	siFigures_updateCLim
    
    initBlaster;
	
	if ~isempty(userFile)
		waitbar(.7,h, 'Reading User Settings...');
		openAndLoadUserSettings(userFile);
	else
		loadConfig;
	end
	
	makeConfigurationMenu;
	if ~analysisMode
		siSession_outputs_to_default
	end
	
	setStatusString('Initializing...');
	
    state.imaging.daq.needNewInputSession=1;
    state.imaging.daq.needNewOutputSession=1;
    state.imaging.daq.needNewAuxOutputSession=1;
    siSession_setup
    
	state.internal.status=0;
	state.cycle.imagingOn=1;
	updateGuiByGlobal('state.cycle.imagingOn');
	state.cycle.imagingOnList(1)=1;

	siSession_prepareOutput(1)
    if state.imaging.daq.imagingForcesDigitalTrigger
        siSession_make_digital_trigger;
    end    
	siShowHidePcellBoxControls
		
    siSession_set_mode('focus');

	waitbar(.9,h, 'Initialization Done');
	
	setStatusString('Ready to use');
	state.initializing=0;
	waitbar(1,h, 'Ready To Use');
	
	if analysisMode
		state.analysisMode=1;
		state.motor.motorOn=0;
        try
            set(get(gh.pcellControl.figure1, 'Children'), 'Enable', 'off');
        catch
        end
            
 		set(get(gh.fieldAdjustGUI.figure1, 'Children'), 'Enable', 'off');

		set(get(gh.motorGUI.figure1, 'Children'), 'Enable', 'off');
		set(gh.siGUI_ImagingControls.focusButton, 'Enable', 'off')
		set(gh.siGUI_ImagingControls.grabOneButton, 'Enable', 'off')
        set(get(gh.basicConfigurationGUI.figure1, 'Children'), 'Enable', 'off')	
 		set(gh.fieldAdjustGUI.figure1, 'Visible', 'off')
 		set(gh.pcellControl.figure1, 'Visible', 'off')
		set(gh.motorGUI.figure1, 'Visible', 'off');
		set(gh.blaster.figure1, 'Visible', 'off');
		set(state.internal.GraphFigure, 'Visible', 'off')
		set(state.internal.MaxFigure, 'Visible', 'off')
		set(state.internal.compositeFigure, 'Visible', 'off')
		set(gh.imageGUI.figure1, 'VIsible', 'off')		
 		initAvgAnalysis;
	else
		state.analysisMode=0;
	end

	close(h);