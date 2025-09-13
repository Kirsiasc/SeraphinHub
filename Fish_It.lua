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
    Author = "KirsiaSC | Fish It",
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
            setclipboard("https://discord.gg/cdsRC8XFyR")
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

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Safe function untuk ambil Humanoid
local function GetHumanoid()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:FindFirstChildOfClass("Humanoid")
end

-- Input untuk WalkSpeed
local Input = Tab2:Input({
    Title = "WalkSpeed",
    Desc = "Minimum 16 speed",
    Value = "16",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input)
        local speed = tonumber(input)
        local humanoid = GetHumanoid()
        if humanoid then
            if speed and speed >= 16 then
                humanoid.WalkSpeed = speed
                print("WalkSpeed set to: " .. speed)
            else
                humanoid.WalkSpeed = 16
                print("⚠️ Invalid input, set to default (16)")
            end
        else
            warn("⚠️ Humanoid tidak ditemukan!")
        end
    end
})

-- Input untuk Jump Power
local Input = Tab2:Input({
    Title = "Jump Power",
    Desc = "Minimum 50 jump",
    Value = "50",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        local value = tonumber(input)
        local humanoid = GetHumanoid()
        if humanoid and value then
            _G.CustomJumpPower = value
            humanoid.UseJumpPower = true
            humanoid.JumpPower = value
            print("🔼 Jump Power diatur ke: " .. value)
        else
            warn("⚠️ Harus angka valid dan Humanoid ada!")
        end
    end
})

-- Tombol reset Jump Power
local Button = Tab2:Button({
    Title = "Reset Jump Power",
    Desc = "Balikkan Jump Power ke default (50)",
    Callback = function()
        _G.CustomJumpPower = 50
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
            print("🔄 Jump Power di-reset ke 50")
        else
            warn("⚠️ Humanoid tidak ditemukan!")
        end
    end
})

-- Update JumpPower otomatis saat respawn
Player.CharacterAdded:Connect(function(char)
    local Humanoid = char:WaitForChild("Humanoid")
    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = _G.CustomJumpPower or 50
end)

-- Tombol reset WalkSpeed
Tab2:Button({
    Title = "Reset Speed",
    Desc = "Return speed to normal (16)",
    Callback = function()
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = 16
            print("WalkSpeed reset ke default (16)")
        else
            warn("⚠️ Humanoid tidak ditemukan!")
        end
    end
})

-- Toggle Infinite Jump
local Toggle = Tab2:Toggle({
    Title = "Infinite Jump",
    Desc = "Activate to use infinite jump",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        _G.InfiniteJump = state
        if state then
            print("✅ Infinite Jump Aktif")
        else
            print("❌ Infinite Jump Nonaktif")
        end
    end
})

-- Handle JumpRequest untuk Infinite Jump
local UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Tab3 = Window:Tab({
    Title = "Main",
    Icon = "landmark",
})

local Section = Tab3:Section({ 
    Title = "Main",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Toggle = Tab3:Toggle({
    Title = "Auto Reel",
    Desc = "Automatic fishing reel",
    Icon = "hook",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        _G.AutoReel = state
        local rs = game:GetService("ReplicatedStorage")

        task.spawn(function()
            while _G.AutoReel do
                task.wait(1)
                pcall(function()
                    rs.Remotes.Reel:FireServer()
                end)
            end
        end)
    end
})

local Toggle = Tab3:Toggle({
    Title = "Instant Catch",
    Desc = "Get fish straight away",
    Icon = "fish",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        _G.InstantCatch = state
        local rs = game:GetService("ReplicatedStorage")

        task.spawn(function()
            while _G.InstantCatch do
                task.wait(1)
                pcall(function()
                    rs.Remotes.FishCaught:FireServer("Perfect")
                end)
            end
        end)
    end
})

local Tab4 = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

local Dropdown = Tab4:Dropdown({
    Title = "Select Location",
    Values = {"Spawn", "Konoha", "Coral Refs", "Volcano", "Sysyphus Statue"},
    Callback = function(Value)
        local Locations = {
            ["Spawn"] = Vector3.new(33, 9, 2810),
            ["Konoha"] = Vector3.new(-603, 3, 719),
            ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
            ["Volcano"] = Vector3.new(-632, 55, 197),
            ["Sysyphus Statue"] = Vector3.new(-3693,-136,-1045),
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

local Toggle = Tab5:Toggle({
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

local Colorpicker = Tab3:Colorpicker({
    Title = "Colorpicker",
    Desc = "Background Colorpicker",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color) 
        print("Background color: " .. tostring(color))
    end
})


myConfig:Load()
