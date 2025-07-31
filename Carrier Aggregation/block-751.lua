local blockmanager = require("blockmanager")
local spawnzones = require("spawnzones")
local blockID = BLOCK_ID

local block = {}

function block.onInitAPI()
    blockmanager.setBlockSettings({
        id = blockID,
        passthrough = true,
        sizable = true
    })

end

spawnzones.block = blockID

return block