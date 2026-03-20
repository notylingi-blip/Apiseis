--[[
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    XYN HUB V1.0 – POWERED BY QUANTUM V13
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Status : UNRESTRICTED
    Author : THE SUCCESSOR
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- CONFIGURATION
local AIMBOT_RANGE = 40      
local AIMBOT_DISABLE_RANGE = 45      
local attacking = false      
local aimbotEnabled = false      
local aimbotConnection      
local alignOri, attach0

-- UI SYSTEM (XYN HUB)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XynHub_V1"
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.05, 0, 0.35, 0)
Main.Size = UDim2.new(0, 200, 0, 240)
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ XYN HUB V1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- FUNCTIONAL LOGIC
local function equipBat()
    local char = player.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local bat = player.Backpack:FindFirstChild("Bat") or char:FindFirstChild("Bat")
    if bat and hum then
        hum:EquipTool(bat)
        return bat
    end
end

local function autoAttack()
    task.spawn(function()
        while attacking do
            local bat = equipBat()
            if bat then pcall(function() bat:Activate() end) end
            task.wait(0.15)
        end
    end)
end

local function getClosestTarget()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart
    local closest, shortestDistance = nil, AIMBOT_RANGE
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetHrp = plr.Character.HumanoidRootPart
            local dist = (targetHrp.Position - hrp.Position).Magnitude
            if dist <= shortestDistance then
                shortestDistance = dist
                closest = targetHrp
            end
        end
    end
    return closest
end

local function startBodyAimbot()
    if aimbotConnection then return end
    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = false end
    
    attach0 = Instance.new("Attachment", hrp)
    alignOri = Instance.new("AlignOrientation", hrp)
    alignOri.Attachment0 = attach0
    alignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOri.RigidityEnabled = true
    alignOri.Parent = hrp

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
