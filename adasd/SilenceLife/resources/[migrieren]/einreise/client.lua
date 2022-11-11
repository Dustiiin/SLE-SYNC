local isneu = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("isneu") 
AddEventHandler("isneu", function(neu)
    isneu = neu
end)

RegisterNetEvent("flughafentp") 
AddEventHandler("flughafentp", function(einreiseID)
    local ped = PlayerPedId()
    local currentPos = GetEntityCoords(ped)
    SetEntityCoords(ped, -1043.2307128906, -2746.9499511719, 21.358695983887, false, false, false, true)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isneu then
            local ped = PlayerPedId()
                if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.EinreiseX, Config.EinreiseY, Config.EinreiseZ, true) < 250 then
                else
                    SetEntityCoords(ped, Config.EinreiseX, Config.EinreiseY, Config.EinreiseZ, false, false, false, true)
            end
        end
    end
end)


RegisterNetEvent("rein:teleport")
AddEventHandler("rein:teleport", function(coords)
    local x, y, z = table.unpack(coords)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
end)

Citizen.CreateThread(function()
  SetDeepOceanScaler(0.0)
end)
