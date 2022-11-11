config = {}

-- How much ofter the player position is updated ?
config.RefreshTime = 100

-- default sound format for interact
config.interact_sound_file = "ogg"

-- is emulator enabled ?
config.interact_sound_enable = false

-- how much close player has to be to the sound before starting updating position ?
config.distanceBeforeUpdatingPos = 40

-- Message list
config.Messages = {
    ["streamer_on"]  = "Streamer Modus ist nun an du kannst nun keine Musik mehr hören.",
    ["streamer_off"] = "Streamer Modus ist nun aus du kannst nun Musik wieder hören.",
    ["no_permission"] = "Du kannst diesen Command nicht nutzen, du hast keine Rechte dafür.",
}

-- Addon list
-- True/False enabled/disabled
config.AddonList = {
    roadphone = true,
}

-- Can hear sometimes music even if you're not around?
-- Try enable this testing feature that might solve the problem.
config.muteMusicTestFeature = false