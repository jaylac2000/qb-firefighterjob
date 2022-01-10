# qb-firefighterjob

I took [qb-ambulancejob](https://github.com/qbcore-framework/qb-ambulancejob) and turned it to this to make a firefighter job.

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