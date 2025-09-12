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
    Author = "KirsiaSC | Fish It | v0.0.0.1",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
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

local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user",
})

local Tab3 = Window:Tab({
    Title = "Main",
    Icon = "gamepad-2",
})

local Tab4 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

local Tab5 = Window:Tab({
    Title = "Misc",
    Icon = "list",
})


myConfig:Load()
