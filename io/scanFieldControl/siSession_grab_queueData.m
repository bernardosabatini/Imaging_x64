function siSession_grab_queueData

    global state focusOutput pcellFocusOutput

    siSession_release

    %% Determine if physiology is running and if it needs to use some channels on the Aux board
    if state.pcell.pcellOn && ... % we are using a cells
            strcmpi(state.phys.daq.auxOutputBoard, state.pcell.pcellBoard) % and they are the same board
        isPhysUsingAux=...
            isfield(state.cycle, 'physiologyOnList') && ...
            (length(state.cycle.physiologyOnList)>=state.cycle.currentCyclePosition) ...
            && state.cycle.physiologyOnList(state.cycle.currentCyclePosition);
    else
        isPhysUsingAux=0;
    end

    nPcellChannels=2*state.pcell.numberOfPcells;
    neededAuxChannelIDs={};
    
    if isPhysUsingAux % it is the same board.  Are any channels being used?
        pcellChannels=0:(nPcellChannels-1); % these channels are reserved for imaging

        neededAuxChannelIDs={};
        for counter=nPcellChannels:7 % only cycle through the channels that phys is allowed to use
            auxList=state.cycle.(['aux' num2str(counter) 'List']);
            if length(auxList)>=state.cycle.currentCyclePosition && ...
                    auxList(state.cycle.currentCyclePosition)>0
                neededAuxChannelIDs{counter+1}=['ao' num2str(counter)];
            end
        end

        if isempty(neededAuxChannelIDs)
            isPhysUsingAux=0;
        else
            isPhysUsingAux=1;
            for counter=1:nPcellChannels
                neededAuxChannelIDs{counter}=['ao' num2str(pcellChannels(counter))];
            end
        end
    end
    neededAuxChannelIDs=neededAuxChannelIDs';

    %% Handle output for imaging input device and to Aux board if phys does not share it

    % note their is a cludge below which forces output of an entire extra
    % stripe of data because the data acq toolbox is such a mess

    if ~state.pcell.pcellOn % no pcells so no aux board
        zz=zeros(state.internal.samplesPerStripe, size(state.acq.repeatedMirrorData,2));
        focusOutput.queueOutputData([state.acq.repeatedMirrorData' zz']');
    else % yes pcells
        if state.pcell.usingOutputBoard && ~isPhysUsingAux % using same board
            zz=zeros(state.internal.samplesPerStripe, size(state.acq.repeatedMirrorData,2)+ size(state.acq.pcellRepeatedOutput, 2));
            focusOutput.queueOutputData([[state.acq.repeatedMirrorData state.acq.pcellRepeatedOutput]' zz]');
        elseif ~isPhysUsingAux
            % let's check here if there are extra leftover channels that
            % need to be deleted from the output device
            auxOutputChannels=get(pcellFocusOutput, 'Channels');
            if length(auxOutputChannels)>nPcellChannels
                pcellFocusOutput.removeChannel((nPcellChannels+1):length(auxOutputChannels));
            end

            zz=10*ones(state.internal.samplesPerStripe, size(state.acq.repeatedMirrorData,2));
            focusOutput.queueOutputData([state.acq.repeatedMirrorData' zz']');

            zz=zeros(state.internal.samplesPerStripe, size(state.acq.pcellRepeatedOutput,2));
            pcellFocusOutput.queueOutputData([state.acq.pcellRepeatedOutput' zz']');
        end
    end

    %% If physiolgy is sharing the aux board, deal with it here
    if isPhysUsingAux
        auxOutputChannels=get(pcellFocusOutput, 'Channels');
        auxOutputIDs=get(auxOutputChannels, 'ID');

        if ~isequal(neededAuxChannelIDs(1:nPcellChannels), auxOutputIDs(1:nPcellChannels))
            disp('XXXXXX Something is very wrong in siSession_grab_queueData')
            return
        end

        if isequal(neededAuxChannelIDs, auxOutputIDs) % great!  all the right channels are set
            disp('all perfect')
        else
            firstWrong=0;
            for counter=(nPcellChannels+1):length(auxOutputIDs)
                if counter<=length(neededAuxChannelIDs) ... % there are channels
                        && strcmpi(auxOutputIDs(counter), neededAuxChannelIDs(counter)) % and it is the right one
                else
                    if firstWrong==0
                        firstWrong=counter;
                        disp(['wrong at ' num2str(counter)]);
                    end
                end
            end

            if firstWrong>0
                pcellFocusOutput.removeChannel(firstWrong:length(auxOutputChannels));
                disp(['deleting channels ' auxOutputChannels(firstWrong:end)]);
                auxOutputChannels=get(pcellFocusOutput, 'Channels');
                auxOutputIDs=get(auxOutputChannels, 'ID');
            else
                disp('no channels to delete');
            end

            if length(auxOutputIDs)<length(neededAuxChannelIDs) % there are channels missing
                for counter=(length(auxOutputIDs)+1):length(neededAuxChannelIDs)
                    chanAdded=pcellFocusOutput.addAnalogOutputChannel(...
                        state.pcell.pcellBoard, ...
                        neededAuxChannelIDs(counter),...
                        'Voltage'...
                        );
                    chanAdded.Range=[-10 10];
                end
            end
        end

        %% Now actually put the data out there

        % the XY mirrors are just are normal (with the cludge of extra points)

        zz=10*ones(state.internal.samplesPerStripe, size(state.acq.repeatedMirrorData,2));
        focusOutput.queueOutputData([state.acq.repeatedMirrorData' zz']');

        % the aux board
        nExtraChannels=length(neededAuxChannelIDs)-nPcellChannels;
        if nExtraChannels==0 % no extra channels
            zz=zeros(state.internal.samplesPerStripe, size(state.acq.pcellRepeatedOutput,2));
            pcellFocusOutput.queueOutputData([state.acq.pcellRepeatedOutput' zz']');
        else
            nPoints=size(state.acq.pcellRepeatedOutput, 1);
            nPointsBuffered=nPoints+state.internal.samplesPerStripe;

            state.phys.daq.auxOutput=zeros(nPointsBuffered, nExtraChannels);

            sRate=pcellFocusOutput.Rate;
            for counter=(nPcellChannels+1):length(neededAuxChannelIDs)
          %      patternNum=state.phys.internal.lastAuxPulsesUsed(counter-nPcellChannels);
                patternNum=state.cycle.(['aux' num2str(counter-1) 'List'])(state.cycle.currentCyclePosition);
                makePulsePattern(patternNum, 0, sRate);
                outputPattern=state.pulses.(['pulsePattern' num2str(patternNum)]);
                pSize=size(outputPattern, 2);
                if nPointsBuffered > pSize
                    outputPattern=[outputPattern repmat(outputPattern(end), 1, nPointsBuffered-pSize)];
                elseif pSize>nPointsBuffered
                    outputPattern=outputPattern(1:nPointsBuffered);
                end
                state.phys.daq.auxOutput(1:nPointsBuffered, counter-nPcellChannels)=outputPattern';
            end
        end
        zz=zeros(state.internal.samplesPerStripe, size(state.acq.pcellRepeatedOutput,2));
        pcellFocusOutput.queueOutputData([[state.acq.pcellRepeatedOutput' zz']' state.phys.daq.auxOutput]);

    end