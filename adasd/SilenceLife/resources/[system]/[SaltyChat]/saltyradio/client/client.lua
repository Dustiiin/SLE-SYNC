

ESX = nil
PlayerData                = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

  PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


local radioMenu = false

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "system", { 255, 0, 0 }, text)
end



function enableRadio(enable)

  SetNuiFocus(true, true)
  radioMenu = enable

  SendNUIMessage({
    type = "enableui",
    enable = enable
  })

end



RegisterCommand('radio', function(source, args)
    if Config.enableCmd then
      enableRadio(true)
    end
end, false)




RegisterCommand('funkcheck', function(source, args)
  local playerName = GetPlayerName(PlayerId())
  local data = exports.saltychat:GetRadioChannel(true)

  if data == nil or data == '' then
    ESX.ShowNotification('Du bist momentan in keinem Funk-Kanal')
  else
   ESX.ShowNotification('Du bist im Funk-Kanal: '.. data ..'.00 MHz')
 end

end, false)



RegisterNUICallback('joinRadio', function(data, cb)
	local getPlayerRadioChannel = exports.saltychat:GetRadioChannel(true)
	local playerJob = ESX.GetPlayerData().job
	
	if playerJob == nil or playerJob.name == nil then
		ESX.ShowNotification("Ein Fehler ist aufgetreten. Bitte versuche es später erneut.")
	end

	 if data.channel ~= getPlayerRadioChannel then
        if Config.RestrictedChannels[data.channel] ~= nil then
          if Config.RestrictedChannels[data.channel][playerJob.name] ~= nil then
            exports.saltychat:SetRadioChannel(data.channel, true)
            ESX.ShowNotification('Du bist nun im Funk')
            SendNUIMessage({ type = "changeChannel", value = data.channel})
          else
            ESX.ShowNotification('Dieser Funk-Kanal ist verschlüsselt')
          end
        else
          exports.saltychat:SetRadioChannel(data.channel, true)
          ESX.ShowNotification('Du bist nun im Funk')
          SendNUIMessage({ type = "changeChannel", value = data.channel})
        end
     else
        ESX.ShowNotification('Du bist bereits in diesem Funk')
     end
      --[[
    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
    exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
    PrintChatMessage("radio: " .. data.channel)
    print('radiook')
      ]]--
    cb('ok')
end)



RegisterNUICallback('leaveRadio', function(data, cb)
	local playerName = GetPlayerName(PlayerId())
	local getPlayerRadioChannel = exports.saltychat:GetRadioChannel(true)

	if getPlayerRadioChannel == nil or getPlayerRadioChannel == '' then
      ESX.ShowNotification('Du bist momentan in keinem Funk-Kanal')
    else
		exports.saltychat:SetRadioChannel('', true)
        SendNUIMessage({ type = "changeChannel", value = -1})
        ESX.ShowNotification('Du hast den Funk-Kanal verlassen')
    end

   cb('ok')

end)

RegisterNUICallback('escape', function(data, cb)

    enableRadio(false)
    SetNuiFocus(false, false)


    cb('ok')
end)



RegisterNetEvent('ls-radio:use')
AddEventHandler('ls-radio:use', function()
	TriggerEvent('inv:close')
	enableRadio(true)
end)

RegisterNetEvent('ls-radio:onRadioDrop')
AddEventHandler('ls-radio:onRadioDrop', function(source)
  local playerName = GetPlayerName(source)
  local getPlayerRadioChannel = exports.saltychat:GetRadioChannel(true)


  if getPlayerRadioChannel ~= '' then
	exports.saltychat:SetRadioChannel('', true)
    SendNUIMessage({ type = "changeChannel", value = -1})
    SendNUIMessage({ type = "hasradio", state = false})

end
end)

Citizen.CreateThread(function()
    while true do
        if radioMenu then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)
