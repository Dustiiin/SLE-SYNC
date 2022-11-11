ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('carlock:isVehicleOwner', function(source, cb, plate)
	local identifier = GetPlayerIdentifier(source, 0)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == identifier)
		else
			cb(false)
		end
	end)
end)

-- Piece of code from Scott's InteractSound script : https://forum.fivem.net/t/release-play-custom-sounds-for-interactions/8282
RegisterServerEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
end)

if Config.versionChecker then
    PerformHttpRequest("https://rawgit.com/Xseba360/esx_locksystem/master/VERSION", function(err, rText, headers)
		if rText then
			if tonumber(rText) > tonumber(_VERSION) then
				print("\n---------------------------------------------------")
				print("LockSystem : An update is available !")
				print("---------------------------------------------------")
				print("Current : " .. _VERSION)
				print("Latest  : " .. rText .. "\n")
			end
		else
			print("\n---------------------------------------------------")
			print("Unable to find the version.")
			print("---------------------------------------------------\n")
		end
	end, "GET", "", {what = 'this'})
end
