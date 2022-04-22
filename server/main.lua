local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('firejob:server:fireAlert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = QBCore.Functions.GetQBPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'firefighter' and v.PlayerData.job.onduty then
            TriggerClientEvent('firejob:client:fireAlert', v.PlayerData.source, coords, text)
        end
    end
end)

-- Commands

QBCore.Commands.Add('911f', Lang:t('info.fire_report'), {{name = 'message', help = Lang:t('info.message_sent')}}, false, function(source, args)
	local src = source
	if args[1] then message = table.concat(args, " ") else message = Lang:t('info.civ_call') end
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = QBCore.Functions.GetQBPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'firefighter' and v.PlayerData.job.onduty then
            TriggerClientEvent('firejob:client:fireAlert', v.PlayerData.source, coords, message)
        end
    end
end)