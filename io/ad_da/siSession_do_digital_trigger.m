function siSession_do_digital_trigger
%siSession_do_digital_trigger Puts out the trigger pulse

    global state 
    disp('Forcing digital trigger')

    if state.imaging.daq.remakeTriggerEachTime
        siSession_make_digital_trigger
    end
    
    global  digTrigger
    outputSingleScan(digTrigger,1)
    outputSingleScan(digTrigger,0)
end

