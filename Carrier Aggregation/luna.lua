local musicPaths = {
    "Carrier Aggregation/04. Dreamy Land.ogg",
    "Carrier Aggregation/mumbo.spc|0;g=1.2;e0",
    "Carrier Aggregation/mp2_wl_nobledemon.ogg",
    "Carrier Aggregation/15 Up 'n' Down.spc|0;g=1.2;e0",
    "Carrier Aggregation/Ska Death.ogg"
}

GameData.carrierAggMusicIdx = ((GameData.carrierAggMusicIdx  or  RNG.randomInt(1,#musicPaths)) % #musicPaths) + 1

function onStart()
    if  Checkpoint.getActiveIndex() == -1  then
        local guardLayer = Layer.get("Checkpoint Guard")
        guardLayer:hide(true)
    end

    Audio.MusicChange(player.section, musicPaths[GameData.carrierAggMusicIdx])
end

function onTick()
    for  k,v in NPC.iterate(601)  do
        v.data._settings.rotSpeed = 0
    end
end

--[[
function onStart()
    for  k,v in ipairs(Liquid.get())  do
        v.isHidden = true
    end
end


function onTick()
    for  k,v in ipairs(Liquid.get())  do
        for  k2,v2 in ipairs(NPC.getIntersecting(v.x,v.y, v.x+v.width, v.y+v.height))  do
            v.underwater = true
            v:mem(0x1C, FIELD_WORD, 2)
        end
    end
end
--]]