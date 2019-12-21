function siFigures_updateReferenceImage
    global state imageData

    if isempty(state.internal.refImage) || isempty(state.internal.refFigure)
        return
    end

    blastRadius=0.5; %radius of circle in microns to represent blast location...

    if ~ishandle(state.internal.refImage) || ~ishandle(state.internal.refFigure)
        return
    end
    if ~strcmp('on', get(state.internal.refFigure, 'Visible'))
        return
    end


    startImage=	zeros(state.acq.linesPerFrame, state.acq.pixelsPerLine, 3);
    if all(size(state.acq.trackerReferenceAll)==[state.acq.linesPerFrame state.acq.pixelsPerLine])
        startImage(:,:,1) = ...
            min(max(...
            (state.acq.trackerReferenceAll - ...
            getfield(state.internal, ['lowPixelValue' num2str(state.acq.trackerChannel)])) / ...
            max(...
            getfield(state.internal, ['highPixelValue' num2str(state.acq.trackerChannel)]) ...
            -getfield(state.internal, ['lowPixelValue' num2str(state.acq.trackerChannel)])...
            ,1)...
            ,0)...
            ,1);
    end

    im=mean(imageData{state.acq.trackerChannel},3);
    if all(size(im)==[state.acq.linesPerFrame state.acq.pixelsPerLine])
        startImage(:,:,2) = ...
            min(max(...
            (im - ...
            getfield(state.internal, ['lowPixelValue' num2str(state.acq.trackerChannel)])) / ...
            max(...
            getfield(state.internal, ['highPixelValue' num2str(state.acq.trackerChannel)]) ...
            -getfield(state.internal, ['lowPixelValue' num2str(state.acq.trackerChannel)])...
            ,1)...
            ,0)...
            ,1);
    end

    set(state.internal.refImage, 'CData', startImage);

    h=[state.internal.refPoints(ishandle(state.internal.refPoints)) state.internal.refText(ishandle(state.internal.refText))];
    if ~isempty(h)
        delete(h);
        state.internal.refPoints=[];
        state.internal.refText=[];
    end

    if 1 %state.blaster.active
        if state.blaster.screenCoord

            for counter=1:length(state.blaster.indexList)
                if state.blaster.active && any(counter==state.blaster.allConfigs{state.blaster.currentConfig, 2}(:,1))
                    color='cyan';
                else
                    color='black';
                end

                ppm=10;  %approximate for 256x256, 20x zoom....

                NOP=100;
                radius=blastRadius*ppm; %ppm=pixels per micron
                THETA=linspace(0,2*pi,NOP);
                RHO=ones(1,NOP)*radius;
                [X,Y] = pol2cart(THETA,RHO);
                X=X+state.blaster.indexXList(counter);
                Y=Y+state.blaster.indexYList(counter);
                %  					state.internal.refPoints(counter)=line(state.blaster.indexXList(counter), state.blaster.indexYList(counter), ...
                % 						'Parent', state.internal.refAxis, 'LineWidth', 2.5);
                state.internal.refPoints(counter)=line(X, Y, ... % for now I'm not drawing the center of the circle until I can figure out...
                    'Parent', state.internal.refAxis);  % to get the circles updated as I change the blaster positions...

                %modified- end

                state.internal.refText(counter) = text(state.blaster.indexXList(counter)+6, state.blaster.indexYList(counter)+6, num2str(counter), ...
                    'Parent', state.internal.refAxis, 'color', 'blue');
            end
        else	% using absolute coordinates
            disp('siFigures_updateReferenceImage : needs code to draw in absolute coordinates');
        end
    end


    if state.analysis.analysisMode==2 || (state.analysis.analysisMode==4 && state.acq.lineScan)
        if state.acq.lineScan && (size(state.analysis.roiDefs,1) >= state.analysis.numberOfROI)
            colorList='brkgmcykkkkkkkkkk';
            for roiCounter=1:state.analysis.numberOfROI
                state.internal.refPoints(end+1)=line(state.analysis.roiDefs(roiCounter, 1:2), ...
                    [round(state.acq.linesPerFrame/2) round(state.acq.linesPerFrame/2)], ...
                    'Parent', state.internal.refAxis, 'LineWidth', 2.5, 'color', colorList(roiCounter));
            end
        end
    elseif state.analysis.analysisMode==3 || (state.analysis.analysisMode==4 && ~state.acq.lineScan)
        if ~state.acq.lineScan && (size(state.analysis.roiDefs2D,1) >= state.analysis.numberOfROI)
            colorList='brkgmcykkkkkkkkkk';
            for roiCounter=1:state.analysis.numberOfROI
                state.internal.refPoints(end+1)=line(...
                    [state.analysis.roiDefs2D(roiCounter, 1) state.analysis.roiDefs2D(roiCounter, 1:2) state.analysis.roiDefs2D(roiCounter, 2:-1:1)], ...
                    [state.analysis.roiDefs2D(roiCounter, 3:4) state.analysis.roiDefs2D(roiCounter, 4:-1:3) state.analysis.roiDefs2D(roiCounter, 3)], ...
                    'Parent', state.internal.refAxis, 'LineWidth', 2.5, 'color', colorList(roiCounter));
            end
        end
    end
