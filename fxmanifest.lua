fx_version 'cerulean'
game 'gta5'

description 'QB-FirefighterJob'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
	'client/main.lua',
	'client/job.lua',
}

server_script 'server/main.lua'

lua54 'yes'