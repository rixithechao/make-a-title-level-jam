local ep_hud = {}

local hudoverride = require("hudoverride")
hudoverride.visible.keys = true
hudoverride.visible.bombs = true
hudoverride.visible.coins = true
hudoverride.visible.score = false
hudoverride.visible.lives = true
hudoverride.visible.stars = true
hudoverride.visible.starcoins = true
hudoverride.visible.timer = true

mem(0x00B2C5AC,FIELD_FLOAT, 50)

return ep_hud