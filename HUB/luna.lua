local leveldata = EPISODE_LIB.leveldata--require("scripts/episode/leveldata")

local textplus = require("textplus")
local hudoverride = require("hudoverride")
hudoverride.visible.coins = false
hudoverride.visible.lives = false


-- Combined map of regular and special levels
local allLevels = table.clone(leveldata.regular)


-- Randomize the level order per save file
local unmappedRegulars = table.unmap(leveldata.regular)

if  SaveData._hub == nil  or  SaveData._hub.countCache ~= #unmappedRegulars  then
    SaveData._hub = {
        levelOrder = table.ishuffle(unmappedRegulars),
        countCache = #unmappedRegulars
    }
end

-- Ordered lists of level filenames
local levelOrder = {
    regular = table.iclone(SaveData._hub.levelOrder),
    special = {}
}
for  k,v in ipairs(leveldata.special)  do
    levelOrder.special[k] = v.filename
    allLevels[v.filename] = v
end
levelOrder.all = table.append(levelOrder.regular, levelOrder.special)


local lastLevelData

local showFinale = true

local entranceFade = 0



local function setUpEntrance(args)
    local thisWarp = args.warp
    local pos = args.position

    thisWarp.entranceX = pos.x-24
    thisWarp.entranceY = pos.y-24
    thisWarp.exitX = pos.x-24
    thisWarp.exitY = pos.y-24
    thisWarp.entranceWidth = 48
    thisWarp.entranceHeight = 48
    thisWarp.exitWidth = 48
    thisWarp.exitHeight = 48
    thisWarp.warpType = 2
    thisWarp.levelFilename = args.level


    local completion = EPISODE_LIB.completion.Get(args.level)

    local sparkle = NPC.spawn(673, pos.x, pos.y, player.section, true, true)
    local glow = NPC.spawn(668, pos.x, pos.y, player.section, true, true)
    if  completion.cleared  then
        sparkle.data._settings.particle = "p_entrance_cleared.ini"
        glow.data._settings.brightness = 2
        glow.data._settings.color = Color(0,0.5,1,1)
    else
        sparkle.data._settings.particle = "p_entrance.ini"
        glow.data._settings.brightness = 3

        if  args.requiredForFinale  then
            showFinale = false
        end
    end

    local thisLevelData = args.data
    if  thisLevelData  and  thisLevelData.thumbnail ~= nil  then
        thisLevelData.thumbnailImg = Graphics.loadImageResolved("graphics/thumbnails/"..thisLevelData.thumbnail)
    end
end



function onStart()

    player.setCostume(CHARACTER_MARIO, "A2XT-Demo", true)
    player.setCostume(CHARACTER_LUIGI, "A2XT-Iris", true)
    player.setCostume(CHARACTER_PEACH, "A2XT-Kood", true)
    player.setCostume(CHARACTER_TOAD, "A2XT-Raocow", true)
    player.setCostume(CHARACTER_LINK, "A2XT-Sheath", true)

    
    local boundary = Section(0).boundary
    local sectionCenter = vector((boundary.left+boundary.right)*0.5, (boundary.top+boundary.bottom)*0.5)
    local sectionSize = vector(boundary.right-boundary.left, boundary.bottom-boundary.top)
    local warps = Warp.get()

    local specialWarpsOffset = #levelOrder.regular
    local unusedWarpsStart = #levelOrder.regular + #levelOrder.special + 1

    -- Regular level entrances
    for  i=1, #levelOrder.regular  do
        local percent = (i-1)/#levelOrder.regular
        local degrees = math.rad(360*percent)
        local pos = sectionCenter + vector(sectionSize.x*0.42*math.sin(degrees), sectionSize.y*0.41*math.cos(degrees))

        local thisFilename = levelOrder.regular[i]

        setUpEntrance{
            warp = warps[i],
            position = pos,
            level = thisFilename,
            data = leveldata.regular[thisFilename],
            requiredForFinale = true
        }
    end

    
    -- Special level entrances
    local finaleFilename = "finale placeholder name.lvlx"
    local creditsFilename = "credits placeholder name.lvlx"
    local finaleCompletion = EPISODE_LIB.completion.Get(finaleCompletion)

    allLevels[finaleFilename].cond = showFinale
    allLevels[creditsFilename].cond = (finaleCompletion ~= nil  and  finaleCompletion.cleared == true)

    for  i=1, #levelOrder.special  do
        local percent = (i-1)/#levelOrder.special
        local degrees = math.rad(360*percent)
        local pos = sectionCenter + vector(sectionSize.x*0.24*math.sin(degrees), sectionSize.y*0.23*math.cos(degrees))

        local thisWarp = warps[i + specialWarpsOffset]
        local thisFilename = levelOrder.special[i]
        local thisLevelData = allLevels[thisFilename]

        local bgBlock = Block.spawn(21, pos.x-80, pos.y-64)
        bgBlock.width = 160
        bgBlock.height = 128

        if  thisLevelData.cond ~= false  then
            setUpEntrance{
                warp = thisWarp,
                position = pos,
                level = thisFilename,
                data = thisLevelData
            }
        end
    end


    -- Shove the rest of the warps outside of the section
    for  i=unusedWarpsStart, #warps  do
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

        --if  player:isUnderwater()  then --player:mem(0x11C, FIELD_WORD) <= 0  then
        if  player.rawKeys.up == KEYS_DOWN  then
            player.speedY = math.clamp(player.speedY-0.25, -moveSpeed, moveSpeed)
        end
        if  player.rawKeys.down == KEYS_DOWN  then
            player.speedY = math.clamp(player.speedY+0.25, -moveSpeed, moveSpeed)
        end
        --end

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
        
        entranceFade = math.min(1,entranceFade+0.05)
        lastLevelData = allLevels[levelOrder.all[intersectingWarp]]

        if  player.rawKeys.jump == KEYS_PRESSED  or  player.rawKeys.altJump == KEYS_PRESSED  then
            player.keys.up = KEYS_DOWN
        end
    else
        entranceFade = math.max(0, entranceFade-0.05)
    end

end

function onDraw()
    if  lastLevelData ~= nil  then

        local textPos = vector(400, 150)
        if  player.y + player.height - 32 < camera.y + 300  then
            textPos.y = 450
        end
        local fullTitle = ""
        if  lastLevelData.fullTitle  then
            fullTitle = "<br><br>"..lastLevelData.fullTitle
        end

        local author = ""
        if  lastLevelData.author  then
            author = "<br>"..lastLevelData.author
        end

        if  lastLevelData.thumbnailImg  then
            local fadeColor = Color.white * 0.67 * entranceFade

            Graphics.drawScreen{
                texture = lastLevelData.thumbnailImg,
                color = fadeColor,
                priority = -64
            }
        end

        textplus.print{
            x = textPos.x,
            y = textPos.y,
            text = "<align center>"..lastLevelData.title..author..fullTitle.."</align>",
            pivot = vector(0.5,0.5),

            xscale = 2,
            yscale = 2,
            color = Color.white * entranceFade
        }
    end

end

