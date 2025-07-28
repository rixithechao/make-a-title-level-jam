local leveldata = require("scripts/matl_leveldata")

local textplus = require("textplus")
local hudoverride = require("hudoverride")
hudoverride.visible.coins = false
hudoverride.visible.lives = false



-- Randomize the level order per save file
local unmapped = table.unmap(leveldata)

if  SaveData._hub == nil  or  SaveData._hub.countCache ~= #unmapped  then
    SaveData._hub = {
        levelOrder = table.ishuffle(unmapped),
        countCache = #unmapped
    }
end

local orderedLevels = SaveData._hub.levelOrder


function onStart()

    player.setCostume(CHARACTER_MARIO, "A2XT-Demo", true)
    player.setCostume(CHARACTER_LUIGI, "A2XT-Iris", true)
    player.setCostume(CHARACTER_PEACH, "A2XT-Kood", true)
    player.setCostume(CHARACTER_TOAD, "A2XT-Raocow", true)
    player.setCostume(CHARACTER_LINK, "A2XT-Sheath", true)

    
    -- Set up the level entrances
    local boundary = Section(0).boundary
    local sectionCenter = vector((boundary.left+boundary.right)*0.5, (boundary.top+boundary.bottom)*0.5)
    local sectionSize = vector(boundary.right-boundary.left, boundary.bottom-boundary.top)
    local warps = Warp.get()

    for  i=1, #orderedLevels  do
        local percent = (i-1)/#orderedLevels
        local degrees = math.rad(360*percent)
        local pos = sectionCenter + vector(sectionSize.x*0.42*math.sin(degrees), sectionSize.y*0.41*math.cos(degrees))

        local thisWarp = warps[i]
        thisWarp.entranceX = pos.x-24
        thisWarp.entranceY = pos.y-24
        thisWarp.exitX = pos.x-24
        thisWarp.exitY = pos.y-24
        thisWarp.entranceWidth = 48
        thisWarp.entranceHeight = 48
        thisWarp.exitWidth = 48
        thisWarp.exitHeight = 48
        thisWarp.warpType = 2
        thisWarp.levelFilename = orderedLevels[i]

        local glow = NPC.spawn(668, pos.x, pos.y, player.section, true, true)
        glow.data._settings.brightness = 3
    end

    -- Hide the rest outside of the section
    for  i=#orderedLevels+1, #warps  do
        local thisWarp = warps[i]
        thisWarp.entranceX = boundary.right + 64
        thisWarp.exitX = boundary.right + 64
    end
end


function onTick()
    
    -- Player controls
    if  player:isUnderwater()  then
        Defines.player_grav = 0
        player.speedY = 0.95*player.speedY

        local moveSpeed = Defines.player_walkspeed*0.5
        if  player.keys.run == KEYS_DOWN  then
            moveSpeed = Defines.player_runspeed*0.5
        end

        player.keys.jump = KEYS_UP
        player.keys.altJump = KEYS_UP
        player.keys.up = KEYS_UP
        player.keys.down = KEYS_UP

        if  player:mem(0x11C, FIELD_WORD) <= 0  then
            if  player.rawKeys.up == KEYS_DOWN  then
                player.speedY = math.clamp(player.speedY-0.25, -moveSpeed, moveSpeed)
            end
            if  player.rawKeys.down == KEYS_DOWN  then
                player.speedY = math.clamp(player.speedY+0.25, -moveSpeed, moveSpeed)
            end
        end

        --[[
        if  player.rawKeys.jump == KEYS_PRESSED  then
            SFX.play(72)
            if  player.keys.down == KEYS_DOWN  then
                player.speedY = 24
            else
                player.speedY = -24
            end
        end
        --]]
    else
        Defines.player_grav = 0.4
    end

    -- Warp stuff
    local intersectingWarp = player:mem(0x5A,FIELD_WORD)
    if  intersectingWarp ~= nil  and  intersectingWarp > 0  then
        
        local thisLevelData = leveldata[orderedLevels[intersectingWarp]]
        
        local textPos = vector(400, 150)
        if  player.y + player.height - 32 < camera.y + 300  then
            textPos.y = 450
        end
        local fullTitle = ""
        if  thisLevelData.fullTitle  then
            fullTitle = "<br><br>"..thisLevelData.fullTitle
        end
        
        textplus.print{
            x = textPos.x,
            y = textPos.y,
            text = "<align center>"..thisLevelData.title.."<br>"..thisLevelData.author..fullTitle.."</align>",
            pivot = vector(0.5,0.5),

            xscale = 2,
            yscale = 2,
            color = Color.white
        }

        if  player.rawKeys.jump == KEYS_PRESSED  or  player.rawKeys.altJump == KEYS_PRESSED  then
            player.keys.up = KEYS_DOWN
        end
    end

end

function onEvent(eventName)
end

