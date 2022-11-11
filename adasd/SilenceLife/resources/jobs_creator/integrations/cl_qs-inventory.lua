if(INVENTORY_TO_USE == "qs-inventory") then
    local other = {}
    other.maxweight = 100000 -- Custom weight stash.
    other.slots = 50 -- Custom slots spaces.

    RegisterNetEvent("jobs_creator:stash:openStash", function(markerId)
        local stashId = "job_stash_" .. markerId

        TriggerServerEvent("inventory:server:OpenInventory", "stash", stashId, other)
        TriggerEvent("inventory:client:SetCurrentStash", stashId)
    end)

    RegisterNetEvent("jobs_creator:safe:openSafe", function(markerId)
        local safeId = "job_safe_" .. markerId

        TriggerServerEvent("inventory:server:OpenInventory", "stash", safeId, other)
        TriggerEvent("inventory:client:SetCurrentStash", safeId)
    end)

    RegisterNetEvent("jobs_creator:armory:openArmory", function(markerId)
        local armoryId = "job_armory_" .. markerId

        TriggerServerEvent("inventory:server:OpenInventory", "stash", armoryId, other)
        TriggerEvent("inventory:client:SetCurrentStash", armoryId)
    end)

    RegisterNetEvent("jobs_creator:framework:ready", function() 
        -- Disables the default script search (otherwise there would be 2 searches)
        exports["jobs_creator"]:disableScriptEvent("jobs_creator:actions:search:searchPlayer")
    end)
    
    RegisterNetEvent("jobs_creator:actions:search:searchPlayer", function(targetServerId)
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetServerId)
    end)
end