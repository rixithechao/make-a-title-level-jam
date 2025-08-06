local npcManager = require("npcManager")
local cam = Camera.get()[1]

function onTick()
	local doggy = NPC.get(564,player.section)
	for index,npc in ipairs(doggy) do
		npc.deathEventName = "Rebark"
		npc.despawnTimer=180
		
	end
		
end

local lastBarkedTick = 0

function onEvent(eventName)
	if eventName == "Rebark" then 
		if  lastBarkedTick < lunatime.tick()-32  then
			lastBarkedTick = lunatime.tick()
			SFX.play(43)
		end
		NPC.spawn(564,player.x,player.y-73)
	end
end
