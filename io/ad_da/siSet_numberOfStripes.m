function siSet_numberOfStripes 
% Function that selects the number of stripes appropriate for the given image size.
global state

% This function sets the state.acq.numberOfStripes parameter to the appropriate value,
% depending on whether the lines per frame is small or large.
%
% Written By: Bernardo Sabatini

allF=allFactors(state.acq.linesPerFrame);

maxStripes=round((state.acq.msPerLine*state.acq.linesPerFrame/60)); %update at most every 60 ms
% scale by number of active channels???  %/state.internal.numberOfActiveChannels);

validI=find(allF<=maxStripes);

state.internal.oldNumberOfStripes=state.internal.numberOfStripes;
state.internal.numberOfStripes=allF(validI(end));
state.internal.numberOfStripes=16;
state.internal.linesPerStripe=state.acq.linesPerFrame/state.internal.numberOfStripes;


	