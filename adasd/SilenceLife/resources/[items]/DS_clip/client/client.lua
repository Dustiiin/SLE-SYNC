ESX          = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('dsclip:use')
AddEventHandler('dsclip:use', function()
  local ped = GetPlayerPed(-1)
  if IsPedArmed(ped, 4) then
    local hash = GetSelectedPedWeapon(ped)
    if hash~=nil then
      Citizen.CreateThread(function()
      TriggerServerEvent('dsclip:remove')
      AddAmmoToPed(ped, hash, 30)
      end)


)