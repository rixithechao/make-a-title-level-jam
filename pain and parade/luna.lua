--------------------------------------------------
-- Level code
-- Created 0:20 2025-7-26
--------------------------------------------------

-- Run code on level start
function onStart()
    --Your code here
end

-- Run code every frame (~1/65 second)
-- (code will be executed before game logic will be processed)
function onTick()
    --Your code here
end

-- Run code when internal event of the SMBX Engine has been triggered
-- eventName - name of triggered event
function onEvent(eventName)
    --Your code here
end

local autoscroll = require("autoscroll")

function onSectionChange(sectionIdx, playerIdx)
    if  sectionIdx == 1  then
        autoscroll.scrollRight(1)
    end
end