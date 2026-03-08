fx_version "cerulean"
game "gta5"

author "Akari01"
description "Log system for ESX servers!"
version "1.1.2"

shared_scripts {
    "@es_extended/imports.lua",
    "shared/config.lua",
    "shared/lang.lua"
}
server_scripts {
    "src/server.lua",
    "shared/server.lua"
}
client_scripts {
    "src/client.lua"
}

dependencies {
    "es_extended",
    "esx_notify"

}
