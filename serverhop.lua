local HttpService = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local player = game.Players.LocalPlayer
local servers = {}

local req = syn and syn.request or http and http.request or http_request or request
local function getServers()
    local cursor = ""
    while true do
        local response = req({
            Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. cursor
        })
        local body = HttpService:JSONDecode(response.Body)
        for _, server in pairs(body.data) do
            if server.playing < server.maxPlayers then
                table.insert(servers, server.id)
            end
        end
        if not body.nextPageCursor then break end
        cursor = body.nextPageCursor
    end
end

getServers()
if #servers > 0 then
    TPS:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
end
