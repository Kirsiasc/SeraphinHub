local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SeraphinHub",
    SubTitle = "Fish It | v0.0.0.1",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "gamepad-2" }),
    Players = Window:AddTab({ Title = "Playes", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    List = Window:AddTab({ Title = "List", Icon = "list" })
}

local Section = TabMain:AddSection("Infomation")

TabMain:AddButton({
    Title = "Discord Invite",
    Description = "Join SeraphinHub Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/wYXXZgmk")
            print("✅ Link Discord disalin ke clipboard!")
        else
            print("📌 Copy manual: https://discord.gg/wYXXZgmk")
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "SeraphinHub",
                Text = "Link Discord: https://discord.gg/wYXXZgmk",
                Duration = 5
            })
        end
    end
})
