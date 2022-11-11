RegisterCommand('911', function(source, args) -- normal 911
	local msg = table.concat(args, ' ')
	if args[1] then
		local coords = GetEntityCoords(PlayerPedId())
		local position = {x = coords.x, y = coords.y, z = coords.z - 1}
		TriggerServerEvent('roadphone:sendDispatch', GetPlayerServerId(PlayerId()), msg, 'police', position, false)
	end
end)

RegisterCommand('911a', function(source, args) -- anonymous 911
	local msg = table.concat(args, ' ')
	if args[1] then
		local coords = GetEntityCoords(PlayerPedId())
		local position = {x = coords.x, y = coords.y, z = coords.z - 1}
		TriggerServerEvent('roadphone:sendDispatch', GetPlayerServerId(PlayerId()), msg, 'police', position, true)
	end
end)