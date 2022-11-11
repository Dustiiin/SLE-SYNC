EXTERNAL_EVENTS_NAMES = {
    ["esx:getSharedObject"] = nil, -- This is nil because it will be found automatically, change it to your one ONLY in the case it can't be found
    
    ["esx_skin:save"] = "esx_skin:save",

    ["esx_billing:sendBill"] = "esx_billing:sendBill",

    ["jsfour-idcard:open"] = "jsfour-idcard:open",

    ["esx_license:removeLicense"] = "esx_license:removeLicense",
    ["esx_license:addLicense"] = "esx_license:addLicense",

    ["esx_skin:getPlayerSkin"] = "esx_skin:getPlayerSkin"
}



-- If the inventory is not the default one, this will disable default Stash, Safe and Armory
if(INVENTORY_TO_USE ~= "default") then
    RegisterNetEvent(Utils.eventsPrefix .. ":framework:ready", function() 
        exports[Utils.eventsPrefix]:disableScriptEvent(Utils.eventsPrefix .. ":stash:openStash")
        exports[Utils.eventsPrefix]:disableScriptEvent(Utils.eventsPrefix .. ":armory:openArmory")
        exports[Utils.eventsPrefix]:disableScriptEvent(Utils.eventsPrefix .. ":safe:openSafe")
    end)
end