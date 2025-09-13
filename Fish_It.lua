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

Tab1:Section({ 
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

Tab1:Section({ 
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user",
})

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

Tab2:Input({
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
            _G.CustomWalkSpeed = speed
            print("WalkSpeed set to: " .. speed)
        else
            Humanoid.WalkSpeed = 16
            _G.CustomWalkSpeed = 16
            print("⚠️ Invalid input, set to default (16)")
        end
    end
})

Tab2:Input({
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
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = value
            print("🔼 Jump Power diatur ke: " .. value)
        else
            warn("⚠️ Harus angka, bukan teks!")
        end
    end
})

Tab2:Button({
    Title = "Reset Jump Power",
    Desc = "balikkan Jump Power ke default (50)",
    Callback = function()
        _G.CustomJumpPower = 50
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = 50
        print("🔄 Jump Power di-reset ke 50")
    end
})

Tab2:Button({
    Title = "Reset Speed",
    Desc = "Return speed to normal (16)",
    Callback = function()
        _G.CustomWalkSpeed = 16
        Humanoid.WalkSpeed = 16
        print("WalkSpeed reset ke default (16)")
    end
})

Player.CharacterAdded:Connect(function(char)
    local Hum = char:WaitForChild("Humanoid")
    Hum.UseJumpPower = true
    Hum.JumpPower = _G.CustomJumpPower or 50
    Hum.WalkSpeed = _G.CustomWalkSpeed or 16
end)

Tab2:Toggle({
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

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local Hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if Hum then
            Hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Tab3 = Window:Tab({
    Title = "Main",
    Icon = "landmark",
})

Tab3:Section({ 
    Title = "Main",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab3:Toggle({
    Title = "Auto Fishing",
    Desc = "Auto Fishing V1",
    Icon = "fish",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        _G.AutoFishing = state
        local rs = game:GetService("ReplicatedStorage")

        task.spawn(function()
            while _G.AutoFishing do
                task.wait(0.5)
                pcall(function() rs.Remotes.Cast:FireServer() end)
                task.wait(0.5)
                pcall(function() rs.Remotes.FishCaught:FireServer("Perfect") end)
                task.wait(0.5)
                pcall(function() rs.Remotes.Reel:FireServer() end)
                task.wait(1)
            end
        end)
    end
})

Tab3:Toggle({
    Title = "Auto Cast",
    Desc = "Automatic fishing rod throw",
    Icon = "anchor",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        _G.AutoCast = state
        local rs = game:GetService("ReplicatedStorage")

        task.spawn(function()
            while _G.AutoCast do
                task.wait(2)
                pcall(function() rs.Remotes.Cast:FireServer() end)
            end
        end)
    end
})

Tab3:Toggle({
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
                pcall(function() rs.Remotes.Reel:FireServer() end)
            end
        end)
    end
})

Tab3:Toggle({
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
                pcall(function() rs.Remotes.FishCaught:FireServer("Perfect") end)
            end
        end)
    end
})

local Tab4 = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

Tab4:Dropdown({
    Title = "Select Location",
    Values = {"Spawn", "Konoha", "Coral Reefs", "Volcano", "Sysyphus Statue"},
    Callback = function(Value)
        local Locations = {
            ["Spawn"] = Vector3.new(33, 9, 2810),
            ["Konoha"] = Vector3.new(-603, 3, 719),
            ["Coral Reefs"] = Vector3.new(-2855, 47, 1996),
            ["Volcano"] = Vector3.new(-632, 55, 197),
            ["Sysyphus Statue"] = Vector3.new(-3693,-136,-1045),
        }

        local Plr = game.Players.LocalPlayer
        if Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            Plr.Character.HumanoidRootPart.CFrame = CFrame.new(Locations[Value])
        end
    end
})

local Tab5 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

Tab5:Colorpicker({
    Title = "UI Color",
    Desc = "Customize UI highlight color",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color) 
        print("Background color: " .. tostring(color))
    end
})


local player = game.Players.LocalPlayer
local thumb = game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
Tab2:AddImage({
    Title = player.DisplayName .. " (@" .. player.Name .. ")",
    Desc = "UserId: " .. player.UserId,
    Image = thumb,
    ImageSize = Vector2.new(100,100)
})
