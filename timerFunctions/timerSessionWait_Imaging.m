function timerSessionWait_Imaging
    global focusInput focusOutput pcellFocusOutput state
    
    if focusInput.IsContinuous    
        return
    end
    
    if focusInput.IsRunning
    	setStatusString('waiting for input');
        focusInput.wait();
    end
    focusOutput.stop();
   'intput done' 
%     if physOutputSession.IsRunning
%     	setPhysStatusString('waiting for output');
%         physOutputSession.wait;
%     end

    more=1;
    while more
        if focusOutput.IsRunning
            %         physOutputSession.ScansQueued
            setStatusString('waiting for output');
            if focusOutput.ScansQueued==0
                more=0;
                
                focusOutput.stop();
            else
                pause(.01);
            end
        else
            more=0;
        end
    end
    
    if state.pcell.pcellOn && ~state.pcell.usingOutputBoard
        more=1;
        while more
            if pcellFocusOutput.IsRunning
                %         physOutputSession.ScansQueued
                setStatusString('waiting for pcell output');
                if pcellFocusOutput.ScansQueued==0
                    more=0;
                    pcellFocusOutput.stop();
                else
                    pause(.01);
                end
            else
                more=0;
            end
        end    
    end
    'imaging wait done'
    setStatusString('Imaging done');
    siSession_end_acquisition
%    timerRegisterPackageDone('Imaging');

end

