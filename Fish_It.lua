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

local function tpTo(pos)
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = pos
    end
end

local locations = {
    ["Spawn Island"] = CFrame.new(0, 10, 0),
    ["Fishing Shop"] = CFrame.new(150, 10, -50),
    ["Big Lake"] = CFrame.new(-200, 5, 300),
    ["Deep Ocean"] = CFrame.new(600, 20, 1000),
}

for name, cf in pairs(locations) do
    Tab4:Button({
        Title = name,
        Desc = "Teleport ke " .. name,
        Callback = function()
            tpTo(cf)
        end
    })
end

local Tab5 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})


myConfig:Load()
