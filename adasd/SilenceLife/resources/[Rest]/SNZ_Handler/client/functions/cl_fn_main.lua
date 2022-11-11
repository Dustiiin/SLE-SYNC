Framework = nil

SNZ.HandlerName = GetCurrentResourceName()

SNZ.PlayerData = {}

SNZ.Zones = Config.ScriptZones

SNZ.CurrentZone = nil
SNZ.IsInZone = nil
SNZ.WasInZone = nil

SNZ.DrawTexts = {}

SNZ.PedData = {
	Id = nil,
	Ped = nil,
	Coords = nil,
	Heading = nil,
	Alive = false,
	Health = nil,
	Armour = nil,
	Sprinting = false,
	IsRunning = false,
	Stamina = nil,
	UnderWater = false,
	IsSwimming = false,
	UnderwaterTime = nil,
	Talking = false,
	CameraRotation = nil,
	OnFoot = false,
	WasOnFoot = false,
	Reycast = nil,
	InVehicle = false,
	IsEnteringVehicle = false,
	CurrentVehicle = nil,
	Speed = 0,
	PrevSpeed = 0,
	RPM = 0,
	Engine = false,
	VehicleClass = nil,
	RPMScale = nil,
	Talking = false,
	IsTalking = false,
	Velocity = nil,
	PrevVelocity = nil,
	SpeedVector = nil,
	Acceleration = nil,
	Zone = nil,
	StreetLabel = {
		Zone = nil,
		Direction = nil,
		Street = nil
	}
}

SNZ.ClientTick = 0

SNZ.Functions.GetSharedObject = function()
	return SNZ
end

SNZ.Functions.HasChanged = function(value1, value2)
	if value1 == nil then
		return true
	end
	if value1 ~= value2 then
		return true
	end
	return false
end

SNZ.Functions.GetPedData = function()
	return SNZ.PedData
end

SNZ.Functions.GetCurrentZone = function()
	return SNZ.CurrentZone
end

SNZ.Functions.AddZones = function(zones)
	for k, v in pairs(zones) do
		if not SNZ.Zones[k] then
			SNZ.Zones[k] = zones[k]
		end
	end
end

SNZ.Functions.GetStreetName = function(coords)
	local StreetHash1, StreetHash2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	local Street1 = GetStreetNameFromHashKey(StreetHash1)
	local Street2 = GetStreetNameFromHashKey(StreetHash2)
	return Street1..(Street2 ~= '' and ' '..' | '..' '..Street2 or '')
end

SNZ.Functions.GetPedDataThread = function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(Config.PedDataRefreshInterval)
			SNZ.ClientTick = SNZ.ClientTick + 1
			SNZ.PedData.Id = PlayerId()
			SNZ.PedData.Ped = PlayerPedId()
			SNZ.PedData.Coords = GetEntityCoords(SNZ.PedData.Ped)
			SNZ.PedData.Heading = GetEntityHeading(SNZ.PedData.Ped)
			SNZ.PedData.Alive = not IsEntityDead(SNZ.PedData.Ped)
			SNZ.PedData.Health = GetEntityHealth(SNZ.PedData.Ped)
			SNZ.PedData.Armour = GetPedArmour(SNZ.PedData.Ped)
			SNZ.PedData.Sprinting = IsPedSprinting(SNZ.PedData.Ped)
			SNZ.PedData.Stamina = GetPlayerSprintStaminaRemaining(SNZ.PedData.Id)
			SNZ.PedData.UnderWater = IsPedSwimmingUnderWater(SNZ.PedData.Ped)
			SNZ.PedData.UnderWaterTime = GetPlayerUnderwaterTimeRemaining(SNZ.PedData.Id)
			SNZ.PedData.Talking = NetworkIsPlayerTalking(SNZ.PedData.Id)
			if SNZ.PedData.UnderWaterTime < 0.0 then
				SNZ.PedData.UnderWaterTime = 0.0
			end
			SNZ.PedData.CameraRotation = GetGameplayCamRot(2)[3]
			if SNZ.PedData.CameraRotation < 0 then
				SNZ.PedData.CameraRotation = 360.0 + SNZ.PedData.CameraRotation
			end
			SNZ.PedData.OnFoot = IsPedOnFoot(SNZ.PedData.Ped)
			SNZ.PedData.Reycast = SNZ.Functions.GetReycast(SNZ.PedData.Ped, Config.ReycastDistance)
			if SNZ.PedData.InVehicle then
				SNZ.PedData.PrevSpeed = SNZ.PedData.Speed
				SNZ.PedData.PrevVelocity = SNZ.PedData.Velocity
				SNZ.PedData.Engine = GetIsVehicleEngineRunning(SNZ.PedData.CurrentVehicle)
				SNZ.PedData.Speed = GetEntitySpeed(SNZ.PedData.CurrentVehicle)
				SNZ.PedData.RPM = GetVehicleCurrentRpm(SNZ.PedData.CurrentVehicle)
				SNZ.PedData.Velocity = GetEntityVelocity(SNZ.PedData.CurrentVehicle)
				SNZ.PedData.SpeedVector = GetEntitySpeedVector(SNZ.PedData.CurrentVehicle, true).y
				SNZ.PedData.Acceleration = (SNZ.PedData.PrevSpeed - SNZ.PedData.Speed) / GetFrameTime()
				if SNZ.PedData.SpeedVector > 1.0 and SNZ.PedData.Acceleration >= Config.MinimumCrashForce and SNZ.PedData.PrevSpeed >= Config.MinimumCrashSpeed then
					TriggerEvent(SNZ.HandlerName..':OnVehicleHit', SNZ.PedData.Ped, SNZ.PedData.PrevVelocity, SNZ.PedData.Coords, SNZ.PedData.CurrentVehicle)
				end
			end
			if SNZ.ClientTick >= 10 then
				SNZ.ClientTick = 0
				--[[
				SNZ.DrawTexts = {}
				for k, v in pairs(SNZ.Zones) do
					for k2, v2 in pairs(v.Positions) do
						local Distance = GetDistanceBetweenCoords(SNZ.PedData.Coords, v2.x, v2.y, v2.z, true)
						if Distance < v.TextDistance then
							table.insert(SNZ.DrawTexts, {v2.x, v2.y, v2.z, v.DrawText})
							if Distance < v.InteractDistance then
								SNZ.IsInZone = true
								SNZ.CurrentZone = v
							end
						end
					end
				end
				if SNZ.IsInZone and not SNZ.WasInZone then
					SNZ.WasInZone = true
					TriggerEvent(SNZ.HandlerName..':HasEnteredZone', SNZ.CurrentZone)
				--elseif SNZ.IsInZone and SNZ.WasInZone then
				elseif not SNZ.IsInZone and SNZ.WasInZone then
					SNZ.WasInZone = false
					SNZ.CurrentZone = nil
					TriggerEvent(SNZ.HandlerName..':HasLeftZone')
				end
				]]--
				if SNZ.PedData.Talking and not SNZ.PedData.IsTalking then
					SNZ.PedData.IsTalking = true
					TriggerEvent(SNZ.HandlerName..':IsTalking')
				elseif not SNZ.PedData.Talking and SNZ.PedData.IsTalking then
					SNZ.PedData.IsTalking = false
					TriggerEvent(SNZ.HandlerName..':IsNotTalking')
				end
				if SNZ.PedData.UnderWater and not SNZ.PedData.IsSwimming then
					SNZ.PedData.IsSwimming = true
					TriggerEvent(SNZ.HandlerName..':IsUnderWater')
				elseif not SNZ.PedData.UnderWater and SNZ.PedData.IsSwimming then
					SNZ.PedData.IsSwimming = false
					TriggerEvent(SNZ.HandlerName..':IsNotUnderWater')
				end
				if SNZ.PedData.Sprinting and not SNZ.PedData.IsRunning then
					SNZ.PedData.IsRunning = true
					TriggerEvent(SNZ.HandlerName..':IsSprinting')
				elseif not SNZ.PedData.Sprinting and SNZ.PedData.IsRunning then
					SNZ.PedData.IsRunning = false
					TriggerEvent(SNZ.HandlerName..':IsNotSprinting')
				end
				if Config.AutoHideRadar then
					if SNZ.PedData.OnFoot and not SNZ.PedData.WasOnFoot then
						SNZ.PedData.WasOnFoot = true
						DisplayRadar(false)
						TriggerEvent(SNZ.HandlerName..':IsOnFoot')
					elseif not SNZ.PedData.OnFoot and SNZ.PedData.WasOnFoot then
						SNZ.PedData.WasOnFoot = false
						DisplayRadar(true)
						TriggerEvent(SNZ.HandlerName..':IsNotOnFoot')
					end
				end
				if not SNZ.PedData.InVehicle and SNZ.PedData.Alive then
					if DoesEntityExist(GetVehiclePedIsTryingToEnter(SNZ.PedData.Ped)) and not SNZ.PedData.IsEnteringVehicle then
						SNZ.PedData.IsEnteringVehicle = true
					elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(SNZ.PedData.Ped)) and not IsPedInAnyVehicle(SNZ.PedData.Ped, true) and SNZ.PedData.IsEnteringVehicle then
						SNZ.PedData.IsEnteringVehicle = false
					elseif IsPedInAnyVehicle(SNZ.PedData.Ped, false) then
						SNZ.PedData.IsEnteringVehicle = false
						SNZ.PedData.InVehicle = true
						SNZ.PedData.CurrentVehicle = GetVehiclePedIsUsing(SNZ.PedData.Ped)
						SNZ.PedData.VehicleClass = GetVehicleClass(SNZ.PedData.CurrentVehicle)
						if (SNZ.PedData.VehicleClass >= 0 and SNZ.PedData.VehicleClass <= 5) or (SNZ.PedData.VehicleClass >= 9 and SNZ.PedData.VehicleClass <= 12) or SNZ.PedData.VehicleClass == 17 or SNZ.PedData.VehicleClass == 18 or SNZ.PedData.VehicleClass == 20 then
							SNZ.PedData.RPMScale = 7000
						elseif SNZ.PedData.VehicleClass == 6 then
							SNZ.PedData.RPMScale = 7500
						elseif SNZ.PedData.VehicleClass == 7 then
							SNZ.PedData.RPMScale = 8000
						elseif SNZ.PedData.VehicleClass == 8 then
							SNZ.PedData.RPMScale = 11000
						elseif SNZ.PedData.VehicleClass == 15 or SNZ.PedData.VehicleClass == 16 then
							SNZ.PedData.RPMScale = -1
						end
						if Config.AutoHideRadar then
							DisplayRadar(true)
						end
						TriggerEvent(SNZ.HandlerName..':OnVehicleEnter', SNZ.PedData.CurrentVehicle)
					end
				elseif SNZ.PedData.InVehicle then
					SNZ.PedData.Zone = GetNameOfZone(SNZ.PedData.Coords.x, SNZ.PedData.Coords.y, SNZ.PedData.Coords.z)
					for k, v in pairs(Config.Directions) do
						if math.abs(SNZ.PedData.Heading - k) < 22.5 then
							SNZ.PedData.StreetLabel.Direction = v
							break
						end
					end
					SNZ.PedData.StreetLabel.Zone = (Config.Zones[SNZ.PedData.Zone:upper()] or SNZ.PedData.Zone:upper())
					SNZ.PedData.StreetLabel.Street = SNZ.Functions.GetStreetName(SNZ.PedData.Coords)
					if not IsPedInAnyVehicle(SNZ.PedData.Ped, false) or not SNZ.PedData.Alive then
						SNZ.PedData.InVehicle = false
						if Config.AutoHideRadar then
							DisplayRadar(false)
						end
						TriggerEvent(SNZ.HandlerName..':OnVehicleExit', SNZ.PedData.CurrentVehicle)
						SNZ.PedData.CurrentVehicle = 0
						SNZ.PedData.RPMScale = 0
						SNZ.PedData.VehicleClass = nil
					end
				end
			end
		end
	end)
end

SNZ.Functions.GetReycast = function(ped, distance)
	if ped and distance then
		local CameraRotation = (math.pi / 180.0) * GetGameplayCamRot(2)
		local CameraCoords = GetGameplayCamCoord()
	    local TargetCoords = CameraCoords + (vector3(-math.sin(CameraRotation.z) * math.abs(math.cos(CameraRotation.x)), math.cos(CameraRotation.z) * math.abs(math.cos(CameraRotation.x)), math.sin(CameraRotation.x)) * distance)
	    local TestShapeHandle = StartExpensiveSynchronousShapeTestLosProbe(CameraCoords, TargetCoords, -1, ped, 1)
	    local ShapeTestHandle, Hit, Coords, Surface, Entity = GetShapeTestResult(TestShapeHandle)
		return {ShapeTestHandle = ShapeTestHandle, Hit = Hit, Coords = Coords, Surface = Surface, Entity = Entity}
	end
end

exports('GetSharedObject', function()
	return SNZ.Functions.GetSharedObject()
end)

exports('GetFrameworkStatus', function()
	return SNZ.Functions.GetFrameworkStatus()
end)

exports('GetTalking', function()
	return SNZ.PedData.IsTalking
end)

exports('GetUnderWater', function()
	return SNZ.PedData.IsSwimming
end)

exports('GetSprinting', function()
	return SNZ.PedData.IsRunning
end)

exports('GetInVehilce', function()
	return SNZ.PedData.InVehicle
end)

exports('GetPedData', function()
	return SNZ.PedData
end)

exports('GetConfig', function()
	return Config
end)