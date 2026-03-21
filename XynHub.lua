-- [[ XYN HUB V1.6 - MEGA INTEGRATION ]]
-- [[ FEAT: AUTO BAT, AIMBOT, ESP, HITBOX, XRAY, ANTI-RAGDOLL ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local attacking, aimbotEnabled = false, false
local espEnabled, hitboxEnabled, xrayEnabled, antiRagdoll = false, false, false, false
local xrayConnection

-- ================= ANTI RAGDOLL LOGIC (@RZNNQ) =================
local BlockedStates = {
    [Enum.HumanoidStateType.Ragdoll] = true,
    [Enum.HumanoidStateType.FallingDown] = true,
    [Enum.HumanoidStateType.Physics] = true,
    [Enum.HumanoidStateType.Dead] = true
}

local function handleAntiRagdoll()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and antiRagdoll then
        [span_1](start_span)hum.Health = hum.MaxHealth -- Anti Die Logic[span_1](end_span)
        if BlockedStates[hum:GetState()] then
            [span_2](start_span)hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)[span_2](end_span)
        end
    end
end

-- ================= CLEANUP & TOGGLE LOGIC =================
local function cleanupXRay()
    if xrayConnection then xrayConnection:Disconnect() xrayConnection = nil end
    local Plots = Workspace:FindFirstChild("Plots")
    if Plots then
        for _, Plot in ipairs(Plots:GetChildren()) do
            if Plot:IsA("Model") and Plot:FindFirstChild("Decorations") then
                for _, Part in ipairs(Plot.Decorations:GetDescendants()) do
                    if Part:IsA("BasePart") then Part.Transparency = 1 end
                end
            end
        end
    end
end

local function removeAllESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character then
            local esp = v.Character:FindFirstChild("XynESP")
            if esp then esp:Destroy() end
        end
    end
end

local function removeAllHitbox()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character then
            local hb = v.Character:FindFirstChild("XynHitbox")
            if hb then hb:Destroy() end
        end
    end
end

-- ================= MAIN RENDER LOOP =================
RunService.RenderStepped:Connect(function()
    [span_3](start_span)handleAntiRagdoll() -- Constant check for Anti Ragdoll[span_3](end_span)

    -- AIMBOT
    if aimbotEnabled then
        local closest, dist = nil, 40
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local d = (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d closest = v.Character.HumanoidRootPart end
            end
        end
        if closest and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(closest.Position.X, hrp.Position.Y, closest.Position.Z))
        end
    end

    -- X-RAY LOGIC
    if xrayEnabled then
        local Plots = Workspace:FindFirstChild("Plots")
        if Plots then
            for _, Plot in ipairs(Plots:GetChildren()) do
                if Plot:IsA("Model") and Plot:FindFirstChild("Decorations") then
                    for _, Part in ipairs(Plot.Decorations:GetDescendants()) do
                        if Part:IsA("BasePart") then Part.Transparency = 0.8 end
                    end
                end
            end
        end
    end

    -- ESP & HITBOX
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character then
            if espEnabled and not v.Character:FindFirstChild("XynESP") then
                local head = v.Character:FindFirstChild("Head")
                if head then
                    local bb = Instance.new("BillboardGui", v.Character)
                    bb.Name = "XynESP"; bb.Adornee = head; bb.Size = UDim2.new(0, 200, 0, 50); bb.AlwaysOnTop = true
                    local l = Instance.new("TextLabel", bb)
                    l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.Text = v.DisplayName or v.Name
                    l.TextColor3 = Color3.fromRGB(255, 0, 255); l.Font = Enum.Font.Arcade; l.TextScaled = true
                end
            end
            if hitboxEnabled and not v.Character:FindFirstChild("XynHitbox") then
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local hb = Instance.new("BoxHandleAdornment", v.Character)
                    hb.Name = "XynHitbox"; hb.Adornee = hrp; hb.Size = Vector3.new(4, 6, 2)
                    hb.Color3 = Color3.fromRGB(128, 0, 128); hb.Transparency = 0.6; hb.AlwaysOnTop = true
                end
            end
        end
    end
end)

-- ================= UI SYSTEM (ORIGINAL BLUE) =================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
Main.Size = UDim2.new(0, 140, 0, 320) -- Adjusted size for Anti-Ragdoll
Main.Position = UDim2.new(0.05, 0, 0.35, 0)
Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 25); TopBar.BackgroundColor3 = Color3.fromRGB(10, 50, 120)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "⚡ XYN HUB"; Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.BackgroundTransparency = 1

local function CreateButton(text, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.8, 0, 0, 35); Btn.Position = pos; Btn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    Btn.Text = text; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 10
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    Btn.MouseButton1Click:Connect(function() callback(Btn) end)
end

CreateButton("AUTO BAT: OFF", UDim2.new(0.1, 0, 0, 40), function(b)
    attacking = not attacking
    b.Text = attacking and "AUTO BAT: ON" or "AUTO BAT: OFF"
    b.BackgroundColor3 = attacking and Color3.fromRGB(50, 200, 120) or Color3.fromRGB(50, 120, 200)
end)

CreateButton("AIMBOT: OFF", UDim2.new(0.1, 0, 0, 85), function(b)
    aimbotEnabled = not aimbotEnabled
    b.Text = aimbotEnabled and "AIMBOT: ON" or "AIMBOT: OFF"
    b.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(250, 150, 50) or Color3.fromRGB(50, 120, 200)
end)

CreateButton("ESP NAME: OFF", UDim2.new(0.1, 0, 0, 130), function(b)
    espEnabled = not espEnabled
    if not espEnabled then removeAllESP() end
    b.Text = espEnabled and "ESP NAME: ON" or "ESP NAME: OFF"
    b.BackgroundColor3 = espEnabled and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(50, 120, 200)
end)

CreateButton("HITBOX: OFF", UDim2.new(0.1, 0, 0, 175), function(b)
    hitboxEnabled = not hitboxEnabled
    if not hitboxEnabled then removeAllHitbox() end
    b.Text = hitboxEnabled and "HITBOX: ON" or "HITBOX: OFF"
    b.BackgroundColor3 = hitboxEnabled and Color3.fromRGB(128, 0, 128) or Color3.fromRGB(50, 120, 200)
end)

CreateButton("X-RAY: OFF", UDim2.new(0.1, 0, 0, 220), function(b)
    xrayEnabled = not xrayEnabled
    if not xrayEnabled then cleanupXRay() end
    b.Text = xrayEnabled and "X-RAY: ON" or "X-RAY: OFF"
    b.BackgroundColor3 = xrayEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 120, 200)
end)

CreateButton("ANTI RAGDOLL: OFF", UDim2.new(0.1, 0, 0, 265), function(b)
    antiRagdoll = not antiRagdoll
    b.Text = antiRagdoll and "ANTI RAGDOLL: ON" or "ANTI RAGDOLL: OFF"
    b.BackgroundColor3 = antiRagdoll and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 120, 200)
end)
    end
end)

-- ================= UI SYSTEM (ORIGINAL) =================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
Main.Size = UDim2.new(0, 140, 0, 240)
Main.Position = UDim2.new(0.05, 0, 0.35, 0)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 50, 120)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "⚡ XYN HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1

local function CreateButton(text, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.8, 0, 0, 35)
    Btn.Position = pos
    Btn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    Btn.MouseButton1Click:Connect(function() callback(Btn) end)
end

CreateButton("AUTO BAT: OFF", UDim2.new(0.1, 0, 0, 40), function(b)
    attacking = not attacking
    b.Text = attacking and "AUTO BAT: ON" or "AUTO BAT: OFF"
    b.BackgroundColor3 = attacking and Color3.fromRGB(50, 200, 120) or Color3.fromRGB(50, 120, 200)
    if attacking then autoAttack() end
end)

CreateButton("AIMBOT: OFF", UDim2.new(0.1, 0, 0, 85), function(b)
    aimbotEnabled = not aimbotEnabled
    b.Text = aimbotEnabled and "AIMBOT: ON" or "AIMBOT: OFF"
    b.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(250, 150, 50) or Color3.fromRGB(50, 120, 200)
end)

CreateButton("ESP NAME: OFF", UDim2.new(0.1, 0, 0, 130), function(b)
    espEnabled = not espEnabled
    if not espEnabled then removeAllESP() end
    b.Text = espEnabled and "ESP NAME: ON" or "ESP NAME: OFF"
    b.BackgroundColor3 = espEnabled and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(50, 120, 200)
end)

CreateButton("HITBOX: OFF", UDim2.new(0.1, 0, 0, 175), function(b)
    hitboxEnabled = not hitboxEnabled
    if not hitboxEnabled then removeAllHitbox() end
    b.Text = hitboxEnabled and "HITBOX: ON" or "HITBOX: OFF"
    b.BackgroundColor3 = hitboxEnabled and Color3.fromRGB(128, 0, 128) or Color3.fromRGB(50, 120, 200)
end)
