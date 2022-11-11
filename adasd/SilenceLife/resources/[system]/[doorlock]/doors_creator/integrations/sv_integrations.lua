-- You can edit the events on the right side if you for any reason don't use the default event name

EXTERNAL_EVENTS_NAMES = {
    ["esx:getSharedObject"] = nil, -- This is nil because it will be found automatically, change it to your one ONLY in the case it can't be found    
}

-- Use ox_inventory? (Used to replace ESX.Items table)
USE_OX_INVENTORY = false

-- The function must return true if the player's job and job grade are correct and in allowedJobs table
function hasPlayerTheCorrectJob(playerId, allowedJobs)
    if(not allowedJobs) then
        allowedJobs = {}
    end
    
    local playerJobName = Framework.getPlayerJobName(playerId)

    if(allowedJobs[playerJobName]) then
        local playerGrade = Framework.getPlayerJobGrade(playerId)

        if(not allowedJobs[playerJobName][tostring(playerGrade)]) then
            return false
        else
            return true
        end
    else
        return false
    end
end

-- The function must return true if the player has the required item
function hasPlayerTheRequiredItem(playerId, itemName)
    return Framework.hasPlayerEnoughOfItem(playerId, itemName, 1)
end