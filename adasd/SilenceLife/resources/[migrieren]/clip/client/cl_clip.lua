ESX          = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('clip:reload')
AddEventHandler('clip:reload', function()
  ped = GetPlayerPed(-1)
  if IsPedArmed(ped, 4) then
    hash=GetSelectedPedWeapon(ped)
    if hash~=nil then
      TriggerServerEvent('clip:remove')
      AddAmmoToPed(GetPlayerPed(-1), hash,40)
    else
		exports['okokNotify']:Alert("CittyRP", "Du hast keine Waffe in deiner Hand !", 10000, 'warning')
    end
  else
	exports['okokNotify']:Alert("CittyRP", "Du hast keine Waffe in deiner Hand !", 10000, 'warning')
  end
end)