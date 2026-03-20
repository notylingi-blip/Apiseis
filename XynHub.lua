--[[
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    XYN HUB V1.1 – ESP & HITBOX INTEGRATED
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- CONFIG & TOGGLES
local attacking, aimbotEnabled = false, false
local espEnabled, hitboxEnabled = false, false
local aimbotConnection, espConnections = nil, {}

-- FUNCTION: ESP & HITBOX LOGIC (FROM @RZNNQ)
local function createESP(plr)
    if not espEnabled or plr == player or not plr.Character then return end
    local char = plr.Character
    local head = char:FindFirstChild("Head")
    if head and not char:FindFirstChild("XynESP") then
        local billboard = Instance.new("BillboardGui", char)
        billboard.Name = "XynESP"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = plr.DisplayName or plr.Name
        label.TextColor3 = Color3.fromRGB(255, 0, 255)
        label.Font = Enum.Font.Arcade
        label.TextScaled = true
    end
end

local function applyHitbox(plr)
    if not hitboxEnabled or plr == player or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp and not plr.Character:FindFirstChild("XynHitbox") then
        local hb = Instance.new("BoxHandleAdornment", plr.Character)
        hb.Name = "XynHitbox"
        hb.Adornee = hrp
        hb.Size = Vector3.new(4, 6, 2) -- Default RZNNQ Size
        hb.Color3 = Color3.fromRGB(128, 0, 128)
        hb.Transparency = 0.6
        hb.AlwaysOnTop = true
        hb.ZIndex = 10
    end
end

-- UI SYSTEM (XYN HUB - NO CHANGES TO UI DESIGN)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Size = UDim2.new(0, 200, 0, 350) -- Adjusted height for new buttons
Main.Position = UDim2.new(0.05, 0, 0.3, 0)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "⚡ XYN HUB V1.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local function CreateButton(text, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.Position = pos
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function() callback(Btn) end)
end

-- BUTTONS
CreateButton("AUTO BAT : OFF", UDim2.new(0.05, 0, 0, 45), function(b)
    attacking = not attacking
    b.Text = attacking and "AUTO BAT : ON" or "AUTO BAT : OFF"
    b.BackgroundColor3 = attacking and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(30, 30, 40)
end)

CreateButton("AIMBOT : OFF", UDim2.new(0.05, 0, 0, 95), function(b)
    aimbotEnabled = not aimbotEnabled
    b.Text = aimbotEnabled and "AIMBOT : ON" or "AIMBOT : OFF"
    b.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(30, 30, 40)
end)

CreateButton("ESP NAME : OFF", UDim2.new(0.05, 0, 0, 145), function(b)
    espEnabled = not espEnabled
    b.Text = espEnabled and "ESP NAME : ON" or "ESP NAME : OFF"
    b.BackgroundColor3 = espEnabled and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(30, 30, 40)
end)

CreateButton("BIG HITBOX : OFF", UDim2.new(0.05, 0, 0, 195), function(b)
    hitboxEnabled = not hitboxEnabled
    b.Text = hitboxEnabled and "HITBOX : ON" or "HITBOX : OFF"
    b.BackgroundColor3 = hitboxEnabled and Color3.fromRGB(128, 0, 128) or Color3.fromRGB(30, 30, 40)
end)

-- CORE LOOPS
RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if espEnabled then createESP(plr) end
            if hitboxEnabled then applyHitbox(plr) end
        end
    end
end)

    aimbotConnection = RunService.RenderStepped:Connect(function()
        local target = getClosestTarget()
        if target then
            local lookPos = Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)
            alignOri.CFrame = CFrame.lookAt(hrp.Position, lookPos)
        end
    end)
end

local function stopBodyAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    if alignOri then alignOri:Destroy() alignOri = nil end
    if attach0 then attach0:Destroy() attach0 = nil end
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").AutoRotate = true
    end
end

-- UI BUTTONS CREATION
local function CreateButton(text, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 45)
    Btn.Position = pos
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    Btn.MouseButton1Click:Connect(function()
        callback(Btn)
    end)
end

CreateButton("AUTO BAT : OFF", UDim2.new(0.05, 0, 0, 50), function(b)
    attacking = not attacking
    b.Text = attacking and "AUTO BAT : ON" or "AUTO BAT : OFF"
    b.BackgroundColor3 = attacking and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(30, 30, 40)
    if attacking then autoAttack() end
end)

CreateButton("AIMBOT : OFF", UDim2.new(0.05, 0, 0, 105), function(b)
    aimbotEnabled = not aimbotEnabled
    b.Text = aimbotEnabled and "AIMBOT : ON" or "AIMBOT : OFF"
    b.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(30, 30, 40)
    if aimbotEnabled then startBodyAimbot() else stopBodyAimbot() end
end)

-- NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "XYN HUB",
    Text = "Quantum Engine V13 Active!",
    Duration = 5
})
