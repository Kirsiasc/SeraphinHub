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
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local Input = Tab2:Input({
    Title = "WalkSpeed",
    Desc = "Minimum 16 speed",
    Value = "16",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        local speed = tonumber(input)
        if speed and speed >= 16 then
            Humanoid.WalkSpeed = speed
            print("WalkSpeed set to: " .. speed)
        else
            Humanoid.WalkSpeed = 16
            print("⚠️ Invalid input, set to default (16)")
        end
    end
})

local Input = Tab2:Input({
    Title = "Jump Power",
    Desc = "Minimum 50 jump",
    Value = "50",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        local value = tonumber(input)
        if value then
            _G.CustomJumpPower = value
            local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = value
            end
            print("🔼 Jump Power diatur ke: " .. value)
        else
            warn("⚠️ Harus angka, bukan teks!")
        end
    end
})

local Button = Tab2:Button({
    Title = "Reset Jump Power",
    Desc = "Return Jump Power to normal (50)",
    Callback = function()
        _G.CustomJumpPower = 50
        local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
        print("🔄 Jump Power di-reset ke 50")
    end
})

local Player = game:GetService("Players").LocalPlayer
Player.CharacterAdded:Connect(function(char)
    local Humanoid = char:WaitForChild("Humanoid")
    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = _G.CustomJumpPower or 50
end)

Tab2:Button({
    Title = "Reset Speed",
    Desc = "Return speed to normal (16)",
    Callback = function()
        Humanoid.WalkSpeed = 16
        print("WalkSpeed reset ke default (16)")
    end
})

local UserInputService = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer

local Toggle = Tab2:Toggle({
    Title = "Infinite Jump",
    Desc = "activate to use infinite jump",
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

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local character = Player.Character or Player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
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

local Section = Tab3:Section({ 
    Title = "Opsional",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local REMOTE_NAME = "FishCaught"
local TRY_INTERVAL = 1

_G.InstantCatch = false
local _loopRunning = false

local function scanRemotes()
    local remotes = {}

    local function checkContainer(container)
        for _, v in ipairs(container:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                if string.find(string.lower(v.Name), "fish") then
                    table.insert(remotes, v:GetFullName() .. " (" .. v.ClassName .. ")")
                end
            end
        end
    end

    checkContainer(ReplicatedStorage)
    checkContainer(workspace)
    if player and player:FindFirstChild("PlayerGui") then
        checkContainer(player.PlayerGui)
    end

    if #remotes == 0 then
        warn("⚠️ Tidak ada Remote berhubungan dengan 'fish' ditemukan.")
    else
        print("🐟 Remotes ditemukan:")
        for _, r in ipairs(remotes) do
            print(" - " .. r)
        end
    end
end

local function findRemote(name)
    local function search(container)
        for _, v in ipairs(container:GetDescendants()) do
            if v.Name == name and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
                return v
            end
        end
    end

    return search(ReplicatedStorage)
        or search(workspace)
        or (player and player:FindFirstChild("PlayerGui") and search(player.PlayerGui))
end

local function tryFire(remote)
    if not remote then return false, "no remote" end
    local ok, err

    if remote:IsA("RemoteEvent") then
        ok, err = pcall(function() remote:FireServer("Perfect") end)
        if ok then return true end
        ok, err = pcall(function() remote:FireServer() end)
        return ok, err
    elseif remote:IsA("RemoteFunction") then
        ok, err = pcall(function() remote:InvokeServer("Perfect") end)
        if ok then return true end
        ok, err = pcall(function() remote:InvokeServer() end)
        return ok, err
    end

    return false, "unknown type " .. remote.ClassName
end

local ToggleCatch = Tab3:Toggle({
    Title = "Instant Catch",
    Desc = "Get fish straight away",
    Icon = "fish",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        _G.InstantCatch = state

        if state then
            print("✅ Instant Catch ON")
            if _loopRunning then return end
            _loopRunning = true

            task.spawn(function()
                while _G.InstantCatch do
                    local remote = findRemote(REMOTE_NAME)
                    if remote then
                        local success, err = tryFire(remote)
                        if success then
                            print("🎣 Instant catch success!")
                        else
                            warn("❌ error:", err)
                        end
                    else
                        warn("⚠️ Remote '" .. REMOTE_NAME .. "' tidak ditemukan. Jalankan scanner dulu.")
                    end
                    task.wait(TRY_INTERVAL)
                end
                _loopRunning = false
                print("❌ Instant Catch OFF")
            end)
        else
            print("❌ Instant Catch is turned off")
        end
    end
})

local ScanButton = Tab3:Button({
    Title = "Scan Fish Remotes",
    Desc = "Search for remote with the word 'fish'",
    Callback = function()
        scanRemotes()
    end
})

local Tab4 = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

local Section = Tab4:Section({ 
    Title = "Island",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Dropdown = Tab4:Dropdown({
    Title = "Select Location",
    Values = {"Esoteric Island", "Konoha", "Coral Refs", "Enchant Room", "Tropical Grove", "Weather Machine"},
    Callback = function(Value)
        local Locations = {
            ["Esoteric Island"] = Vector3.new(33, 9, 2810),
            ["Konoha"] = Vector3.new(-603, 3, 719),
            ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
            ["Enchant room"] = Vector3.new(3230, -1303, 1401),
            ["Treasure Room"] = Vector3.new(-3600, -267, -1575),
            ["Tropical Grove"] = Vector3.new(-2091, 6, 3703),
            ["Weather Machine"] = Vector3.new(-1508, 6, 1895),
        }

        local Player = game.Players.LocalPlayer
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(Locations[Value])
        end
    end
})

local Section = Tab4:Section({ 
    Title = "fishing spot",
    TextXAlignment = "Left",
    TextSize = 17,
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

local Toggle = Tab5:Toggle({
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

local Colorpicker = Tab5:Colorpicker({
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
