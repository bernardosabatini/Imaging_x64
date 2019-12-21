function siSession_make_digital_trigger
%siSession_make_digital_trigger Makes the session for the diggital trigger

    global state digTrigger
    evalin('base', 'global digTrigger');

    if ~isempty(digTrigger)
        delete(digTrigger);
    end
    digTrigger=daq.createSession('ni');
    addDigitalChannel(digTrigger, ...
        state.imaging.daq.triggerBoard, ...
        state.imaging.daq.triggerLine, ...
        'OutputOnly');

