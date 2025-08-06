local npcManager = require("npcManager")
local sampleNPC = {}
local npcID = NPC_ID;

function sampleNPC.onInitAPI()
	npcManager.registerEvent(npcID, sampleNPC, "onTickNPC")
	sapleNPC.deathEventName = "Rebark"
	NPC.spawn(564,player.x,player.y-73)
end

function onTick()
	v.deathEventName = "Rebark"
	sapleNPC.deathEventName = "Rebark"
	NPC.spawn(564,player.x,player.y-73)
	
end