markers = {}
markers_current = {}
local timeout, timeout_current = 3, 0

RegisterCommand("testmarker", function()
    print("ausgeführt "..PlayerInfo.playerCoords)
    table.insert(markers,{coords = vector3(PlayerInfo.playerCoords), range = 5.0, size= 1.0, marker = 27, rgb={r=252,g=188,b=0}, job = "all", job_grade = 0, text = "Testmarker", 
        functions = {
            {
                text = "zum benutzen",
                key = Keys["E"], 
                func = function() 
                    exports['okokNotify']:Alert('test', 'test', 10000, 'type')
                end
            },{
                text = "zum ausrauben",
                key = Keys["Z"], 
                func = function() 
                    exports['okokNotify']:Alert("SUCCESS", "You have sent <span style='color:#47cf73'>420€</span> to Tommy!", 5000, 'success')   
                end
            },
        }
    })
end)



AddEventHandler("sysTimerTick_5000" , function()
    while not sys_init_done do
        --debug(sys_debug,"waiting...")
        Wait(500)
    end
    for k,v in pairs(markers) do
        for k2, v2 in pairs(markers) do
            if v.coords == v2.coords and v.job == v.job2 and v.text == v.text and k ~= k2 then
                table.remove(markers, k)
            end
        end       
    end
end)
AddEventHandler("sysTimerTick_1000", function()
    while not sys_init_done do
        --debug(sys_debug,"waiting...")
        Wait(500)
    end

    markers_current = {}


    if timeout_current >= 0 then
        timeout_current = timeout_current - 1
    end
    
    for k, v in pairs(markers) do
        if v.coords == nil or type(v.coords) ~= "vector3" then 
            print("failed text detected @ "..v.text.." for "..v.job)
        elseif v.size == nil or type(v.size) ~= "number" then 
            print("failed size detected @ "..v.text.." for "..v.job)
        elseif v.marker == nil or type(v.marker) ~= "number" then 
            print("failed marker detected @ "..v.text.." for "..v.job)
        elseif v.rgb == nil or type(v.rgb) ~= "table" then 
            print("failed rgb detected @ "..v.text.." for "..v.job)
        elseif v.rgb == nil or v.rgb.r == nil or v.rgb.g == nil or v.rgb.b == nil or type(v.rgb.r) ~= "number" or type(v.rgb.g) ~= "number" or type(v.rgb.g) ~= "number" then 
            print("failed rgb-sub detected @ "..v.text.." for "..v.job)
        elseif #(PlayerInfo.playerCoords - v.coords) < v.range and ((v.job ~= "all" and PlayerInfo.ESX.job.name == v.job and PlayerInfo.ESX.job.grade >= v.job_grade) or v.job == "all") then
            table.insert(markers_current, v)        
        end 
    end 

    --Citizen.Trace("checked for #markers: "..#markers.."\n")
    --Citizen.Trace("Markers: #markers_current: "..#markers_current.." - #markers: "..#markers.."\n")
end)


AddEventHandler("sysTimerTick_0", function()
    while not sys_init_done do
        --debug(sys_debug,"waiting...")
        Wait(500)
    end    
    if timeout_current > 0 then
        return
    end
    for _,marker in pairs(markers_current) do
        local dist = #(PlayerInfo.playerCoords - marker.coords)	        
        local checkdist = 2.0
        DrawMarker(marker.marker, marker.coords - vector3(0.0, 0.0, 0.98), 0.0, 0.0, 0.0, 0, 0.0, 0.0, marker.size,marker.size,marker.size, marker.rgb.r,marker.rgb.g,marker.rgb.b, 100, false, true, 2, true, false, false, false)
        if marker.size > 2.0 then checkdist = marker.size end
        if dist <= checkdist then
            local text = "~b~"..marker.text.."\n"
            for _, functions in pairs(marker.functions) do
                text = text .. "~y~["..string.gsub(GetControlInstructionalButton(0, functions.key, 0), "t_", "").."]~s~ "..functions.text.."\n"
                if IsControlJustReleased(0, functions.key) then
                    timeout_current = timeout
                    functions.func()                        
                end
            end                
            ESX.Game.Utils.DrawText3D(marker.coords, text)
        end        
    end    
end)  