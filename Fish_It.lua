local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end

if not success or not WindUI then
    warn("⚠️ WindUI failed to load!")
    return
else
    print("✓ WindUI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "SeraphinHub",
    Icon = "monitor",
    Author = "Fish It | v0.0.0.1"
    Folder = "Seraphin_Hub",
    Transparent = true
})

local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
})

Tab1:AddButton({
    Title = "Hello",
    Description = "Test button",
    Callback = function()
        print("Button clicked!")
    end
})


myConfig:Load()
