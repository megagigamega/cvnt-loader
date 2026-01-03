-- CVNT SECURE LOADER

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local KEY = getgenv().Key
if not KEY then
    Players.LocalPlayer:Kick("NO KEY PROVIDED")
    return
end

local HWID =
    tostring(game:GetService("RbxAnalyticsService"):GetClientId())

local SCRIPT_ID = "cvnt6453327" -- ТВОЙ script id

local body = HttpService:JSONEncode({
    key = KEY,
    hwid = HWID,
    script_id = SCRIPT_ID
})

local response
pcall(function()
    response = syn.request({
        Url = "http://127.0.0.1:5000/redeem",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = body
    })
end)

if not response then
    Players.LocalPlayer:Kick("API ERROR")
    return
end

local data = HttpService:JSONDecode(response.Body)

if not data.success then
    Players.LocalPlayer:Kick(data.message or "ACCESS DENIED")
    return
end

-- 🚀 ТОЛЬКО ТУТ ПРИХОДИТ СКРИПТ
loadstring(data.script)()
