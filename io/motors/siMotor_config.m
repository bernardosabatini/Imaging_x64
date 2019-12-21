function [outputArg1,outputArg2] = siMotor_config
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    global state
    if state.motor.useKinesis
        state.motor.kinesis=ThorlabsLabJack(state.motor.kinesisSerialNum);
    end
    if state.motor.motorOn % need to rephrase as has285
        mp285Config;
    end
end

