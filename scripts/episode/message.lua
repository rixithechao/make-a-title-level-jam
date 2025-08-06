local ep_message = {}


local littleDialogue = require("scripts/littleDialogue")

-- vanilla SMBX littleDialogue styles
local sharedProps = {
    textXScale = 1,
    textYScale = 1,
    textMaxWidth = 480,

    speakerNameOnTop = false,

    typewriterEnabled = true,

    borderSize = 10,
    useMaxWidthAsBoxWidth = true, -- If true, textMaxWidth gets used as the minimum width for the main part of the box.
    minBoxMainHeight = 0, -- The minimum height for the box's main section.

    openSpeed = 1, -- How much the scale increases per frame while opening/closing.
    pageScrollSpeed = 1,

    showTextWhileOpening = true,

    openStartScaleX = 1,
    openStartScaleY = 1,
    openStartOpacity = 1,

    forcedPosEnabled = true,        -- If true, the box will be forced into a certain screen position, rather than floating over the speaker's head.
    forcedPosX = 400,               -- The X position the box will appear at on screen, if forced positioning is enabled.
    forcedPosY = 150,               -- The Y position the box will appear at on screen, if forced positioning is enabled.
    forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
    forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.

    openSoundEnabled          = true,
    closeSoundEnabled         = false, -- If a sound is played when the box closes.
    scrollSoundEnabled        = true,  -- If a sound is played when the box scrolls between pages.
    moveSelectionSoundEnabled = false, -- If a sound is played when the option selector moves.
    chooseAnswerSoundEnabled  = false, -- If a sound is played when an answer to a question is chosen.
    typewriterSoundEnabled    = false, -- If a sound is played when a letter appears with the typewriter effect.

    -- Image related
    continueArrowEnabled = false, -- Whether or not an image shows up in the bottom right to show that there's another page.
    selectorImageEnabled = false, -- Whether or not an image shows up next to where your chosen answer is.
    scrollArrowEnabled   = false, -- Whether or not arrows show up to indicate that there's more pages of options.
    lineMarkerEnabled    = false, -- Whether or not to have a maker on a new line.

}

littleDialogue.registerStyle("smbx", table.clone(sharedProps))
littleDialogue.registerStyle("smbx-readable", table.clone(sharedProps))
littleDialogue.defaultStyleName = "smbx"


return ep_message