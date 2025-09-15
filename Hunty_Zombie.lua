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
    Author = "KirsiaSC | Hunty Zombie",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(270, 300),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromHex("#9b4dff")
})

WindUI:Notify({
    Title = "SeraphinHub Loaded",
    Content = "UI loaded successfully!",
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
    Title = "Main",
    Icon = "landmark",
})

local Section = Tab2:Section({
    Title = "Lobby",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Players = { "1", "2", "3", "4", "5", "6" }
local Maps = { "Sewers", "School", "Carnaval" }
local Modes = { "Normal", "Hard", "Nightmare" }

_G.SelectedPlayers = 1
_G.SelectedMap = "School"
_G.SelectedMode = "Normal"
_G.AutoJoin = false
_G.JoinRemote = nil

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "FireServer" and self:IsA("RemoteEvent") then
        warn("📡 RemoteEvent detected:", self:GetFullName())
        for i,v in ipairs(args) do
            warn("   Arg["..i.."] =", v)
        end
        if tostring(self):lower():find("create") or tostring(self):lower():find("room") or tostring(self):lower():find("start") then
            _G.JoinRemote = self
            warn("✅ AutoJoin remote saved:", self:GetFullName())
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

local PlayerDropdown = Tab2:Dropdown({
    Title = "Player",
    Values = Players,
    Value = "1",
    Callback = function(option)
        _G.SelectedPlayers = tonumber(option)
    end
})

local MapDropdown = Tab2:Dropdown({
    Title = "Select Map",
    Values = Maps,
    Value = "School",
    Callback = function(option)
        _G.SelectedMap = option
    end
})

local ModeDropdown = Tab2:Dropdown({
    Title = "Select Mode",
    Values = Modes,
    Value = "Normal",
    Callback = function(option)
        _G.SelectedMode = option
    end
})

local ToggleAuto = Tab2:Toggle({
    Title = "Auto Create Room",
    Default = false,
    Callback = function(state)
        _G.AutoJoin = state
        if state then
            task.spawn(function()
                while _G.AutoJoin do
                    if _G.JoinRemote and _G.JoinRemote:IsA("RemoteEvent") then
                        pcall(function()
                            _G.JoinRemote:FireServer({
                                Players = _G.SelectedPlayers,
                                Map = _G.SelectedMap,
                                Mode = _G.SelectedMode
                            })
                            print("✅ Auto Join Request:", _G.SelectedPlayers, _G.SelectedMap, _G.SelectedMode)
                        end)
                    else
                        warn("⚠️ Remote belum ketemu, silakan klik Create Room manual dulu supaya tersimpan.")
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local Tab3 = Window:Tab({
    Title = "Players",
    Icon = "user",
})

local Tab4 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

local Toggle = Tab4:Toggle({
    Title = "AntiAFK",
    Desc = "Prevent Roblox from kicking you when idle",
    Icon = "shield",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")
        local player = game:GetService("Players").LocalPlayer

        task.spawn(function()
            while _G.AntiAFK do
                task.wait(60)
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end)

        if state then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AntiAFK loaded!",
                Text = "Coded By Kirsiasc",
                Button1 = "Okey",
                Duration = 5
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AntiAFK Disabled",
                Text = "Stopped AntiAFK",
                Duration = 3
            })
        end
    end
})

local Toggle = Tab4:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatic reconnect if disconnected",
    Icon = "plug-zap",
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        if state then
            task.spawn(function()
                while _G.AutoReconnect do
                    task.wait(2)
                    local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if reconnectUI then
                        local prompt = reconnectUI:FindFirstChild("promptOverlay")
                        if prompt then
                            local button = prompt:FindFirstChild("ButtonPrimary")
                            if button and button.Visible then
                                firesignal(button.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
        end
    end
})
