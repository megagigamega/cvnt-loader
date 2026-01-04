-- ===== CONFIG =====
local API_URL = "http://185.185.68.56:8080/check_key"
-- ==================

-- проверка ключа
if not getgenv().Key or type(getgenv().Key) ~= "string" then
    warn("[CVNT] Key not provided")
    return
end

local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local hwid = RbxAnalyticsService:GetClientId()

-- определяем http request
local request = syn and syn.request or http_request or request
if not request then
    warn("[CVNT] HTTP request not supported")
    return
end

-- запрос к API
local response = request({
    Url = API_URL,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        key = getgenv().Key,
        hwid = hwid
    })
})

if not response or not response.Body then
    warn("[CVNT] API no response")
    return
end

local data
pcall(function()
    data = HttpService:JSONDecode(response.Body)
end)

if not data or data.status ~= "ok" then
    warn("[CVNT] License error:", data and data.reason or "unknown")
    return
end

print("[CVNT] License OK")

-- ===== ОСНОВНОЙ СКРИПТ =====
-- loadstring(game:HttpGet("URL_ТВОЕГО_СКРИПТА"))()
