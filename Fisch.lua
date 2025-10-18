local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "Seraphin",
    Icon = "rbxassetid://120248611602330",
    Author = "KirsiaSC | Fisch",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(280, 320),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(180, 0, 255)
})

WindUI:Notify({
    Title = "SeraphinHub Loaded",
    Content = "Fisch loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Infomation",
    Icon = "info",
})

local Section = Tab1:Section({ 
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Button({
    Title = "Discord",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("discord.gg/getseraphin")
        end
    end
})

local Section = Tab1:Section({ 
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Tab2 = Window:Tab({
    Title = "Fishing",
    Icon = "fish-symbol",
})

local Tab3 = Window:Tab({
    Title = "Automatic",
    Icon = "play",
})

local Tab4 = Window:Tab({
    Title = "Shop",
    Icon = "shopping-cart",
})

local Tab5 = Window:Tab({
    Title = "Teleport",
    Icon = "map",
})

local Section = Tab5:Section({ 
    Title = "Location",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Tab6 = Window:Tab({
    Title = "Misc",
    Icon = "layout-grid",
})

local Section = Tab6:Section({
    Title = "Server",
    TextXAlignment = "Left",
    TextSize = 17,
})

Section:Button({
    Title = "Rejoin",
    Desc = "Reconnect to current server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local Player = game.Players.LocalPlayer
        TeleportService:Teleport(PlaceId, Player)
    end
})

Section:Button({
    Title = "Server Hop",
    Desc = "Teleport to a different server",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local Servers = {}
        local success, response = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        end)
        if success and response then
            local data = HttpService:JSONDecode(response)
            for _, v in pairs(data.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(Servers, v.id)
                end
            end
        end
        if #Servers > 0 then
            local randomServer = Servers[math.random(1, #Servers)]
            TeleportService:TeleportToPlaceInstance(PlaceId, randomServer, game.Players.LocalPlayer)
        end
    end
})
