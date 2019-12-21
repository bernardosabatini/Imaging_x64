function [ output_args ] = siSession_setup( force )
%siSessions_setup Setup the input and output sessions
%   Surveys what changes are necessary for the DAQs and applied them
%   Bernardo Sabatini Nov 2014

    if nargin<1
        force=0;
    end

    global state

    % Let's recalculate the output waveforms and input parameters


    % Do we need to delete and rebuild the input data acquisition session?
    % This would happen if the number of input channels has changed via the
    % Channels gui or due to user action

    if state.imaging.daq.needNewInputSession || force
        siSession_buildInput
    end

    % Do we need to delete and rebuild the output data acquisition session?
    % This would happend if the number of output channels has changed and is
    % very unlikely

    if state.imaging.daq.needNewOutputSession || force
        siSession_buildOutput
    end

    % Let's set the total scans to output or acquire in each device
    siSession_allocateMemory
end

