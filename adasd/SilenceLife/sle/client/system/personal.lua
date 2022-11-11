_personalPool = NativeUI.CreatePool()
personalMenu = NativeUI.CreateMenu("Silencelife", "~b~Personalmenü")
_personalPool:Add(personalMenu)
_personalPool:MouseControlsEnabled(false);

function AddName(menu)
    local name = NativeUI.CreateItem("Name: "..PlayerInfo.firstname.." "..PlayerInfo.lastname);
    menu:AddItem(name)

end

AddName(personalMenu)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _personalPool:ProcessMenus()
        if IsControlJustPressed(0, Keys["F5"]) then
            personalMenu:Visible(not personalMenu:Visible())
        end
    end
end)