ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
ESX = obj
end)

RegisterNetEvent("TA:GetNames")
AddEventHandler("TA:GetNames", function(players)
    plys = {}
    plysIDs = {}
    src = source
    for i = 1, #players do
        table.insert(plys, i, GetPlayerName(players[i]))
        table.insert(plysIDs, i, players[i])
    end
    TriggerClientEvent("TA_revivestation:SendArr", src, plys, plysIDs)
end)

RegisterNetEvent('TA:TriggerAmbulanceRevive')
AddEventHandler('TA:TriggerAmbulanceRevive', function(playerToRevive, srcID)
    src = source
    xPlayer = ESX.GetPlayerFromId(src)
    if(xPlayer.getMoney() >= Config.Price) then
        xPlayer.removeMoney(Config.Price)
        ply = playerToRevive
        TriggerClientEvent('esx_ambulancejob:revive', ply)
        TriggerClientEvent("TA:BoughtRevive", src)
    elseif(xPlayer.getAccount('bank').money >= Config.Price) then
        xPlayer.removeAccountMoney('bank', Config.Price)
        ply = playerToRevive
        TriggerClientEvent('esx_ambulancejob:revive', ply)
        TriggerClientEvent("TA:BoughtRevive", src)
    else
        TriggerClientEvent("TA:NoMoney", src)
    end
end)
