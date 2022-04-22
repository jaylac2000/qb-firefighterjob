# qb-firefighter

Rework of [qb-ambulancejob](https://github.com/qbcore-framework/qb-ambulancejob) to make a firefighter job

Feel free to make optimization and PRs, however it runs smoothly on my server

Only things left behind:

- on/off duty
- vehicle spawner
- helicopter spawner
- armory / stash
- stations blips

Note: my config is setup to gabz-firedept and another one

>>> YOU WILL NEED TO EDIT THE CONFIG TO YOUR NEEDS

# ADD TO YOUR qb-core/shared/jobs.lua
```
	['firefighter'] = {
		label = 'Firefighter',
		defaultDuty = true,
		offDutyPay = true,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 500
            },
            ['1'] = {
                name = 'Firefighter',
                payment = 600
            },
			['2'] = {
                name = 'Shift Leader',
                payment = 800
            },
			['2'] = {
                name = 'Lieutenant',
                payment = 850
            },
            ['4'] = {
                name = 'Captain',
                payment = 900
            },
            ['5'] = {
                name = 'Asst. Chief',
                isboss = true,
                payment = 950
            },
			['6'] = {
                name = 'Chief',
				isboss = true,
                payment = 1000
            },
        },
	},
```

OPTIONAL EMS PERMISSIONS .. ADD TO YOUR qb-ambulancejob/server/main.lua

replace these revivep with
```
QBCore.Commands.Add("revivep", Lang:t('info.revive_player'), {}, false, function(source, args)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "firefighter" then
		TriggerClientEvent("hospital:client:RevivePlayer", src)
	else
		TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_ems'), "error")
	end
end)
```

replace status with
```
QBCore.Commands.Add("status", Lang:t('info.check_health'), {}, false, function(source, args)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "firefighter" then
		TriggerClientEvent("hospital:client:CheckStatus", src)
	else
		TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_ems'), "error")
	end
end)
```

replace heal with
```
QBCore.Commands.Add("heal", Lang:t('info.heal_player'), {}, false, function(source, args)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "firefighter" then
		TriggerClientEvent("hospital:client:TreatWounds", src)
	else
		TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_ems'), "error")
	end
end)
```


## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core) (Required)
- [qb-phone](https://github.com/qbcore-framework/qb-phone) (Required)
- [qb-target](https://github.com/BerkieBb/qb-target) (Optional)
- [PolyZone](https://github.com/mkafrin/PolyZone) (Required)

# Server.cfg Convar Update
- Global DrawTextUi Option
```
setr UseTarget false
``` 

- Global Target Option
```
setr UseTarget true
```
