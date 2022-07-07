fx_version 'cerulean'
game 'gta5'

name "terra_revivestation"
description "A simple Revivestation made by karlupo."
author "karlupo"
version "1.0.0"

shared_scripts {
	'config.lua',
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua'
}

ui_page {
	'html/index.html'
}

files {
	'html/*.*',
	'html/styles/*.*',
	"html/logo.png"
}
