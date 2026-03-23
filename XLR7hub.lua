-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- XLR7 HUB - LAGGER (REBRANDED VERSION)
-- BASE: NOVA HUB / CXYRO HUB
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local isLagging = false
local speedActive = false
local packetMultiplier = 29
local walkSpeedVal = 56 
local jumpPowerVal = 75 

local uuid = "d80e2217-36b8-4bdc-9a46-2281c6f70b28"
local target
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name ~= "friendmain" and v.Name ~= "ping" then
        target = v
        break
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "XLR7_Lagger_Gui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 340)
main.Position = UDim2.new(0.5, -140, 0.4, -170)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Draggable = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(2, 4, 12)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 45, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 4, 12))
})
bgGrad.Rotation = 45
bgGrad.Parent = main

task.spawn(function()
    while true do
        local t = TweenService:Create(bgGrad, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(0, 1)})
        t:Play()
        t.Completed:Wait()
        local t2 = TweenService:Create(bgGrad, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(0, -1)})
        t2:Play()
        t2.Completed:Wait()
    end
end)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2.5
stroke.Color = Color3.fromRGB(0, 180, 255)
stroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 55)
header.BackgroundTransparency = 1
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "XLR7<font color='#00F2FF'>HUB</font> - LAGGER"
title.RichText = true
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = header

local pingDisplay = Instance.new("TextLabel")
pingDisplay.Size = UDim2.new(0, 80, 0, 20)
pingDisplay.Position = UDim2.new(0.6, 0, 0.5, -10)
pingDisplay.Text = ":ping 0"
pingDisplay.TextColor3 = Color3.fromRGB(0, 240, 255)
pingDisplay.Font = Enum.Font.Code
pingDisplay.TextSize = 13
pingDisplay.BackgroundTransparency = 1
pingDisplay.Parent = header

task.spawn(function()
    while task.wait(0.5) do
        pingDisplay.Text = ":ping " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end
end)

local foldBtn = Instance.new("TextButton")
foldBtn.Size = UDim2.new(0, 28, 0, 28)
foldBtn.Position = UDim2.new(1, -38, 0, 14)
foldBtn.BackgroundColor3 = Color3.new(0, 0, 0)
foldBtn.BackgroundTransparency = 0.5
foldBtn.Text = "−"
foldBtn.TextColor3 = Color3.new(1, 1, 1)
foldBtn.Font = Enum.Font.GothamBold
foldBtn.TextSize = 18
foldBtn.Parent = header
Instance.new("UICorner", foldBtn)

local isFolded = false
foldBtn.MouseButton1Click:Connect(function()
    isFolded = not isFolded
    local goalHeight = isFolded and 55 or 340
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, goalHeight)}):Play()
    foldBtn.Text = isFolded and "+" or "−"
end)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -60)
content.Position = UDim2.new(0, 0, 0, 60)
content.BackgroundTransparency = 1
content.Parent = main

local function createModule(name, yPos, callback, min, max, default, sliderCallback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.9, 0, 0, 95)
    card.Position = UDim2.new(0.05, 0, 0, yPos)
    card.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    card.BackgroundTransparency = 0.85
    card.Parent = content
    Instance.new("UICorner", card)
   
    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Color3.fromRGB(0, 150, 255)
    cStroke.Transparency = 0.6
    cStroke.Parent = card

    local modName = Instance.new("TextLabel")
    modName.Size = UDim2.new(0.6, 0, 0, 30)
    modName.Position = UDim2.new(0.05, 0, 0, 5)
    modName.Text = name:upper()
    modName.TextColor3 = Color3.new(1, 1, 1)
    modName.Font = Enum.Font.GothamBold
    modName.TextSize = 12
    modName.TextXAlignment = Enum.TextXAlignment.Left
    modName.BackgroundTransparency = 1
    modName.Parent = card

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 65, 0, 26)
    toggle.Position = UDim2.new(1, -75, 0, 10)
    toggle.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    toggle.Text = "READY"
    toggle.TextColor3 = Color3.fromRGB(0, 200, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 10
    toggle.Parent = card
    Instance.new("UICorner", toggle)

    toggle.MouseButton1Click:Connect(function()
        local state = callback()
        toggle.Text = state and "ON" or "READY"
        TweenService:Create(toggle, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(15, 20, 30),
            TextColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(0, 200, 255)
        }):Play()
    end)

    local sLabel = Instance.new("TextLabel")
    sLabel.Size = UDim2.new(0.9, 0, 0, 20)
    sLabel.Position = UDim2.new(0.05, 0, 0, 45)
    sLabel.Text = "INTENSITY: " .. default
    sLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    sLabel.Font = Enum.Font.GothamMedium
    sLabel.TextSize = 11
    sLabel.TextXAlignment = Enum.TextXAlignment.Left
    sLabel.BackgroundTransparency = 1
    sLabel.Parent = card

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.9, 0, 0, 5)
    bar.Position = UDim2.new(0.05, 0, 0, 75)
    bar.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    bar.Parent = card
    Instance.new("UICorner", bar)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
    fill.Parent = bar
    Instance.new("UICorner", fill)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default-min)/(max-min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Text = ""
    knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        knob.Position = UDim2.new(pos, 0, 0.5, 0)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (pos * (max - min)))
        sLabel.Text = "INTENSITY: " .. val
        sliderCallback(val)
    end

    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i) end end)
    
    return toggle
end

local lagBtn = createModule("Network Lag", 10, function() isLagging = not isLagging return isLagging end, 1, 200, 29, function(v) packetMultiplier = v end)
local speedBtn = createModule("Speed Booster", 115, function() speedActive = not speedActive return speedActive end, 1, 300, 56, function(v) walkSpeedVal = v end)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -35)
footer.Text = "PRESS INSERT TO TOGGLE VISIBILITY"
footer.TextColor3 = Color3.fromRGB(60, 80, 120)
footer.Font = Enum.Font.GothamBold
footer.TextSize = 9
footer.BackgroundTransparency = 1
footer.Parent = main

RunService.Heartbeat:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if hum and root then
        if speedActive and hum.MoveDirection.Magnitude > 0 then
            root.Velocity = Vector3.new(hum.MoveDirection.X * walkSpeedVal, root.Velocity.Y, hum.MoveDirection.Z * walkSpeedVal)
        end
        hum.UseJumpPower = true
        hum.JumpPower = jumpPowerVal
    end

    if isLagging and target then
        for i = 1, packetMultiplier do
            target:FireServer(uuid, string.rep("z", 5000))
        end
    end
end)

UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.Insert then main.Visible = not main.Visible end
end)

print("XLR7 HUB - LAGGER LOADED!")
