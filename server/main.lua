local QBCore = exports['qb-core']:GetCoreObject()
-- Events

-- RegisterNetEvent('hospital:server:ambulanceAlert', function(text)
--     local src = source
--     local ped = GetPlayerPed(src)
--     local coords = GetEntityCoords(ped)
--     local players = QBCore.Functions.GetQBPlayers()
--     for k,v in pairs(players) do
--         if v.PlayerData.job.name == 'firefighter' and v.PlayerData.job.onduty then
--             TriggerClientEvent('hospital:client:ambulanceAlert', v.PlayerData.source, coords, text)
--         end
--     end
-- end)

-- Callbacks

-- Commands

-- QBCore.Commands.Add('911f', 'Fire Report', {{name='message', help='Message to be sent'}}, false, function(source, args)
-- 	local src = source
-- 	if args[1] then message = table.concat(args, " ") else message = 'Civilian Call' end
--     local ped = GetPlayerPed(src)
--     local coords = GetEntityCoords(ped)
--     local players = QBCore.Functions.GetQBPlayers()
--     for k,v in pairs(players) do
--         if v.PlayerData.job.name == 'firefighter' or v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
--             TriggerClientEvent('hospital:client:ambulanceAlert', v.PlayerData.source, coords, message)
--         end
--     end
-- end)

-- Items