shown = false

ESX = nil
Citizen.CreateThread(function()


    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(250)
    end
    
    while(true) do
        Citizen.Wait(3)
        if(shown) then
            DisableControlAction(0, 1, shown) -- Disable pan
            DisableControlAction(0, 2, shown) -- Disable tilt
            DisableControlAction(0, 24, shown) -- Attack
            DisableControlAction(0, 257, shown) -- Attack 2
            DisableControlAction(0, 25, shown) -- Aim
            DisableControlAction(0, 263, shown) -- Melee Attack 1
            DisableControlAction(0, 32, shown) -- W
            DisableControlAction(0, 34, shown) -- A
            DisableControlAction(0, 31, shown) -- S
            DisableControlAction(0, 30, shown) -- D
    
            DisableControlAction(0, 45, shown) -- Reload
            DisableControlAction(0, 22, shown) -- Jump
            DisableControlAction(0, 44, shown) -- Cover
            DisableControlAction(0, 37, shown) -- Select Weapon
            DisableControlAction(0, 23, shown) -- Also 'enter'?
    
            DisableControlAction(0, 288, shown) -- Disable phone
            DisableControlAction(0, 289, shown) -- Inventory
            DisableControlAction(0, 170, shown) -- Animations
            DisableControlAction(0, 167, shown) -- Job
    
            DisableControlAction(0, 0, shown) -- Disable changing view
            DisableControlAction(0, 26, shown) -- Disable looking behind
            DisableControlAction(0, 73, shown) -- Disable clearing animation
            DisableControlAction(2, 199, shown) -- Disable pause screen
    
            DisableControlAction(0, 59, shown) -- Disable steering in vehicle
            DisableControlAction(0, 71, shown) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, shown) -- Disable reversing in vehicle
    
            DisableControlAction(2, 36, shown) -- Disable going stealth
    
            DisableControlAction(0, 47, shown) -- Disable weapon
            DisableControlAction(0, 264, shown) -- Disable melee
            DisableControlAction(0, 257, shown) -- Disable melee
            DisableControlAction(0, 140, shown) -- Disable melee
            DisableControlAction(0, 141, shown) -- Disable melee
            DisableControlAction(0, 142, shown) -- Disable melee
            DisableControlAction(0, 143, shown) -- Disable melee
            DisableControlAction(0, 75, shown) -- Disable exit vehicle
            DisableControlAction(27, 75, shown) -- Disable exit vehicle
        end

        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        local blipPos = vector3(Config.x, Config.y, Config.z)

        local dist = #(playerCoords - blipPos)
        DrawMarker(20, blipPos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, true, false, false, false)
        if(dist <= Config.AccessRange and not IsEntityDead(playerPed)) then
            if(IsControlPressed(0, 38) and not shown) then
                shown = true
                getNearbyPlys()
            elseif(not shown) then
                showHelpMsg("Press ~INPUT_PICKUP~ to open the menu", 3)
            end
        end
        
    end
end)

function showStation(show, plys, plysIDs)
    plysList = plys
    plysId = plysIDs
    shown = show
    SetNuiFocus(shown, shown)
    SendNUIMessage({
        type = "ui", 
        status = shown,
        players = plysList,
        ids = plysId,
        price = Config.Price
    })
end



function showNot(image, title, subtitle, text)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(text);
	SetNotificationMessage(image, image, false, 0, title, subtitle);
	DrawNotification(false, true);
end


function showHelpMsg(text, duration)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, duration)

end

function getNearbyPlys()
    plys = {}
    for _, player in ipairs(GetActivePlayers()) do
        local blipPos = vector3(Config.x, Config.y, Config.z)
        local plyPosGet = GetEntityCoords(GetPlayerPed(player))

        if(#(plyPosGet - blipPos) <= Config.ReviveRange and IsEntityDead(GetPlayerPed(player))) then
            table.insert(plys, _, GetPlayerServerId(player))
        end
    end
    TriggerServerEvent('TA:GetNames', plys)
end

RegisterNetEvent("TA_revivestation:SendArr")
AddEventHandler("TA_revivestation:SendArr", function(plys, ids)
    showStation(true, plys, ids)
end)


RegisterNUICallback("exit", function()
    showStation(false, {}, {})
end)

RegisterNUICallback("reviveply", function(data)
    showStation(false, {}, {})
    TriggerServerEvent('TA:TriggerAmbulanceRevive', data.ply, GetPlayerServerId(PlayerPedId()))
end)


RegisterNetEvent("TA:NoMoney")
AddEventHandler("TA:NoMoney", function()
    showNot("CHAR_BANK_FLEECA", "Bank Advisor", "Los Santos Centralbank", "You do not have enough money. Have a nice day!")
end)

RegisterNetEvent("TA:BoughtRevive")
AddEventHandler("TA:BoughtRevive", function()
    showNot("CHAR_BANK_FLEECA", "Bank Advisor", "Los Santos Centralbank", "You bought the revive and paid " .. Config.Price .. "$ to the Medical Department. Have a nice day!")
end)