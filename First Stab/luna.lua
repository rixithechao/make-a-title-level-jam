function onEvent(eventName)
    if  eventName == "slain"  then
        Level.endState(LEVEL_END_STATE_SMB3ORB)
    end
end