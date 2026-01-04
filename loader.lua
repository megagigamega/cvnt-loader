-- =========================
-- CVNT LOADER
-- =========================

-- защита от повторного запуска
if getgenv().CVNT_LOADED then
    return
end
getgenv().CVNT_LOADED = true

-- сервисы
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- проверка ключа
if not getgenv().Key then
    error("CVNT: Key not found. Use getgenv().Key = \"YOUR_KEY\"")
end

-- универсальный request (очень важно)
local requestFunc =
    request or
    http_request or
    (syn and syn.request)

if not requestFunc then
    error("CVNT: Your executor does not support HTTP requests")
end

-- HWID (пока простой, позже усилим)
local function getHWID()
    local executor = identifyexecutor and identifyexecutor() or "unknown"
    local userId = Players.LocalPlayer.UserId
    return tostring(userId) .. ":" .. executor
end

-- данные для API
local payload = {
    key = getgenv().Key,
    hwid = getHWID()
}

-- запрос к API
local response = requestFunc({
    Url = "http://185.185.68.56:8080/check_key", -- ТВОЙ IP
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode(payload)
})

-- защита от пустого ответа
if not response or not response.Body then
    error("CVNT: API not responding")
end

-- парсим JSON
local result
local success, err = pcall(function()
    result = HttpService:JSONDecode(response.Body)
end)

if not success then
    error("CVNT: Invalid API response")
end

-- проверка статуса
if result.status ~= "ok" then
    local reason = result.reason or "unknown"
    error("CVNT: Access denied (" .. reason .. ")")
end

-- загрузка основного скрипта
local MAIN_SCRIPT_URL = "https://raw.githubusercontent.com/superSigma3131/fg435tyrudrfy/main/main.lua"

local scriptSource = game:HttpGet(MAIN_SCRIPT_URL)
loadstring(scriptSource)()
