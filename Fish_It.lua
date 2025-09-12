local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ Windows gagal dimuat!")
    return
else
    print("✓ WindUI berhasil dimuat!")
end

local Window = WindUI:CreateWindow({
    Title = "SeraphinHub",
    Icon = "monitor",
    Author = "KirsiaSC | Fish It",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromHex("#30ff6a")
})

WindUI:Notify({
    Title = "SeraphinHub Loaded",
    Content = "wait a moment until the UI appears!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
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
            setclipboard("https://discord.gg/wYXXZgmk")
        end
    end
})

local Section = Tab1:Section({ 
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user",
})

local Tab3 = Window:Tab({
    Title = "Main",
    Icon = "gamepad-2",
})

local Tab4 = Window:Tab({
    Title = "Teleport",
    Icon = "telescope",
})

local Dropdown = Tab4:Dropdown({
    Title = "Pilih Lokasi",
    Values = {"Spawn", "Market", "Boat", "Fishing Spot 1", "Fishing Spot 2"},
    Multi = false,
    Callback = function(Value)
        local Locations = {
            ["Spawn"] = Vector3.new(0, 5, 0),
            ["Market"] = Vector3.new(100, 5, -50),
            ["Boat"] = Vector3.new(-200, 5, 300),
            ["Fishing Spot 1"] = Vector3.new(500, 10, -200),
            ["Fishing Spot 2"] = Vector3.new(-700, 5, 150),
        }

        local Player = game.Players.LocalPlayer
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(Locations[Value])
        end
    end
})

local Tab5 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})


myConfig:Load()
