local QBCore = exports['qb-core']:GetCoreObject()

-- Server-side function to give an item to the player
RegisterServerEvent('rudar:giveItem')
AddEventHandler('rudar:giveItem', function(itemName, amount)
    local player = QBCore.Functions.GetPlayer(source)  -- Get the player who made the request
    if player then
        -- Check if the player has enough inventory space for the item
        if player.Functions.AddItem(itemName, amount) then
            TriggerClientEvent('QBCore:Notify', source, "You mined " .. itemName, "success")
        else
            TriggerClientEvent('QBCore:Notify', source, "Not enough space in your inventory!", "error")
        end
    end
end)

-- Server-side function that starts the mining process (when the player interacts with the prop)
RegisterServerEvent('rudar:startMining')
AddEventHandler('rudar:startMining', function(entity)
    local player = QBCore.Functions.GetPlayer(source)  -- Get the player who made the request

    -- Check if the player has a pickaxe before starting the mining
    if player.Functions.GetItemByName('pickaxe') then
        -- If the player has a pickaxe, send a notification that they can mine
        TriggerClientEvent('rudar:startMining', source, entity)
    else
        -- If the player doesn't have a pickaxe, send a notification that they need one
        TriggerClientEvent('QBCore:Notify', source, "You need a pickaxe!", "error")
    end
end)
