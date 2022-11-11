function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	AddTextEntry('scpd9', 'Crown Victoria Unmarked')
	AddTextEntry('scpd10', 'Dodge Charger Unmarked')
	AddTextEntry('scpd11', 'Explorer Unmarked')
	AddTextEntry('scpd12', 'Tahoe Unmarked')
	AddTextEntry('scpd13', 'Silverado Unmarked')
	AddTextEntry('scpd14', 'scpd14')
	AddTextEntry('scpd15', 'scpd15')
	AddTextEntry('scpd16', 'Camarro')
	
	
end)