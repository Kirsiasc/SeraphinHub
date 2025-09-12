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

local Dropdown = Tab4:Dropdown({
    Title = "Pilih Lokasi",
    Desc = "Teleport ke area yang kamu mau",
    Values = {"Spawn", "Shop", "Pulau Gurita", "Fishing Spot"},
    Callback = function(value)
        if value == "Spawn" then
            TeleportTo(Vector3.new(0, 5, 0))
        elseif value == "Shop" then
            TeleportTo(Vector3.new(120, 5, -50))
        elseif value == "Pulau Gurita" then
            TeleportTo(Vector3.new(-300, 10, 400))
        elseif value == "Fishing Spot" then
            TeleportTo(Vector3.new(200, 5, 200))
        end
    end
})

local Tab5 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})


myConfig:Load()
