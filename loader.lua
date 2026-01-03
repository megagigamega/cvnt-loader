-- CVNT Loader (Seliware compatible)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

if not getgenv().Key then
    Players.LocalPlayer:Kick("NO KEY")
    return
end

if not http_request then
    Players.LocalPlayer:Kick("Executor not supported")
    return
end

local HWID =
    game:GetService("RbxAnalyticsService"):GetClientId()

local response = http_request({
    Url = "http://127.0.0.1:5000/redeem",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        key = getgenv().Key,
        hwid = HWID
    })
})

if not response or response.StatusCode ~= 200 then
    Players.LocalPlayer:Kick("API ERROR")
    return
end

local data = HttpService:JSONDecode(response.Body)

if not data.ok then
    Players.LocalPlayer:Kick(data.error or "ACCESS DENIED")
    return
end

-- 🔒 Грузим РЕАЛЬНЫЙ скрипт ТОЛЬКО ПОСЛЕ ПРОВЕРКИ
loadstring(game:HttpGet(data.script_url))()
