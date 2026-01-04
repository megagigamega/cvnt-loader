local key = getgenv().Key
if not key then
    game.Players.LocalPlayer:Kick("NO KEY")
    return
end

local HttpService = game:GetService("HttpService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

local url = "http://185.185.68.56:5000/redeem"

local body = HttpService:JSONEncode({
    key = key,
    hwid = hwid,
    script = "cvnt6453327"
})

local response = request({
    Url = url,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = body
})

if response.StatusCode ~= 200 then
    game.Players.LocalPlayer:Kick("INVALID KEY")
    return
end

local data = HttpService:JSONDecode(response.Body)

if not data.success then
    game.Players.LocalPlayer:Kick(data.error or "AUTH FAILED")
    return
end

loadstring(data.script)()
