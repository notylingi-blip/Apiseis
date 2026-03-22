-- [[ XYN HUB VISUAL OG V8.0 - ULTIMATE UI ]] --
--

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- [ 1. CONFIGURATION ] --
local Targets = {
    ["MYTHIC"] = "Mythic",
    ["BRAINROT GOD"] = "Brainrot God",
    ["SECRET"] = "Secret"
}
local Replacement = "OG"
local IsActive = false
local OriginalTexts = {} -- Tempat nyimpen tulisan asli buat di-restore
local CurrentLabelConnections = {}

-- [ 2. UI CONSTRUCTION (NEUMORPHIC GLASS) ] --
--
local screenGui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
screenGui.Name = "XynHubUltimateOG"
screenGui.ResetOnSpawn = false

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 240, 0, 130)
main.Position = UDim2.new(0.5, -120, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Gelap transparan
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true

-- Menambahkan Glassmorphism Efect (UICorner)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- Outline Glossy Putih
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 1
stroke.Transparency = 0.5
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Efek Shadow
local shadow = Instance.new("ImageLabel", main)
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Image = "rbxassetid://1316045217" -- Shadow Asset
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Title Bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.new(0,0,0)
titleBar.BackgroundTransparency = 0.8
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Xyn Hub - Visual OG" --
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Status Label
local statusLabel = Instance.new("TextLabel", main)
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0.4, 0)
statusLabel.Text = "System: Idle..."
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10

-- [ 3. ADVANCED TOGGLE SWITCH SETUP (NEON STYLE) ] --
--
local toggleFrame = Instance.new("Frame", main)
toggleFrame.Name = "ToggleSwitch"
toggleFrame.Size = UDim2.new(0, 60, 0, 28)
toggleFrame.Position = UDim2.new(0.5, -30, 0.65, 0)
toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Default Abbu-abu
toggleFrame.BorderSizePixel = 0
local corner = Instance.new("UICorner", toggleFrame)
corner.CornerRadius = UDim.new(1, 0) -- Full Rounded

-- Outline Switch
local toggleStroke = Instance.new("UIStroke", toggleFrame)
toggleStroke.Color = Color3.fromRGB(255, 255, 255)
toggleStroke.Thickness = 1
toggleStroke.Transparency = 0.8
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Slider Button
local slider = Instance.new("Frame", toggleFrame)
slider.Name = "Slider"
slider.Size = UDim2.new(0, 24, 0, 24)
slider.Position = UDim2.new(0, 2, 0.5, -12) -- Default Kiri
slider.BackgroundColor3 = Color3.new(1, 1, 1)
local sliderCorner = Instance.new("UICorner", slider)
sliderCorner.CornerRadius = UDim.new(1, 0) -- Full Rounded

-- Menambahkan Neon GlowEffect
local neonGlow = Instance.new("UIStroke", toggleFrame)
neonGlow.Name = "NeonGlow"
neonGlow.Color = Color3.fromRGB(0, 255, 0)
neonGlow.Thickness = 0 -- Default mati
neonGlow.Transparency = 0.5
neonGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Label Switch (ON/OFF)
local switchLabel = Instance.new("TextLabel", main)
switchLabel.Size = UDim2.new(0, 30, 0, 28)
switchLabel.Position = UDim2.new(0.5, -60, 0.65, 0)
switchLabel.Text = "OFF"
switchLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
switchLabel.BackgroundTransparency = 1
switchLabel.Font = Enum.Font.GothamBold
switchLabel.TextSize = 11

-- Invisible Klik Area
local toggleBtn = Instance.new("TextButton", toggleFrame)
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = ""

-- [ 4. LOGIC & ANIMATION ENGINES ] --
local function ApplyGoldGradient(label)
    if label:FindFirstChild("XynGradientActive") then return end
    local gradValue = Instance.new("BoolValue", label)
    gradValue.Name = "XynGradientActive"
    
    local t = 0
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        if not IsActive or not label or not label.Parent then 
            if label then label.TextColor3 = Color3.new(1,1,1) end -- Reset warna kalo off
            if gradValue then gradValue:Destroy() end
            CurrentLabelConnections[label] = nil
            conn:Disconnect()
            return 
        end
        t = t + dt * 1.5
        local gold, yellow, white = Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 255)
        local sine = math.sin(t)
        local finalColor = (sine < -0.33 and white:Lerp(yellow, (sine + 1) / 0.67)) or (sine < 0.33 and yellow:Lerp(gold, (sine + 0.33) / 0.66)) or gold:Lerp(white, (sine - 0.33) / 0.67)
        label.TextColor3 = finalColor
    end)
    CurrentLabelConnections[label] = conn
end

-- [ 5. DYNAMIC UI TWEENING ] --
--
local function TweenSwitch(state)
    local frameColor = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    local sliderPos = state and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
    local glowThick = state and 2 or 0
    local labelTextColor = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(150, 150, 150)
    local labelText = state and "ON" or "OFF"
    
    local info = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    TweenService:Create(toggleFrame, info, {BackgroundColor3 = frameColor}):Play()
    TweenService:Create(slider, info, {Position = sliderPos}):Play()
    TweenService:Create(neonGlow, info, {Thickness = glowThick}):Play()
    
    switchLabel.Text = labelText
    TweenService:Create(switchLabel, info, {TextColor3 = labelTextColor}):Play()
end

-- [ 6. CORE STEALER LOGIC ] --
--
local function ToggleVisual(state)
    IsActive = state
    TweenSwitch(state) -- Jalankan animasi switch
    
    if state then
        statusLabel.Text = "System: STEALING OG..."
        TweenService:Create(statusLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 215, 0)}):Play()
        print("XYN HUB: OG STEALER ON")
    else
        statusLabel.Text = "System: RESTORING ORIGINALS..."
        TweenService:Create(statusLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        print("XYN HUB: RESTORING ORIGINAL TEXTS...")
        -- Balikin tulisan ke semula
        for label, originalText in pairs(OriginalTexts) do
            if label and label.Parent then
                label.Text = originalText
                label.TextColor3 = Color3.new(1, 1, 1) -- Reset warna standar
            end
        end
        OriginalTexts = {} -- Kosongkan database
        task.wait(0.5)
        statusLabel.Text = "System: Idle..."
    end
end

-- Scanner Loop
task.spawn(function()
    while true do
        if IsActive then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TextLabel") then
                    local textRaw = string.upper(v.Text)
                    for targetKey, originalName in pairs(Targets) do
                        if string.find(textRaw, targetKey) and v.Text ~= Replacement then
                            -- Simpan tulisan asli sebelum diganti
                            OriginalTexts[v] = v.Text
                            v.Text = Replacement
                            ApplyGoldGradient(v)
                        end
                    end
                end
            end
        end
        task.wait(1.5)
    end
end)

-- [ 7. SWITCH INTERACTION ] --
toggleBtn.MouseButton1Click:Connect(function() 
    ToggleVisual(not IsActive) -- Ganti state
end)

-- [ 8. ADVANCED DRAG SYSTEM ] --
--
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position - dragStart).X, startPos.Y.Scale, startPos.Y.Offset + (input.Position - dragStart).Y)
    end
end)
UIS.InputEnded:Connect(function() dragging = false end)
