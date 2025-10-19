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

local Locations = {
    ["Ancient"] = Vector3.new(6056, 195, 282),
    ["Angler Baby"] = Vector3.new(-13466, -11036, 175),
    ["Archive"] = Vector3.new(-3158, -755, 2214),
    ["Atlantis"] = Vector3.new(-4266, -604, 1830),
    ["Boss Arena"] = Vector3.new(-4356, -11093, 7153),
    ["Boss Queue"] = Vector3.new(-4351, -11187, 7405),
    ["Bosspool"] = Vector3.new(-2374, -11187, 7122),
    ["Bunker 2"] = Vector3.new(1792, -328, -2390),
    ["Crafting"] = Vector3.new(-3160, -746, 1684),
    ["Crook's Hallow"] = Vector3.new(24, 137, -11535),
    ["Ethereal Puzzle"] = Vector3.new(-4123, -603, 1820),
    ["GrandReef"] = Vector3.new(-3566, 150, 535),
    ["Moosewood"] = Vector3.new(381, 134, 243),
    ["Podium 1"] = Vector3.new(-3464, -2259, 3832),
    ["Podium 2"] = Vector3.new(-826, -3275, -710),
    ["Podium 3"] = Vector3.new(-13489, -11051, 134),
    ["Podium 4"] = Vector3.new(-4334, -11183, 3196),
    ["Poseindo Puzzle"] = Vector3.new(-3683, -547, 1012),
    ["Roslit Submarine"] = Vector3.new(-1365, 177, 432),
    ["Sunkenpanel"] = Vector3.new(-4616, -597, 1843),
    ["Zeus Puzzle"] = Vector3.new(-4297, -674, 2353),
}

local SelectedLocation = nil
local TweenService = game:GetService("TweenService")

local LocationDropdown = Section:Dropdown({
    Title = "Select Location",
    Values = (function()
        local keys = {}
        for name in pairs(Locations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedLocation = Value
    end
})

Section:Button({
    Title = "Teleport to Location",
    Callback = function()
        if SelectedLocation and Locations[SelectedLocation] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local randomDelay = math.random(1, 3)
            local tweenInfo = TweenInfo.new(randomDelay, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local tween = TweenService:Create(Player.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(Locations[SelectedLocation] + Vector3.new(math.random(-2, 2), 5, math.random(-2, 2)))})
            tween:Play()
            task.wait(randomDelay)
        end
    end
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
