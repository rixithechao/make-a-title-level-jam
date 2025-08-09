local npcManager = require("npcManager")
local cam = Camera.get()[1]
local BARF = false

function onTick()
	local doggy = NPC.get(77,player.section)
	local GoodBitch = Layer.get("Da Dog") --forchecking what layer is hidden
	for index,npc in ipairs(doggy) do
		if npc.data.timer == null
			then npc.data.timer = 1
		end
		if npc.despawnTimer == 0
		then
			if GoodBitch.isHidden == false then 
				if npc.data.timer==1 then
				triggerEvent("The Dog Got Away")
				npc.data.timer=0
				end
			end
		end
		if BARF then 
			npc.x=player.x
			npc.y=player.y+player.height-npc.height-2
			npc.noblockcollision = true
			--npc.speedY = 0
		end
		
	end
	
	local SHOOTINGSTAAAARRRS = NPC.get(16,player.section) -- dont despawn the star plz
	for index,npc in ipairs(SHOOTINGSTAAAARRRS) do
	npc:mem(0x12A, FIELD_WORD,180) --doesnt ever despawn please	
	if BARF then
		npc.x=player.x
		npc.y=player.y+player.height-npc.height-2
		npc.noblockcollision = true
		--npc.speedY = 0
	end
		
	end
		
end

function onEvent(eventName)
	if eventName == "Rebark" then 
		NPC.spawn(564,player.x,player.y-73)
	end
	if eventName == "Win"
	then
	BARF = true
	end

	if eventName == "The chase is on" then
		Audio.MusicChange(player.section, "ONaDJTMWaAMCIGVACF/Horse & Dog Race.mp3")
	end
end
