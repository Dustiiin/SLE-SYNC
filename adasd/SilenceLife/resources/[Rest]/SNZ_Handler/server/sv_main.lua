if Config.Framework == 'ESX' then

TriggerEvent('esx:getSharedObject', function(obj) 
	Framework = obj 
end)


elseif Config.Framework == 'QBCore' then

Framework = exports['qb-core']:GetSharedObject()

end
