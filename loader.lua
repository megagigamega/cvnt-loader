-- ===== CVNT LOADER =====

local KEY = getgenv().Key
local SCRIPT_ID = "cvnt6453327"

if not KEY then
    game:Shutdown()
end

local HttpService = game:GetService("HttpService")
local Analytics = game:GetService("RbxAnalyticsService")

local hwid = Analytics:GetClientId()

local response = request({
    Url = "http://127.0.0.1:3333/redeem",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        key = KEY,
        hwid = hwid,
        script_id = SCRIPT_ID
    })
})

if not response or response.StatusCode ~= 200 then
    game:Shutdown()
end

local data = HttpService:JSONDecode(response.Body)

if not data.success then
    game:Shutdown()
end

loadstring(data.script)()
