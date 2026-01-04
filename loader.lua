-- CVNT Loader

if getgenv().CVNT_LOADED then
    return
end
getgenv().CVNT_LOADED = true

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

if not getgenv().Key then
    error("Key not found")
end

local function getHWID()
    local exec = identifyexecutor and identifyexecutor() or "unknown"
    return tostring(Players.LocalPlayer.UserId) .. ":" .. exec
end

local data = {
    key = getgenv().Key,
    hwid = getHWID()
}

local response = request({
    Url = "http://ТВОЙ_IP:8080/check_key",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode(data)
})

local result = HttpService:JSONDecode(response.Body)

if result.status ~= "ok" then
    error("Key invalid")
end

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/megagigamega/cvnt-loader/main/mainscript.lua"
))()
