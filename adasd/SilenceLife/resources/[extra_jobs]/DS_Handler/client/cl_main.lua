if Config.Framework == 'ESX' then

Citizen.CreateThread(function()
	while Framework == nil do
		TriggerEvent('esx:getSharedObject', function(obj) 
			Framework = obj 
		end)
		Citizen.Wait(0)
	end
	while Framework.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	SNZ.PlayerData = Framework.GetPlayerData()
	SNZ.Functions.GetPedDataThread()
end)

elseif Config.Framework == 'QBCore' then

Citizen.CreateThread(function()
	Framework = exports['qb-core']:GetSharedObject()
	while Framework.Functions.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	SNZ.PlayerData = Framework.Functions.GetPlayerData()
	SNZ.Functions.GetPedDataThread()
end)

end

RegisterNetEvent(SNZ.HandlerName..':IsTalking')
RegisterNetEvent(SNZ.HandlerName..':IsNotTalking')
RegisterNetEvent(SNZ.HandlerName..':IsUnderWater')
RegisterNetEvent(SNZ.HandlerName..':IsNotUnderWater')
RegisterNetEvent(SNZ.HandlerName..':IsSprinting')
RegisterNetEvent(SNZ.HandlerName..':IsNotSprinting')
RegisterNetEvent(SNZ.HandlerName..':IsOnFoot')
RegisterNetEvent(SNZ.HandlerName..':IsNotOnFoot')
RegisterNetEvent(SNZ.HandlerName..':OnVehicleEnter')
RegisterNetEvent(SNZ.HandlerName..':OnVehicleExit')
RegisterNetEvent(SNZ.HandlerName..':OnVehicleHit')
RegisterNetEvent(SNZ.HandlerName..':HasEnteredZone')
RegisterNetEvent(SNZ.HandlerName..':HasLeftZone')