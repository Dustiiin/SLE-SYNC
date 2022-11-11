-- ====================================================================================
--                                    RoadToSix 
-- ====================================================================================
local isInFocus = false
local isInFlashlight = false

if Config.RegisterKeyMapping then
    RegisterKeyMapping('TooglePhone', _U('registerkeymapping'), 'keyboard', Config.OpenPhoneKey)

    RegisterCommand("TooglePhone", function()
        TooglePhone()
    end)
else
    CreateThread(function()
        while true do
            if IsControlJustReleased(0, 288) then
                TooglePhone()
            end
            Wait(0)
        end
    end)
end

RegisterNUICallback('sendDispatch', function(data)

    local coords = GetEntityCoords(PlayerPedId())
    local position = {
        x = coords.x,
        y = coords.y,
        z = coords.z - 1
    }

    if data.gps then
        TriggerServerEvent('roadphone:sendDispatch', GetPlayerServerId(PlayerId()), data.message, data.job, position,
            data.anonym)
    else
        TriggerServerEvent('roadphone:sendDispatch', GetPlayerServerId(PlayerId()), data.message, data.job, nil,
            data.anonym)
    end
end)

RegisterNUICallback("sendNotification", function(data)

    TriggerEvent("roadphone:sendNotification", data)

end)

function GiveCarKeys(plate)

    -- Modify this function if your car is locked

    --TriggerEvent("vehiclekeys:client:SetOwner", plate) --if this is not your vehiclesystem modify the event
end

RegisterNetEvent("roadphone:sendNotification")
AddEventHandler("roadphone:sendNotification", function(data)

    if data.lockscreen == nil then
        data.lockscreen = false
    end

    if Config.NeedItem then
        ESX.TriggerServerCallback('roadphone:getPhoneAmount', function(amount)
            if amount then

                SendNUIMessage({
                    action = "show_notification",
                    title = data.title,
                    sender = data.sender,
                    message = data.message,
                    img = data.img,
                    lockscreen = data.lockscreen
                })
            end
        end)
    else
        SendNUIMessage({
            action = "show_notification",
            title = data.title,
            sender = data.sender,
            message = data.message,
            img = data.img,
            lockscreen = data.lockscreen
        })
    end

end)

function startRadioAnimation()

    if Config.RadioAnimation and Config.UseMumbleVoip or Config.UsePmaVoice and not getRadioAnimation() then
        local ped = PlayerPedId()
        setRadioAnimation(true)
        RequestAnimDict("random@arrests")
        while not HasAnimDictLoaded("random@arrests") do
            Wait(150)
        end

        CreateThread(function()

            while getRadioAnimation() do
                Wait(0)
                if not getHandyActive() then
                    if not IsPedFalling(ped) then
                        if not IsEntityDead(ped) then
                            if IsControlPressed(0, Config.RadioAnimationKey) then
                                TaskPlayAnim(ped, "random@arrests", "generic_radio_chatter", 4.0, -1, -1, 50, 0, false,
                                    false, false)
                                Wait(1000)

                                StopAnimTask(ped, "random@arrests", "generic_radio_chatter", 1.0)
                            end
                        end
                    end
                end
            end
        end)
    end
end

CreateThread(function()
    while true do
        if getHandyActive() then
            if not isInFocus then
                if not isInFlashlight then
                    DisableControlAction(0, 1, true)
                    DisableControlAction(0, 2, true)
                    SetNuiFocusKeepInput(true)
                end
                DisableControlAction(0, 304, true)
                DisableControlAction(0, 101, true)
                DisableControlAction(0, 74, true)
                DisableControlAction(0, 303, true)
                DisableControlAction(0, 311, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 29, true)
                DisableControlAction(0, 322, true)
                DisableControlAction(0, 200, true)
                DisableControlAction(0, 202, true)
                DisableControlAction(0, 177, true)
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 245, true)
                DisableControlAction(0, 263, true)
                DisableControlAction(0, 45, true)
                DisableControlAction(0, 80, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 0, true)
                DisableControlAction(0, 36, true)
                DisableControlAction(0, 326, true)
                DisableControlAction(0, 341, true)
                DisableControlAction(0, 343, true)
                DisableControlAction(0, 257, true)
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 44, true)
                DisableControlAction(0, 288, true)
                DisableControlAction(0, 289, true)
                DisableControlAction(0, 170, true)
                DisableControlAction(0, 167, true)
                DisableControlAction(0, 26, true)
                DisableControlAction(0, 73, true)
                DisableControlAction(2, 199, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 264, true)
                DisableControlAction(0, 257, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 81, true)
                DisableControlAction(0, 82, true)
                DisableControlAction(0, 99, true)
                DisableControlAction(0, 100, true)
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 142, true)
                DisableControlAction(0, 143, true)
                DisableControlAction(0, 106, true)
                DisableControlAction(0, 115, true)
                DisableControlAction(0, 245, true)
                DisableControlAction(0, 44, true)
                DisableControlAction(0, 157, true)
                DisableControlAction(0, 158, true)
                DisableControlAction(0, 160, true)
                DisableControlAction(0, 164, true)
                DisableControlAction(0, 165, true)
                DisableControlAction(0, 159, true)
                DisableControlAction(0, 161, true)
                DisableControlAction(0, 162, true)
                DisableControlAction(0, 163, true)
                DisableControlAction(0, 182, true)
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    SetPlayerCanDoDriveBy(PlayerId(), false)
                end
                SetNuiFocusKeepInput(true)
            else
                SetNuiFocusKeepInput(false)
            end
        else
            SetPlayerCanDoDriveBy(PlayerId(), true)
            Wait(200)
        end
        Wait(0)
    end
end)

CreateThread(function()
    if Config.RemoveFromRadioWhenDead then
        while true do
            Wait(2000)
            if IsEntityDead(PlayerPedId()) and getRadioActive() then
                TriggerEvent("roadphone:leaveradio")
            end
        end
    end
end)
RegisterNUICallback('notification', function(data)
    sendNotification(data.text)
end)

RegisterNetEvent('roadphone:sendOffNotification')
AddEventHandler('roadphone:sendOffNotification', function(text)
    sendNotification(text)
end)

RegisterNUICallback('inputfocus', function(data) -- Do not change anything here!

    if isInFocus ~= data.focus then
        isInFocus = data.focus
    end
end)

RegisterNUICallback('flashlightfocus', function(data) -- Do not change anything here!

    if isInFlashlight ~= data.focus then
        isInFlashlight = data.focus
    end

end)
function sendNotification(text)

    -- Replace ESX.ShowNotification with your own function/method if you want your own notifications to come.

    -- TriggerEvent("notifications", "#FF1D25", "Phone", text)

    ESX.ShowNotification(text)

end

if Config.myMultichar then
    AddEventHandler('myMultichar:loaded', function()
        Wait(3000)
        TriggerServerEvent('roadphone:playerLoad', GetPlayerServerId(PlayerId()))
    end)
end

local firstSpawn = false

if Config.esxMultichar then
    AddEventHandler(Config.ESXSpawnEvent, function(data)

        if not firstSpawn then

            firstSpawn = true

            Wait(2000)

            TriggerServerEvent('roadphone:playerLoad', GetPlayerServerId(PlayerId()))
        end

    end)
end

RegisterNetEvent(Config.ESXName .. ':playerLoaded')
AddEventHandler(Config.ESXName .. ':playerLoaded', function(playerData)

    local accounts = playerData.accounts or {}
    for index, account in ipairs(accounts) do
        if account.name == 'bank' then
            SendNUIMessage({
                action = "updateBankBalance",
                balance = account.money
            })
        end
    end

end)

CreateThread(function()
    while true do
        Wait(2000)
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('roadphone:playerLoad', GetPlayerServerId(PlayerId()))
            break
        end
    end
end)

RegisterNUICallback("loadPlayer", function()
    TriggerServerEvent('roadphone:playerLoad', GetPlayerServerId(PlayerId()))
end)

function getJobSocietyMoney(society)

    ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(cb)

        SendNUIMessage({
            action = "updateJobsSettingsBalance",
            balance = cb
        })

    end, society)

end

RegisterNetEvent('roadphone:use')
AddEventHandler('roadphone:use', function()
    TooglePhone()
end)

RegisterCommand("Phone", function()
    TooglePhone()
end)

----------------NEW CHECK DEATH-----------------

local IsDead = false

AddEventHandler(Config.ESXDeathEvent, function(data)
    SetDisplay(false)
    setHandyActive(false)
    PhonePlayOut()
    SendNUIMessage({
        action = 'disable'
    })
    IsDead = true
end)

AddEventHandler(Config.ESXSpawnEvent, function(spawn)
    IsDead = false
end)

if Config.ESXVersion == "1.1" then
    
AddEventHandler("playerSpawned", function(spawn)
    IsDead = false
end)

end

function checkPlayerDead()
    if Config.VisnAre then
        return false
    end

    return IsDead
end

-------------END NEW CHECK DEATH----------------

--------------OLD Check DEATH-----------------

-- function checkPlayerDead() return IsPedDeadOrDying(PlayerPedId()) end


RegisterCommand("sendTestMail", function(args, rawCommand)

    local data = {
        ["coords"] = true
    }

    TriggerServerEvent('roadphone:receiveMail', {
        sender = 'ROADSHOP',
        subject = "ROADPHONE",
        message = 'Buy RoadPhone!',
        image = '/public/html/static/img/icons/app/mail.png',
        button = {
          buttonEvent = "qb-drugs:client:setLocation",
          buttonData = data,
          buttonname = "SetLocation"
        }
     })
end)

RegisterCommand("sendTestMail2", function(args, rawCommand)

    local data = {
        ["coords"] = true
    }

    TriggerServerEvent('roadphone:receiveMail', {
        sender = 'ROADSHOP',
        subject = "ROADPAD",
        message = 'Buy RoadPad!',
        image = '/public/html/static/img/icons/app/mail.png',
        button = {
          buttonEvent = "qb-drugs:client:setLocation",
          buttonData = data,
          buttonname = "SetLocation"
        }
     })
end)