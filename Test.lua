local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

local titleText = gradient("Seraphin", Color3.new(1, 0.2, 0.2), Color3.new(0.2, 0.5, 1))
local subtitleText = gradient("mielix | Fish It", Color3.new(0.8, 0.8, 0.2), Color3.new(0.2, 0.8, 0.8))

local Tab1 = Window:Tab({
    Title = "Tab Title",
    Icon = "bird",
    Locked = false,
})
