
keysblocked = 0 
--
-- @ PlayerInfo Functions
--
function PlayerInfo_setMute(state)
    PlayerInfo.isMuted = state
    ExecuteCommand("+voiceRange")     
end


--
-- @ System Functions
--
function debug(enabled, text)    
    if sys_debug then
        print(text)
    elseif enabled == nil then
        -- skip
    elseif enabled == true then
        Citizen.Trace("Trace: "..text.."\n")
    end
end

function checkKeys(key)    
    if IsControlJustReleased(0, key) then
        --SetKeyCooldown() 
        --TriggerEvent("core:keyPressed", key)
    end
end


function checkHandCuffed()
    while not sys_init_done do
        --debug(sys_debug,"waiting...")
        Wait(500) 
    end
    if PlayerInfo.isHandcuffed then
        ESX.UI.Menu.CloseAll()
        DisableControlAction(0, 24, true) -- Attack
        DisableControlAction(0, 257, true) -- Attack 2
        DisableControlAction(0, 25, true) -- Aim
        DisableControlAction(0, 263, true) -- Melee Attack 1
        DisableControlAction(0, 45, true) -- Reload
        DisableControlAction(0, 22, true) -- Jump
        DisableControlAction(0, 44, true) -- Cover
        DisableControlAction(0, 37, true) -- Select Weapon
        DisableControlAction(0, 23, true) -- Also 'enter'?
        DisableControlAction(0, 29, true) -- B
        DisableControlAction(0, 73, true) -- X
        DisableControlAction(0, 288, true) -- Disable phone
        DisableControlAction(0, 289, true) -- Inventory
        DisableControlAction(0, 170, true) -- Animations
        DisableControlAction(0, 167, true) -- Job
        DisableControlAction(0, 73, true) -- Disable clearing animation
        DisableControlAction(2, 199, true) -- Disable pause screen
        DisableControlAction(0, 59, true) -- Disable steering in vehicle
        DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
        DisableControlAction(0, 72, true) -- Disable reversing in vehicle
        DisableControlAction(0, 47, true) -- Disable weapon
        DisableControlAction(0, 264, true) -- Disable melee
        DisableControlAction(0, 257, true) -- Disable melee
        DisableControlAction(0, 140, true) -- Disable melee
        DisableControlAction(0, 141, true) -- Disable melee
        DisableControlAction(0, 142, true) -- Disable melee
        DisableControlAction(0, 143, true) -- Disable melee
        DisableControlAction(0, 75, true) -- Disable exit vehicle
        DisableControlAction(27, 75, true) -- Disable exit vehicle
        DisableControlAction(0, 21, true) -- Disable Sprint
        DisableControlAction(0, 243, true) -- Disable ^
        DisableControlAction(0, 169, true) -- Disable F8
        DisableControlAction(0, 245, true) -- Disable Chat
        DisableControlAction(0, 182, true) -- Disable Ragdoll
        DisableControlAction(0, 311, true) -- Disable K
        DisableControlAction(0, 74, true) -- Disable H
        DisableControlAction(0, 246, true) -- Disable Z
        DisableControlAction(0, 47, true) -- Disable G
        DisableControlAction(0, 137, true) -- Disable Radio
        DisableControlAction(0, 303, true) -- Disable Lock Veh
    end
end

function getGenericTextInput(type)
    if type == nil then
        type = ''
    end
    AddTextEntry('FMMC_MPM_NA', tostring(type))
    DisplayOnscreenKeyboard(1, 'FMMC_MPM_NA', tostring(type), '', '', '', '', 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            return result
        end
    end
    return false
end


function DrawText3D(x,y,z, text, scl, font) 
    if scl == nil then
        scl = 0.8
    end

    if font == nil then
        font = 4
    end

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end


local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(5)
		math.randomseed(GetGameTimer())
		if Config_Vehicleshop.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(Config_Vehicleshop.PlateLetters) .. '-' ..  GetRandomNumber(Config_Vehicleshop.PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(Config_Vehicleshop.PlateLetters) .. GetRandomNumber(Config_Vehicleshop.PlateNumbers))
		end

		ESX.TriggerServerCallback('vehicleshop.isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('vehicleshop.isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(5)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(5)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(5)
	math.randomseed(GetGameTimer())
	print(length)
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end


function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {
            handle = iter,
            destructor = disposeFunc
        }
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end
 

function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end