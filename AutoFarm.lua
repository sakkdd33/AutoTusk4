getgenv().waitUntilCollect = 0.5 -- Change this if you get kicked often; affects item farm speed
getgenv().sortOrder = "Desc" -- "Desc" for less players, "Asc" for more
getgenv().lessPing = false -- Enable for lower ping servers (may cause data errors)
getgenv().FarmUntilGetShiny = true -- Keep farming until you get a shiny
getgenv().HopServers = true -- Auto server-hop after farming
getgenv().SwapWhenTusk = true -- Switch slots if you get Tusk 4 or Tusk 4 Shiny
getgenv().webhook = "" -- Webhook for logging (optional)

-- Function to hop servers
local function hopServer()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. getgenv().sortOrder .. "&limit=100"))
    for _, server in ipairs(servers.data) do
        if server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
            break
        end
    end
end

-- Function to collect items
local function collectItems()
    for _, item in pairs(game.Workspace:GetChildren()) do
        if item:IsA("Part") and item:FindFirstChild("TouchInterest") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame
            task.wait(getgenv().waitUntilCollect)
        end
    end
end

-- Main farming loop
while getgenv().FarmUntilGetShiny do
    collectItems()
    if getgenv().HopServers then
        hopServer()
    end
    task.wait(5) -- Wait before restarting the loop
end
