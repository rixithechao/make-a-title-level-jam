local ep_completion = {}


SaveData.completion = SaveData.completion  or  {}



-- UTILITY FUNCTIONS
local function initLevelSaveData(filename)
    if  filename == nil  then
        filename = Level.filename()
    end
    SaveData.completion[filename] = SaveData.completion[filename]  or  {exits={}}
    return SaveData.completion[filename]
end



-- METHODS
function ep_completion.Get(filename)
    return initLevelSaveData(filename)
end
function ep_completion.MarkBeaten(filename, levelWinType)
    -- Save that the level was cleared
    local thisData = initLevelSaveData(filename)
    thisData.cleared = true
    
    if  levelWinType  then
        thisData.exits[levelWinType] = true
    end
end


-- EVENTS
function ep_completion.onInitAPI()
    if  not isOverworld  then
        registerEvent(ep_completion, "onStart")
        registerEvent(ep_completion, "onExitLevel")
    end
end

function ep_completion.onStart()
    if  not isOverworld  then
        local thisData = initLevelSaveData(Level.filename())
        thisData.visited = true
    end
end

function ep_completion.onExitLevel(levelWinType)
    if  levelWinType ~= LEVEL_WIN_TYPE_NONE  and  levelWinType ~= LEVEL_WIN_TYPE_WARP  then
        ep_completion.MarkBeaten(Level.filename(), levelWinType)
    end
end

return ep_completion