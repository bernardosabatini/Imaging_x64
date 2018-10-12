function siSet_grabSamples
    global state grabInput
    
    grabInput.NumberOfScans=state.internal.extraSampleFactor*state.internal.samplesPerFrame*state.acq.numberOfFrames;
 	grabInput.IsContinuous=0;


