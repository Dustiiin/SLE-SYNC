phone = false
videocall = false
phoneId = 0

RegisterNetEvent('camera:phone')
AddEventHandler('camera:phone', function()
    CreateMobilePhone(0)
    CellCamActivate(true, true)
    phone = true
    PhonePlayOut()
end)



frontCam = false

RegisterNetEvent('camera:videophone')
AddEventHandler('camera:videophone', function()
    CreateMobilePhone(0)
    CellCamActivate(true, true)
    phone = true
    videocall = true
    PhonePlayOut()
    CellFrontCamActivate(true)
    SetNuiFocus(true, true)
    frontCam = true
end)

function CellFrontCamActivate(activate)
    return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

CreateThread(function()
    DestroyMobilePhone()
    local letSleep = true
    while true do
        Wait(0)
        if IsControlJustPressed(0, 27) and phone then --Selfie
            letSleep = false
            frontCam = not frontCam
            CellFrontCamActivate(frontCam)
        end



        if IsControlJustPressed(0, 177) and phone then --Close
            letSleep = false
            DestroyMobilePhone()
            phone = false
            CellCamActivate(false, false)
            PhonePlayOut()
            newPhoneProp()
            PhonePlayIn()
            SendNUIMessage({action = "homescreen"})
            TriggerEvent('roadphone:setFocus')
            SendNUIMessage({action = "camerastop"})
            if videocall then
                SendNUIMessage({action = "videocallend"})
                videocall = false
            end
        end

         if IsControlJustPressed(0, 176) and phone and not videocall then
            letSleep = false
            SendNUIMessage({action = "TakePhoto"})
        end

        if phone then
            letSleep = false
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(9)
            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(19)
            HideHudAndRadarThisFrame()
        end

        if letSleep then
			Wait(1500)
		end
    end
end)

RegisterNUICallback("camerastop", function()
    DestroyMobilePhone()
    phone = false
    videocall = false
    CellCamActivate(false, false)
    PhonePlayOut()
    newPhoneProp()
    PhonePlayIn()
    TriggerEvent('roadphone:setFocus')
    SendNUIMessage({action = "camerastop"})

    if videocall then
        SendNUIMessage({action = "videocallend"})
        videocall = false
    end
end)