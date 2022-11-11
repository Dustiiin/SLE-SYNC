local deadPlayers = {}


RegisterNetEvent('ds_death:revive')
AddEventHandler('ds_death:revive', function(playerId)
    playerId = tonumber(playerId)
        local xPlayer = source and ESX.GetPlayerFromID(source)

        if xPlayer and xPlayer.job.name == 'ambulance' then
            local xTarget = ESX.GetPlayerFromID(playerId)

            if xTarget then
                if deadPlayers[playerId] then
                    xPlayer.showNotification('Revive Complete '..xTarget.name..)
                    xTarget.triggerEvent('ds_death:revive')
                else
                    xPlayer.showNotification('Hier gibt es keinen Verletzten')
                end
            else
                xPlayer.showNotification("Spieler nicht online")
            end
        end
end)


RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	deadPlayers[source] = 'dead'
end)


ESX.RegisterCommand('revive', {'leitung'}, function(xPlayer, args, showError)
    args.playerId.triggerEvent('ds_death:revive')
end, true, {'Error'})



ESX.RegisterServerCallback('ds_death:getDeathStatus', function(source, cb)
    local xPlayer = ESX.GetPlayerFromID(source)
    MySQL.scalar('SELECT is_dead FROM users WHERE identifier = ?', {xPlayer.identifier}, function(isDead)
        local isDead = isDead
        if type(isDead) == 'boolean' then
            isDead = isDead == 1 and true or false
        end

        cb(isDead)
    end)
end)


RegisterNetEvent('ds_death:setDeathStatus')
AddEventHandler('ds_death:setDeathStatus', function(isDead)
    local xPlayer = ESX.GetPlayerFromID(source)

    if type(iseDead) == "boolean" then
        MySQL.update('UPDATE users SET is_dead = ? WHERE identifier = ?', (isDead, xPlayer.identifier))
    end
end)


