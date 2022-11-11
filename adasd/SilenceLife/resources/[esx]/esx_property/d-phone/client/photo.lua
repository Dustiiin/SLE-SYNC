phone = false
phoneId = 0


RegisterNetEvent('camera:phone')
AddEventHandler('camera:phone', function()		
	CreateMobilePhone(phoneId)
	CellCamActivate(true, true)
	phone = true
end)

frontCam = false

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

-- RemoveLoadingPrompt()

TakePhoto = N_0xa67c35c56eb1bd9d
WasPhotoTaken = N_0x0d6ca79eeebd8ca3
SavePhoto = N_0x3dec726c25a11bac
ClearPhoto = N_0xd801cc02177fa3f1

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

Citizen.CreateThread(function()
DestroyMobilePhone()
	while true do
		Citizen.Wait(0)
		
		if IsControlJustPressed(0, 27) and phone == true then -- SELFIE MODE
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
		end
		
		if phone == true then
			AddTextEntry(GetCurrentResourceName(), _U("cameracontrol"))
			DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
		end

		if IsControlJustPressed(0, 177) and phone == true then -- CLOSE PHONE
			DestroyMobilePhone()
			phone = false
			CellCamActivate(false, false)
			newPhoneProp()
			DoPhoneAnimation('cellphone_text_in')
			TriggerServerEvent("d-phone:server:getphonedata", GetPlayerServerId(PlayerId()))
		end
		
		if IsControlJustPressed(0, 176) and phone == true then -- TAKE.. PIC
			TakePhoto()
			if (WasPhotoTaken() and SavePhoto(-1)) then
				-- SetLoadingPromptTextEntry("CELL_278")
				-- ShowLoadingPrompt(1)
				ClearPhoto()
			end
		end
			
		if phone == true then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(19)
			HideHudAndRadarThisFrame()
		end
			
		-- ren = GetMobilePhoneRenderId()
		-- SetTextRenderId(ren)
		
		-- Everything rendered inside here will appear on your phone.
		
		-- SetTextRenderId(1) -- NOTE: 1 is default
	end
end)