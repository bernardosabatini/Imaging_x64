function [ output_args ] = siSession_setup( input_args )
%siSessions_setup Setup the input and output sessions
%   Surveys what changes are necessary for the DAQs and applied them
%   Bernardo Sabatini Nov 2014

    global state

    % Let's recalculate the output waveforms and input parameters


    % Do we need to delete and rebuild the input data acquisition session?
    % This would happen if the number of input channels has changed via the
    % Channels gui or due to user action

    if state.imaging.daq.needNewInputSession
        siSession_buildInput
    end

    % Do we need to delete and rebuild the output data acquisition session?
    % This would happend if the number of output channels has changed and is
    % very unlikely

    if state.imaging.daq.needNewOutputSession
        siSession_buildOutput
    end

    % Do we need to delete and rebuild the auxilliary output data acquisition
    % session?  This happens quite often if it is being shared with another
    % package such as physiology but otherwise rarely

    if state.pcell.pcellOn && state.imaging.daq.needNewAuxOutputSession
        siSession_buildAuxOutput
    end


    % Let's set the total scans to output or acquire in each device
    siSession_allocateMemory

end

