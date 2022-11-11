function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	AddTextEntry('scpd1', 'Crown Victoria')
	AddTextEntry('scpd2', 'Taurus')
	AddTextEntry('scpd3', 'Dodge Charger')
	AddTextEntry('scpd4', 'Explorer')
	AddTextEntry('scpd5', 'scpd5')
	AddTextEntry('scpd6', 'Tahoe')
	AddTextEntry('scpd7', 'Silverado')
	AddTextEntry('scpd8', 'Motorrad')
	
	
end)