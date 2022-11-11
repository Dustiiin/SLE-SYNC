ESX = nil
local IsDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function SetDisplay(bool)
    SendNUIMessage({
        type = "show",
        status = bool,
        time = GlobalState.Timer,
    })

    SendNUIMessage({action = 'starttimer', value = GlobalState.Timer})

    SendNUIMessage({action = 'showbutton'})

	SetNuiFocus(bool, bool)
end

AddEventHandler('esx:onPlayerDeath', function(data)
    SetDisplay(true, true)
    IsDead = true

    -- Respawn Player after timer is done
    Citizen.Wait(GlobalState.Timer * 60 * 1000)

    if IsDead then
        respawn()
    end
end)

AddEventHandler('playerSpawned', function(spawn)
    SetDisplay(false, false)
    IsDead = false
end)

RegisterNUICallback("button", function(data)
    --SendNUIMessage({action = 'hidebutton'})
    SetNuiFocus(false, false)
    local job = 'ambulance'
    TriggerServerEvent('roadphone:sendDispatch', GetPlayerServerId(PlayerId()), 'Du hast einen neuen Notruf erhalten', job, GetEntityCoords(PlayerPedId()), false)
end)

function respawn()
    SetDisplay(false, false)
	SetEntityCoordsNoOffset(PlayerPedId(), GlobalState.RespawnCoords, false, false, false, true)
    NetworkResurrectLocalPlayer(GlobalState.RespawnCoords, GlobalState.RespawnHeading, true, false)
	SetPlayerInvincible(PlayerPedId(), false)
	ClearPedBloodDamage(PlayerPedId())
end
