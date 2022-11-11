EXTERNAL_EVENTS_NAMES = {
    ["esx:getSharedObject"] = nil, -- This is nil because it will be found automatically, change it to your one ONLY in the case it can't be found
}

-- Data for the icon of locked/unlocked door
iconData = {
    [0] = {
        textureDict = "door_icon", -- Do not edit
        textureName = "unlocked", -- Do not edit

        x = 0.03,
        y = 0.04,
        
        color = { -- If all colors are to 255, the image will have the default color
            r = 50,
            g = 255,
            b = 50,
            a = 255,
        },
    },

    [1] = {
        textureDict = "door_icon", -- Do not edit
        textureName = "locked", -- Do not edit

        x = 0.03,
        y = 0.04,
        
        color = { -- If all colors are to 255, the image will have the default color
            r = 255,
            g = 50,
            b = 50,
            a = 255,
        },
    },
}

-- Key control to confirm the selected doors, icon position, etc
CONFIRM_KEY = 201

-- Key to open/close the closest door
KEY_TO_TOGGLE_DOOR_STATUS = 38

-- Lower = faster doors loading but worse performance
-- Higher = slower doors loading but better performance
INTERACTION_POINTS_REFRESH = 1000