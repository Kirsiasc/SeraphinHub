local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wind"))()

-- Buat window
local Window = Library:CreateWindow("Seraphin", "mielix | Fish It")

-- Tambahkan background setelah window loaded
coroutine.wrap(function()
    wait(1)
    
    -- Background image
    local bg = Instance.new("ImageLabel")
    bg.Image = "rbxassetid://your_image_id_here"  -- Ganti dengan ID gambar
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    bg.ScaleType = Enum.ScaleType.Crop
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.ZIndex = 0
    bg.Parent = Window.Main
    
    -- Semi-transparent overlay
    local overlay = Instance.new("Frame")
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.7
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.ZIndex = 1
    overlay.Parent = Window.Main
    
    -- Pastikan konten UI di atas background
    for _, v in pairs(Window.Main:GetChildren()) do
        if v:IsA("Frame") or v:IsA("ScrollingFrame") then
            v.ZIndex = 2
        end
    end
end)()

-- Lanjutkan dengan membuat tab dan konten...
local Tab1 = Window:CreateTab("Info")
-- ... rest of your code
