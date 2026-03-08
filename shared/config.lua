Config = {
    ServerName = GetConvar("sv_projectname", "Exapmle"),
    TxLang = GetConvar("locale", "en-EN"),
    Identifier = GetConvar("esx:identifier", "license"),

    AllowQuitMsg = false, -- Sends a message to admins on the server when a player quits
    AllowJoinMsg = false, -- Sends a message to admins when a player joins
    LogToConsole = true, -- Logs into tx console
    LogToWebhook = true, -- Logs into the given webhook
    AdminBypass = true, -- Bypasses cheat key presses for admins

    AdminGroups = { -- ESX Groups
        "owner",
        "developer",
        "management",
        "administrator",
        "moderator",
        "trial-moderator"
    },

    Logs = {
        join = true, -- Logs player joins
        quit = true, -- Logs player quits
        is_new = true, -- Logs if a player is new on the server
        setjob = true, -- Logs player's job changes
        resource_start = true, -- Logs started resources
        resource_stop = true, -- Logs stopped resources
        resource_restart = true, -- Logs restarted resources
        possible_cheat_key = true, -- Logs is a player pressed a cheat key
        kill = true, -- Logs if a player kills a player
        death = true, -- Logs all player deaths
        item_add = true, -- Logs added items
        item_remove = true, -- Logs removed items
    },

    CheatKeys = {
        166, -- F5
        167, -- F6
        168, -- F7
        170, -- F9
        56,  -- F10
        57,  -- F11
        344, -- F12
        121, -- Insert
        178, -- Delete
        10,  -- PageUp
        11,  -- PageDown
        172, -- Arrow Up
        173, -- Arrow Down
        174, -- Arrow Left
        175, -- Arrow Right
        96,  -- Numpad 0
        97,  -- Numpad 1
        98,  -- Numpad 2
        99,  -- Numpad 3
        100, -- Numpad 4
        101, -- Numpad 5
        102, -- Numpad 6
        103, -- Numpad 7
        104, -- Numpad 8
        105, -- Numpad 9
        200, -- PAUSE / ESC
    }

}
