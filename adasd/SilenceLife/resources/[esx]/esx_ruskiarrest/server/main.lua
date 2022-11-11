-- Skrypt od strony Serwera

FastLife = nil

TriggerEvent('fastlife:getSharedObject', function(obj) FastLife = obj end)

RegisterServerEvent('fastlife_ruski_areszt:startAreszt')
AddEventHandler('fastlife_ruski_areszt:startAreszt', function(target)
	local targetPlayer = FastLife.GetPlayerFromId(target)

	TriggerClientEvent('fastlife_ruski_areszt:aresztowany', targetPlayer.source, source)
	TriggerClientEvent('fastlife_ruski_areszt:aresztuj', source)
end)