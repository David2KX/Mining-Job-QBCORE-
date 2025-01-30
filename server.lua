local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('rudar:giveItem')
AddEventHandler('rudar:giveItem', function(itemName, amount)
    local player = QBCore.Functions.GetPlayer(source)  
    if player then
        if player.Functions.AddItem(itemName, amount) then
            TriggerClientEvent('QBCore:Notify', source, "You mined " .. itemName, "success")
        else
            TriggerClientEvent('QBCore:Notify', source, "Not enough space in your inventory!", "error")
        end
    end
end)

RegisterServerEvent('rudar:startMining')
AddEventHandler('rudar:startMining', function(entity)
    local player = QBCore.Functions.GetPlayer(source)  

    if player.Functions.GetItemByName('pickaxe') then
        TriggerClientEvent('rudar:startMining', source, entity)
    else
        TriggerClientEvent('QBCore:Notify', source, "You need a pickaxe!", "error")
    end
end)
