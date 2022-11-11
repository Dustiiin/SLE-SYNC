--[[
    If you have a different script name for the following ones, change it to your one
    Example:

    EXTERNAL_SCRIPTS_NAMES = {
        ["es_extended"] = "mygamemode_extended",
        ["esx_addonaccount"] = "mygamemode_addonaccount"
    }
]]

EXTERNAL_SCRIPTS_NAMES = {
    ["es_extended"] = "es_extended",
    ["esx_addonaccount"] = "esx_addonaccount",

    -- If you don't use this inventory don't touch
    ["ox_inventory"] = "ox_inventory",

    ["qb-core"] = "qb-core",
    ["qb-clothing"] = "qb-clothing",
    ["qb-weapons"] = "qb-weapons",
    ["qb-bossmenu"] = "qb-bossmenu",
    ["qb-management"] = "qb-management"
}

--[[
    Change it to a plate you want to automatically create random plates the way you prefer

    Examples of random plates with EXAMPLE_PLATE = "CX521YD"
        - XC111EW
        - SI849TW
        - YS364KD
    
    Examples of random plates with EXAMPLE_PLATE = "CBZ 629"
        - EGP 015
        - VHS 687
        - SXN 296


    Examples of random plates with EXAMPLE_PLATE = "72 QT 15"
        - 63 VD 85
        - 27 AC 66
        - 63 HR 75
]]
EXAMPLE_PLATE = "AB123CD"

--[[
    Available options: default, qs-inventory, ox-inventory      (they MUST be between double quotes "")
    If your inventory isn't listed, you'll have to integrate your own by using the script documentation
]]
INVENTORY_TO_USE = "default"