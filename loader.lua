-- CVNT Loader

if getgenv().CVNT_LOADED then return end
getgenv().CVNT_LOADED = true

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

if not getgenv().Key then
    error("Key not found")
end

-- универсальный request
local requestFunc =
    request or
    http_request or
    (syn and syn.request)

if not requestFunc then
    error("HTTP request not supported")
end

local function getHWID()
    local exec = identifyexecutor and identifyexecutor() or "unknown"
    return tostring(Players.LocalPlayer.UserId) .. ":" .. exec
end

local payload = {
    key = getgenv().Key,
    hwid = getHWID()
}

local response = requestFunc({
    Url = "http://185.185.68.56:8080/check_key", -- <-- ТВОЙ IP
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode(payload)
})

if not response or not response.Body then
    error("API not responding")
end

local result = HttpService:JSONDecode(response.Body)

if result.status ~= "ok" then
    error("Key invalid or expired")
end

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/superSigma3131/fg435tyrudrfy/main/main.lua"
))()
