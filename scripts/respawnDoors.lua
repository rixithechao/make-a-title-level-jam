local respawnDoors = {}

local respawnRooms = require("respawnRooms")



local warpMap = {}


function respawnDoors.registerIDs(idList)
    local allWarps = Warp.get()

    for  _,v in ipairs(idList)  do
        if  #allWarps >= v  then
            local thisWarp = allWarps[v]
            warpMap[thisWarp] = true
        end
    end
end

function respawnDoors.clearIDs(idList)
    local allWarps = Warp.get()

    for  _,v in ipairs(idList)  do
        if  #allWarps >= v  then
            local thisWarp = allWarps[v]
            warpMap[thisWarp] = nil
        end
    end
end



function respawnDoors.onInitAPI()
    registerEvent(respawnDoors, "onWarpEnter")
end

function respawnDoors.onWarpEnter(eventToken, warpObj, playerObj)
    if  warpMap[warpObj]  then
        eventToken.cancelled = true
        respawnRooms.reset(false)
    end
end



return respawnDoors