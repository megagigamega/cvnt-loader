local http = game:GetService("HttpService")

local API_URL = "http://185.185.68.56:8080/check_key"

-- 🔑 ключ (пример)
local KEY = getgenv().KEY or "TEST"

-- 🖥️ hwid
local HWID =
    game:GetService("RbxAnalyticsService"):GetClientId()

local body = {
    key = KEY,
    hwid = HWID
}

local response
local success, err = pcall(function()
    response = http:PostAsync(
        API_URL,
        http:JSONEncode(body),
        Enum.HttpContentType.ApplicationJson
    )
end)

if not success then
    warn("API error:", err)
    return
end

local data = http:JSONDecode(response)

if data.status ~= "ok" then
    warn("Access denied:", data.reason)
    return
end

-- ✅ ДОСТУП РАЗРЕШЁН
loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/megagigamega/cvnt-loader/main/mainscript.lua
"
))()
