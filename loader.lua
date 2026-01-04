-- ================== CVNT LOADER ==================

-- ===== НАСТРОЙКИ =====
local API_URL = "http://185.185.68.56:8080/check_key"
local MAIN_URL = "https://raw.githubusercontent.com/megagigamega/cvnt-loader/main/mainscript.lua"

-- ===== ПРОВЕРКА КЛЮЧА =====
if not getgenv().Key or type(getgenv().Key) ~= "string" then
    error("CVNT: Key not provided")
end

-- ===== HWID =====
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local function getHWID()
    local lp = Players.LocalPlayer
    local data = {
        user = lp.UserId,
        place = game.PlaceId,
        job = game.JobId
    }
    return HttpService:JSONEncode(data)
end

local payload = HttpService:JSONEncode({
    key = getgenv().Key,
    hwid = getHWID()
})

-- ===== ЗАПРОС К API =====
local response
local ok, err = pcall(function()
    response = request({
        Url = API_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = payload
    })
end)

if not ok or not response then
    error("CVNT: API request failed")
end

if response.StatusCode ~= 200 then
    error("CVNT: API error (" .. tostring(response.StatusCode) .. ")")
end

local body = HttpService:JSONDecode(response.Body)

if body.status ~= "ok" then
    error("CVNT: " .. (body.reason or "access denied"))
end

-- ===== ЗАГРУЗКА ОСНОВНОГО СКРИПТА =====
loadstring(game:HttpGet(MAIN_URL))()

-- ================== END ==================
