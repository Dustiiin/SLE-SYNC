--https://forum.cfx.re/t/help-creating-a-addtextentry-script/230504/5

local vehicle_names = {
    {'vehicle_spawnname', 'displayed_name'},  --spawnName = vehicle.meta carname. displayed_name = displayed name in the menu
    --example:  {'pista', 'Ferrari 458 Pista'},
}

function getVehicleNames()
    return vehicle_names
end