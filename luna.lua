EPISODE_LIB = {}
EPISODE_LIB.leveldata = require("scripts/episode/leveldata")
EPISODE_LIB.completion = require("scripts/episode/completion")
EPISODE_LIB.hud = require("scripts/episode/hud")
EPISODE_LIB.message = require("scripts/episode/message")

local playerManager = require("playermanager")
playerManager.overrideCharacterLib(CHARACTER_UNCLEBROADSWORD, require("characters/unclebroadsword"))