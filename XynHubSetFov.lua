local uis = game:GetService("UserInputService")
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ UI DESIGN: XYN HUB - FOV TOUCH OPTIMIZED ]] --
local sg = Instance.new("ScreenGui")
sg.Name = "XynHub_FOV_Fix"
sg.ResetOnSpawn = false
sg.Parent = lp:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 110)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -55)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true -- Biar gak tembus klik ke game
mainFrame.Parent = sg

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "XYN HUB - FOV"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- SLIDER AREA (Area ini khusus buat FOV, gak bisa buat narik UI)
local sliderArea = Instance.new("TextButton")
sliderArea.Size = UDim2.new(0.9, 0, 0, 40)
sliderArea.Position = UDim2.new(0.05, 0, 0, 40)
sliderArea.BackgroundTransparency = 1
sliderArea.Text = ""
sliderArea.AutoButtonColor = false
sliderArea.Parent = mainFrame

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(1, 0, 0, 6)
sliderBack.Position = UDim2.new(0, 0, 0.5, -3)
sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBack.BorderSizePixel = 0
sliderBack.Parent = sliderArea
Instance.new("UICorner", sliderBack)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBack
Instance.new("UICorner", sliderFill)

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 18, 0, 18) -- Knob lebih gede biar gampang disentuh
knob.Position = UDim2.new(0.5, -9, 0.5, -9)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.Parent = sliderBack
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

local valLabel = Instance.new("TextLabel")
valLabel.Size = UDim2.new(1, 0, 0, 20)
valLabel.Position = UDim2.new(0, 0, 0, 85)
valLabel.BackgroundTransparency = 1
valLabel.Text = "FOV: 70"
valLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
valLabel.TextSize = 12
valLabel.Font = Enum.Font.GothamMedium
valLabel.Parent = mainFrame

-- LOGIKA SLIDER (Gak bakal keganggu Drag UI)
local isSliding = false

local function updateSlider(input)
    local mousePos = input.Position.X
    local sliderPos = sliderBack.AbsolutePosition.X
    local sliderSize = sliderBack.AbsoluteSize.X
    local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
    
    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    knob.Position = UDim2.new(percent, -9, 0.5, -9)
    
    local fovVal = math.floor(30 + (percent * 90))
    camera.FieldOfView = fovVal
    valLabel.Text = "FOV: " .. tostring(fovVal)
end

sliderArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = true
        updateSlider(input)
    end
end)

uis.InputChanged:Connect(function(input)
    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input)
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = false
    end
end)

-- LOGIKA DRAG UI (Hanya bisa ditarik lewat Title/Background, bukan area Slider)
local dragging, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if not isSliding and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

uis.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

