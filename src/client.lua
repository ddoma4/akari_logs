local function createWebhookLog(title, description)
    TriggerServerEvent("akari_logs:createWebhookLog", title, description)
end

local function createConsoleLog(args)
    TriggerServerEvent("akari_logs:createConsoleLog", args)
end

exports("akari_logs", createWebhookLog)
exports("akari_logs", createConsoleLog)

TriggerEvent('chat:addSuggestion', '/getplayer', 'Checks the player', {
    { name="PlayerID", help="The server Id of the player that the check is for" }
})