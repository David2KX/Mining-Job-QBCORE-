local QBCore = exports['qb-core']:GetCoreObject()

local miningProps = {}

-- Function to create props at the location
function CreateMiningProps()
    local miningCoords = Config.MiningLocation -- Coordinates from config.lua

    for i = 1, 10 do  -- Create 10 props at the same location
        local offset = math.random(-Config.MiningRadius, Config.MiningRadius)  -- Random offset to spread the props within the radius
        local x = miningCoords.x + offset
        local y = miningCoords.y + offset
        local z = miningCoords.z

        -- Using only prop_rock_2_a
        local propModel = 'prop_rock_2_a'

        -- Create the prop
        local prop = CreateObject(GetHashKey(propModel), x, y, z, true, true, true)
        SetEntityAsMissionEntity(prop, true, true)  -- Mark the prop as a mission, meaning it cannot be destroyed
        SetEntityInvincible(prop, true)  -- Set the prop as invincible
        FreezeEntityPosition(prop, true)  -- Freeze the prop so it can't move

        -- Add qb-target interaction on the prop
        exports['qb-target']:AddTargetEntity(prop, {
            options = {
                {
                    event = "rudar:startMining",  -- Trigger mining event
                    icon = "fas fa-pickaxe",
                    label = "Mine",
                    action = function(entity)
                        -- Check if the player has a pickaxe
                        if not HasPickaxe() then
                            TriggerEvent('QBCore:Notify', "You need a pickaxe to mine!", "error")
                            return
                        end

                        -- Start mining
                        TriggerServerEvent("rudar:startMining", entity)
                    end
                }
            },
            distance = 2.5  -- The distance at which the player can interact with the prop
        })

        -- Add the prop to the table for later use
        table.insert(miningProps, {prop = prop, coords = vector3(x, y, z)})
    end
end

-- Function to check if the player has a pickaxe
function HasPickaxe()
    local player = QBCore.Functions.GetPlayerData()
    for _, item in pairs(player.items) do
        if item.name == "pickaxe" then
            return true
        end
    end
    return false
end

-- Function to move the prop to a new position
function MoveMiningProp()
    local newCoords = vector3(
        Config.MiningLocation.x + math.random(-Config.MiningRadius, Config.MiningRadius),
        Config.MiningLocation.y + math.random(-Config.MiningRadius, Config.MiningRadius),
        Config.MiningLocation.z
    )

    local propModel = 'prop_rock_2_a'  -- Only prop_rock_2_a
    local prop = CreateObject(GetHashKey(propModel), newCoords.x, newCoords.y, newCoords.z, true, true, true)

    SetEntityAsMissionEntity(prop, true, true)
    SetEntityInvincible(prop, true)
    FreezeEntityPosition(prop, true)

    exports['qb-target']:AddTargetEntity(prop, {
        options = {
            {
                event = "rudar:startMining",
                icon = "fas fa-pickaxe",
                label = "Mine",
                action = function(entity)
                    if not HasPickaxe() then
                        TriggerEvent('QBCore:Notify', "You need a pickaxe to mine!", "error")
                        return
                    end
                    
                    TriggerServerEvent("rudar:startMining", entity)
                end
            }
        },
        distance = 2.5
    })
end

-- Start the function to create props
CreateMiningProps()

-- Notify the player that mining has started
RegisterNetEvent('rudar:startMining', function(entity)
    local playerPed = PlayerPedId()

    -- Load animation
    RequestAnimDict("melee@hatchet@streamed_core")
    while not HasAnimDictLoaded("melee@hatchet@streamed_core") do
        Citizen.Wait(100)
    end

    -- Play the mining animation
    TaskPlayAnim(playerPed, "melee@hatchet@streamed_core", "plyr_rear_takedown_b", 8.0, -8.0, -1, 2, 0, false, false, false)

    -- Start the progress bar
    exports['progressbar']:Progress({
        name = "mining_task",
        duration = 3000, -- Mining duration 3 seconds
        label = "Mining Rock...",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = true,
            disableCombat = true,
        },
        animation = {
            animDict = "melee@hatchet@streamed_core",
            anim = "plyr_rear_takedown_b",
            flags = 49,
        },
        prop = {
            model = 'prop_tool_pickaxe',  -- Pickaxe model
            bone = 57005,
            coords = vector3(0.15, 0.03, 0.05),
            rotation = vector3(0.0, 0.0, 0.0),
        }
    }, function(cancelled)
        if not cancelled then
            local randomItem = Config.MiningItems[math.random(1, #Config.MiningItems)]
            TriggerServerEvent("rudar:giveItem", randomItem.name, randomItem.amount)
            TriggerEvent('QBCore:Notify', "You mined " .. randomItem.label, "success")
        else
            TriggerEvent('QBCore:Notify', "Mining interrupted!", "error")
        end
        
        -- Delete the prop after mining is complete
        DeleteEntity(entity)

        -- Move the prop to a new location
        MoveMiningProp()

        -- Stop the animation
        StopAnimTask(playerPed, "melee@hatchet@streamed_core", "plyr_rear_takedown_b", 1.0)
    end)
end)

-- BLIP 
-- Add a blip to specific coordinates
Citizen.CreateThread(function()
    -- Define coordinates
    local x, y, z = 8672.25, -1548.61, 20.50

    -- Create the blip at the given coordinates
    local blip = AddBlipForCoord(x, y, z)

    -- Define the blip appearance (you can change the type and color)
    SetBlipSprite(blip, 1) -- Blip type, 1 is the standard marker
    SetBlipColour(blip, 2) -- Blip color, 2 is green
    SetBlipScale(blip, 1.0) -- Blip size

    -- Add a name to the blip (will show on the map)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Miner Job")
    EndTextCommandSetBlipName(blip)
end)



