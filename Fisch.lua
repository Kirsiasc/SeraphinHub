local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LoadingScreen = Instance.new("ScreenGui")
LoadingScreen.Parent = game.CoreGui
LoadingScreen.Name = "SeraphinLoading"
LoadingScreen.IgnoreGuiInset = true

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.Parent = LoadingScreen

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 0.1, 0)
Title.Position = UDim2.new(0.25, 0, 0.4, 0)
Title.BackgroundTransparency = 1
Title.Text = "KirsiaSC artificial bypass"
Title.TextColor3 = Color3.fromRGB(180, 0, 255)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Background

local DiscordLink = Instance.new("TextLabel")
DiscordLink.Size = UDim2.new(0.5, 0, 0.05, 0)
DiscordLink.Position = UDim2.new(0.25, 0, 0.5, 0)
DiscordLink.BackgroundTransparency = 1
DiscordLink.Text = "discord.gg/getseraphin"
DiscordLink.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordLink.TextScaled = true
DiscordLink.Font = Enum.Font.SourceSans
DiscordLink.Parent = Background

local function showLoading()
    Background.BackgroundTransparency = 1
    Title.TextTransparency = 1
    DiscordLink.TextTransparency = 1
    LoadingScreen.Enabled = true
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
    TweenService:Create(Background, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(Title, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(DiscordLink, tweenInfo, {TextTransparency = 0}):Play()
    task.wait(3)
    local fadeOut = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    TweenService:Create(Background, fadeOut, {BackgroundTransparency = 1}):Play()
    TweenService:Create(Title, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(DiscordLink, fadeOut, {TextTransparency = 1}):Play()
    task.wait(1)
    LoadingScreen.Enabled = false
end

showLoading()

local Window = WindUI:CreateWindow({
    Title = "Seraphin",
    Icon = "rbxassetid://120248611602330",
    Author = "KirsiaSC | Fisch",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.new(0, 280, 0, 320),
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
    Icon = "bell"
})

local Tab1 = Window:Tab({
    Title = "Information",
    Icon = "info"
})

local Section = Tab1:Section({
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab1:Button({
    Title = "Discord",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("discord.gg/getseraphin")
            WindUI:Notify({
                Title = "Copied!",
                Content = "Discord link copied to clipboard.",
                Duration = 2
            })
        end
    end
})

local Section = Tab1:Section({
    Title = "Updates",
    TextXAlignment = "Left",
    TextSize = 17,
    Content = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

local Tab2 = Window:Tab({
    Title = "Fishing",
    Icon = "fish-symbol"
})

local Section = Tab2:Section({
    Title = "Auto Fishing",
    TextXAlignment = "Left",
    TextSize = 17
})

local isAutoFishing = false
Section:Toggle({
    Title = "Auto Fish",
    Desc = "Automatically cast and reel fish",
    Default = false,
    Callback = function(Value)
        isAutoFishing = Value
        if isAutoFishing then
            WindUI:Notify({
                Title = "Auto Fishing",
                Content = "Auto fishing started!",
                Duration = 3
            })
            spawn(function()
                while isAutoFishing and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") do
                    local tool = Player.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("RemoteEvent") then
                        tool.RemoteEvent:FireServer("Cast")
                        task.wait(math.random(2, 4))
                        tool.RemoteEvent:FireServer("Reel")
                    end
                    task.wait(math.random(5, 8))
                end
            end)
        else
            WindUI:Notify({
                Title = "Auto Fishing",
                Content = "Auto fishing stopped!",
                Duration = 3
            })
        end
    end
})

local Tab3 = Window:Tab({
    Title = "Automatic",
    Icon = "play"
})

local Section = Tab3:Section({
    Title = "Auto Features",
    TextXAlignment = "Left",
    TextSize = 17
})

local isAutoSell = false
Section:Toggle({
    Title = "Auto Sell",
    Desc = "Automatically sell caught fish",
    Default = false,
    Callback = function(Value)
        isAutoSell = Value
        if isAutoSell then
            WindUI:Notify({
                Title = "Auto Sell",
                Content = "Auto selling started!",
                Duration = 3
            })
            spawn(function()
                while isAutoSell and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") do
                    local sellRemote = ReplicatedStorage:FindFirstChild("SellFish")
                    if sellRemote then
                        sellRemote:FireServer()
                    end
                    task.wait(math.random(10, 15))
                end
            end)
        else
            WindUI:Notify({
                Title = "Auto Sell",
                Content = "Auto selling stopped!",
                Duration = 3
            })
        end
    end
})

local Tab4 = Window:Tab({
    Title = "Shop",
    Icon = "shopping-cart"
})

local Section = Tab4:Section({
    Title = "Shop Features",
    TextXAlignment = "Left",
    TextSize = 17
})

Section:Button({
    Title = "Open Shop",
    Desc = "Teleport to shop location",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local shopPos = Vector3.new(-3160, -746, 1684) -- Crafting/Shop location
            local targetPos = shopPos + Vector3.new(math.random(-3, 3), 5, math.random(-3, 3))
            local distance = (Player.Character.HumanoidRootPart.Position - targetPos).Magnitude
            local tweenDuration = math.clamp(distance / 1000, 3, 6)
            local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local tween = TweenService:Create(Player.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})
            tween:Play()
            WindUI:Notify({
                Title = "Teleporting",
                Content = "Moving to Shop",
                Duration = tweenDuration
            })
            task.wait(tweenDuration)
        else
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "Player character not found!",
                Duration = 3
            })
        end
    end
})

local Tab5 = Window:Tab({
    Title = "Teleport",
    Icon = "map"
})

local Section = Tab5:Section({
    Title = "Location",
    TextXAlignment = "Left",
    TextSize = 17
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
    ["Zeus Puzzle"] = Vector3.new(-4297, -674, 2353)
}

local SelectedLocation = nil
local lastTeleportTime = 0
local teleportCooldown = 10

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
        print("Selected location: " .. tostring(Value))
    end
})

Section:Button({
    Title = "Teleport to Location",
    Callback = function()
        if os.time() - lastTeleportTime < teleportCooldown then
            WindUI:Notify({
                Title = "Teleport Cooldown",
                Content = "Please wait " .. tostring(teleportCooldown - (os.time() - lastTeleportTime)) .. " seconds!",
                Duration = 3
            })
            return
        end
        if not Player.Character then
            warn("Error: Player character not found!")
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "Player character not found!",
                Duration = 3
            })
            return
        end
        if not Player.Character:FindFirstChild("HumanoidRootPart") then
            warn("Error: HumanoidRootPart not found!")
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "HumanoidRootPart not found!",
                Duration = 3
            })
            return
        end
        if not SelectedLocation or not Locations[SelectedLocation] then
            warn("Error: No location selected or invalid location!")
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "No location selected or invalid location!",
                Duration = 3
            })
            return
        end
        local targetPos = Locations[SelectedLocation] + Vector3.new(math.random(-3, 3), 5, math.random(-3, 3))
        local distance = (Player.Character.HumanoidRootPart.Position - targetPos).Magnitude
        local tweenDuration = math.clamp(distance / 1000, 3, 6)
        local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local tween = TweenService:Create(Player.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})
        print("Teleporting to: " .. SelectedLocation .. " at " .. tostring(targetPos))
        tween:Play()
        WindUI:Notify({
            Title = "Teleporting",
            Content = "Moving to " .. SelectedLocation,
            Duration = tweenDuration
        })
        lastTeleportTime = os.time()
        task.wait(tweenDuration)
    end
})

local Tab6 = Window:Tab({
    Title = "Misc",
    Icon = "layout-grid"
})

local Section = Tab6:Section({
    Title = "Server",
    TextXAlignment = "Left",
    TextSize = 17
})

Section:Button({
    Title = "Rejoin",
    Desc = "Reconnect to current server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        TeleportService:Teleport(PlaceId, Player)
        WindUI:Notify({
            Title = "Rejoining",
            Content = "Reconnecting to current server...",
            Duration = 3
        })
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
            return game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
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
            TeleportService:TeleportToPlaceInstance(PlaceId, randomServer, Player)
            WindUI:Notify({
                Title = "Server Hopping",
                Content = "Teleporting to a different server...",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Server Hop Failed",
                Content = "No available servers found!",
                Duration = 3
            })
        end
    end
})

local Section = Tab6:Section({
    Title = "Players",
    TextXAlignment = "Left",
    TextSize = 17
})

local isAntiAFK = false
Section:Toggle({
    Title = "Anti AFK",
    Desc = "Prevents being kicked for idling",
    Default = false,
    Callback = function(Value)
        isAntiAFK = Value
        if isAntiAFK then
            WindUI:Notify({
                Title = "Anti-AFK",
                Content = "Anti-AFK enabled!",
                Duration = 3
            })
            spawn(function()
                while isAntiAFK and Player.Character do
                    UserInputService:SendMouseMovement(Vector2.new(math.random(-10, 10), math.random(-10, 10)))
                    task.wait(math.random(30, 60))
                end
            end)
        else
            WindUI:Notify({
                Title = "Anti-AFK",
                Content = "Anti-AFK disabled!",
                Duration = 3
            })
        end
    end
})

local isAutoReconnect = false
Section:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatically reconnects on disconnect",
    Default = false,
    Callback = function(Value)
        isAutoReconnect = Value
        if isAutoReconnect then
            WindUI:Notify({
                Title = "Auto Reconnect",
                Content = "Auto reconnect enabled!",
                Duration = 3
            })
            game:BindToClose(function()
                if isAutoReconnect then
                    local TeleportService = game:GetService("TeleportService")
                    local PlaceId = game.PlaceId
                    TeleportService:Teleport(PlaceId, Player)
                end
            end)
        else
            WindUI:Notify({
                Title = "Auto Reconnect",
                Content = "Auto reconnect disabled!",
                Duration = 3
            })
        end
    end
})
