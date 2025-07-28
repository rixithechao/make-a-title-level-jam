local respawnRooms = require("respawnRooms")
respawnRooms.respawnSettings.respawnPowerup = PLAYER_BIG

local hudoverride = require("hudoverride")
hudoverride.visible.keys = false
hudoverride.visible.bombs = false
hudoverride.visible.coins = false
hudoverride.visible.score = false
hudoverride.visible.lives = false
hudoverride.visible.stars = false
hudoverride.visible.starcoins = false
hudoverride.visible.timer = false


local textplus = require("textplus")

local jumpProps = {
    jumpLeft = true,
    flightLeft = 56,

    hasJumped = false,
    hasFlown = false,
    disableText = false,

    textSeconds = 20,

    randOffsets = {vector(0,0),vector(0,0)}
}


-- EVENTS
function onTick()
    hudoverride.visible.itembox = (player.reservePowerup ~= nil  and  player.reservePowerup > 0)

    if  player:isOnGround()  then
        jumpProps.jumpLeft = true
        jumpProps.flightLeft = 56
    
    elseif  player:mem(0x11C, FIELD_WORD) <= 0  then
        if  jumpProps.jumpLeft  and  player.keys.jump == KEYS_PRESSED  then
            jumpProps.hasJumped = true
            SFX.play("sound/extended/leaf.ogg")
            Effect.spawn(10, player.x, player.y+player.height-16)
            jumpProps.jumpLeft = false
            player:mem(0x11C, FIELD_WORD, 16)
            if  player:mem(0x170, FIELD_WORD) > 0  then
                jumpProps.flightLeft = player:mem(0x170, FIELD_WORD)
                player:mem(0x168, FIELD_FLOAT, 0)
                player:mem(0x16E, FIELD_BOOL, false)
                player:mem(0x170, FIELD_WORD, 0)
            end

        elseif  player.keys.altJump == KEYS_UNPRESSED  then
            jumpProps.flightLeft = player:mem(0x170, FIELD_WORD)

        elseif  jumpProps.flightLeft > 0  and  player.keys.altJump == KEYS_PRESSED  then
            jumpProps.hasFlown = true
            SFX.play("sound/extended/birdflap.ogg")
            player:mem(0x168, FIELD_FLOAT, 99)
            player:mem(0x16E, FIELD_BOOL, true)
            player:mem(0x170, FIELD_WORD, jumpProps.flightLeft)
        end
    end

    -- If the player hasn't figured it out by half a minute, tell them
    if  jumpProps.hasFlown  and  jumpProps.hasJumped  and  lunatime.time() < jumpProps.textSeconds  then
        jumpProps.disableText = true
    end


    -- Show the jump frame when flying
    if  player:mem(0x16E, FIELD_BOOL) == true  and  not player.isDucking  then
        player:playAnim({4}, 1, false, 1)
    end
end

function onDraw()

    if  not jumpProps.disableText  and  lunatime.time() >= jumpProps.textSeconds  then
        local fadePercent = math.clamp(lunatime.time()-jumpProps.textSeconds, 0,3)/3
        local oscillatePercent = 0.5 + 0.5*math.sin(math.rad(lunatime.tick()))
        
        if  lunatime.tick() % 10 == 0  then
            jumpProps.randOffsets[1].x = RNG.random(-2,2)
            jumpProps.randOffsets[1].y = RNG.random(-2,2)
            jumpProps.randOffsets[2].x = RNG.random(-3,3)
            jumpProps.randOffsets[2].y = RNG.random(-3,3)
        end

        for  i=0,2  do
            local pos = vector(-199600+16, camera.y + 550)
            if  i ~= 0  then
                pos = pos + jumpProps.randOffsets[i]
            end

            textplus.print{
                x = pos.x,
                y = pos.y,
                text = "<align center>IN AIR<br>JUMP: Double jump                                 ALT JUMP: Fly         </align>",
                pivot = vector(0.5,0.5),
                sceneCoords = true,

                xscale = 2,
                yscale = 2,
                color = Color.cyan * (math.lerp(0.2,0.5, oscillatePercent) - 0.2*i) * fadePercent
            }
        end
    end
end

