shown = false
local medics = 0
ESX = nil
Citizen.CreateThread(function()


    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(250)
    end
    while(true) do
        Citizen.Wait(3)
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        local blipPos = vector3(Config.x, Config.y, Config.z)
        local dist = #(playerCoords - blipPos)
        DrawMarker(20, blipPos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, true, false, false, false)
        if(dist <= Config.AccessRange and not IsEntityDead(playerPed)) then
            if(IsControlPressed(0, 38) and not shown) then
                local players = {}
                for _, player in ipairs(GetActivePlayers()) do
                    players[_] = GetPlayerServerId(player)
                end
                TriggerServerEvent('TA:GetOnlineMedics', players)
                shown = true
                getNearbyPlys()
            elseif(not shown) then
                ESX.ShowHelpNotification("Press ~INPUT_PICKUP~ to open the menu", true, false)
            end
        end
        
    end
end)

function showStation(show, plys, plysIDs)
    if(medics < Config.MinMedicsToNotShow or Config.MinMedicsToNotShow == 0) then
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
    else
        ESX.ShowNotification("There are/is " .. medics .. " Medic/s online. You can't use the station right now!")
        shown = false
    end
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
    TriggerServerEvent('TA:GetNames', plys, GetActivePlayers())
end

RegisterNetEvent("TA:SendOnlineMedics")
AddEventHandler("TA:SendOnlineMedics", function(meds)
    medics = meds
end)

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
    ESX.ShowAdvancedNotification("Bank Advisor", "Los Santos Centralbank", "You do not have enough money. Have a nice day!", "CHAR_BANK_FLEECA", 1)
end)

RegisterNetEvent("TA:BoughtRevive")
AddEventHandler("TA:BoughtRevive", function()
    ESX.ShowAdvancedNotification("Bank Advisor", "Los Santos Centralbank", "You bought the revive and paid " .. Config.Price .. "$ to the Medical Department. Have a nice day!", "CHAR_BANK_FLEECA", 1)
end)