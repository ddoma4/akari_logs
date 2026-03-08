SetConvar("akari_logs", "v1")

local resource = GetCurrentResourceName()

local function PrettyPrint(args)
    print(string.format("[LOGS]: %s", args))
end

local function Notify(src, args)
    TriggerClientEvent("esx:showNotification", src, "Akari's Logs", "info", 1500, args, "top-left")
end

local function IsAdmin(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return false end

    for _, v in ipairs(Config.AdminGroups) do
        if xPlayer.getGroup() == v then
            return true
        end
    end

    Notify(src, Lang[Config.TxLang].no_perm)
    return false
end

local function AdminNotify(msg)
    for _, id in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then
            for _, group in ipairs(Config.AdminGroups) do
                if xPlayer.getGroup() == group then
                    TriggerClientEvent("esx:showNotification", id, "Akari's Logs", "info", 1500, msg, "top-left")
                end
            end
        end
    end
end

local function SendtoWebhook(embed)
    if not Config.WebhookURL or Config.WebhookURL == "" then return end

    PerformHttpRequest(
        Config.WebhookURL,
        function() end,
        "POST",
        json.encode({
            username = string.format("Akari's Logs - %s", Config.ServerName),
            embeds = embed
        }),
        { ["Content-Type"] = "application/json" }
    )
end

AddEventHandler("onResourceStart", function(res)
    if res ~= resource then return end

    if Config.LogToConsole then
        PrettyPrint(Lang[Config.TxLang].logs_started)
    end
end)

AddEventHandler("esx:playerLoaded", function(playerId, xPlayer, isNew)
    local name = GetPlayerName(playerId)
    local identifier = GetPlayerIdentifierByType(playerId, Config.Identifier)

    if Config.Logs.join then
        if Config.LogToConsole then
            PrettyPrint(string.format(Lang[Config.TxLang].player_join, name))
        end

        if Config.LogToWebhook then
            SendtoWebhook({
                {
                    title = string.format(Lang[Config.TxLang].player_join, name),
                    description = string.format(Lang[Config.TxLang].player_join_desc, identifier, playerId)
                }
            })
        end

        if Config.AllowJoinMsg then
            AdminNotify(string.format(Lang[Config.TxLang].player_join, name))
        end
    end

    if isNew and Config.Logs.is_new then
        if Config.LogToConsole then
            PrettyPrint(string.format(Lang[Config.TxLang].new_player_join, name))
        end

        if Config.LogToWebhook then
            SendtoWebhook({
                {
                    title = string.format(Lang[Config.TxLang].new_player_join, name),
                    description = string.format(Lang[Config.TxLang].player_join_desc, identifier, playerId)
                }
            })
        end
    end
end)

AddEventHandler("playerDropped", function()
    local playerId = source
    local name = GetPlayerName(playerId)
    local identifier = GetPlayerIdentifierByType(playerId, Config.Identifier)

    if Config.Logs.quit then
        if Config.LogToConsole then
            PrettyPrint(string.format(Lang[Config.TxLang].player_quit, name))
        end

        if Config.LogToWebhook then
            SendtoWebhook({
                {
                    title = string.format(Lang[Config.TxLang].player_quit, name),
                    description = string.format(Lang[Config.TxLang].player_quit_desc, identifier, playerId)
                }
            })
        end

        if Config.AllowQuitMsg then
            AdminNotify(string.format(Lang[Config.TxLang].player_quit, name))
        end
    end
end)

AddEventHandler("esx:setJob", function(src, job, lastJob)
    if not Config.Logs.setjob then return end

    local name = GetPlayerName(src)

    if Config.LogToConsole then
        PrettyPrint(string.format(Lang[Config.TxLang].setjob, name))
    end

    if Config.LogToWebhook then
        SendtoWebhook({
            {
                title = string.format(Lang[Config.TxLang].setjob, name),
                description = string.format(
                    Lang[Config.TxLang].setjob_desc,
                    job.name .. " - " .. job.grade,
                    lastJob.name .. " - " .. lastJob.grade
                )
            }
        })
    end
end)

AddEventHandler("onResourceStart", function(res)
    if not Config.Logs.resource_start then return end

    if Config.LogToConsole then
        PrettyPrint(string.format(Lang[Config.TxLang].resource_start, res))
    end

    if Config.LogToWebhook then
        SendtoWebhook({
            {
                title = string.format(Lang[Config.TxLang].resource_start, res)
            }
        })
    end
end)

AddEventHandler("onResourceStop", function(res)
    if not Config.Logs.resource_stop then return end

    if Config.LogToConsole then
        PrettyPrint(string.format(Lang[Config.TxLang].resource_stop, res))
    end

    if Config.LogToWebhook then
        SendtoWebhook({
            {
                title = string.format(Lang[Config.TxLang].resource_stop, res)
            }
        })
    end
end)

RegisterNetEvent("esx:onPlayerDeath")
AddEventHandler("esx:onPlayerDeath", function(data)
    local src = source
    local name = GetPlayerName(src)

    if data.killerServerId then
        local killer = GetPlayerName(data.killerServerId)

        if Config.Logs.kill then
            if Config.LogToConsole then
                PrettyPrint(string.format(Lang[Config.TxLang].kill, name, killer))
            end

            if Config.LogToWebhook then
                SendtoWebhook({
                    {
                        title = string.format(Lang[Config.TxLang].kill, name, killer)
                    }
                })
            end
        end
    else
        if Config.Logs.death then
            if Config.LogToConsole then
                PrettyPrint(string.format(Lang[Config.TxLang].death, name))
            end

            if Config.LogToWebhook then
                SendtoWebhook({
                    {
                        title = string.format(Lang[Config.TxLang].death, name)
                    }
                })
            end
        end
    end
end)

AddEventHandler("esx:onAddInventoryItem", function(src, itemName, itemCount)
    if not Config.Logs.item_add then return end

    local name = GetPlayerName(src)

    if Config.LogToConsole then
        PrettyPrint(string.format(Lang[Config.TxLang].item_add, name, itemCount, itemName))
    end

    if Config.LogToWebhook then
        SendtoWebhook({
            {
                title = string.format(Lang[Config.TxLang].item_add, name, itemCount, itemName)
            }
        })
    end
end)

AddEventHandler("esx:onRemoveInventoryItem", function(src, itemName, itemCount)
    if not Config.Logs.item_remove then return end

    local name = GetPlayerName(src)

    if Config.LogToConsole then
        PrettyPrint(string.format(Lang[Config.TxLang].item_remove, itemCount, itemName, name))
    end

    if Config.LogToWebhook then
        SendtoWebhook({
            {
                title = string.format(Lang[Config.TxLang].item_remove, itemCount, itemName, name)
            }
        })
    end
end)

RegisterCommand("getplayer", function(src, args)
    local target = tonumber(args[1])
    if not target then return end

    if not IsAdmin(src) then return end

    local xTarget = ESX.GetPlayerFromId(target)
    if not xTarget then return end

    local targetGroup = xTarget.getGroup()
    local job = xTarget.getJob()
    local targetJob = string.format("%s - %s", job.name, job.grade)
    local targetName = xTarget.getName()

    Notify(src, Lang[Config.TxLang].data_sent_to_wh)

    PrettyPrint(string.format(Lang[Config.TxLang].info_request, GetPlayerName(src), GetPlayerName(target)))

    SendtoWebhook({
        {
            title = string.format(Lang[Config.TxLang].info_request, GetPlayerName(src), GetPlayerName(target)),
            description = string.format(
                Lang[Config.TxLang].requested_data,
                GetPlayerIdentifierByType(target, Config.Identifier),
                targetGroup,
                targetJob,
                targetName
            )
        }
    })
end)

RegisterNetEvent("akari_logs:createWebhookLog", function(title, description)
    SendtoWebhook({
        {
            title = title,
            description = description
        }
    })
end)

RegisterNetEvent("akari_logs:createConsoleLog", function(args)
    PrettyPrint(args)

end)

