local players = game:GetService("Players")
local runService = game:GetService("RunService")
local player = players.LocalPlayer

local Colors = {
    BlueBG = Color3.fromRGB(0, 70, 180),      
    BlueAccent = Color3.fromRGB(0, 162, 255), 
    White = Color3.fromRGB(255, 255, 255),
    Disabled = Color3.fromRGB(100, 100, 100)  
}

local desyncActive = false
local DESYNC_SPEED = 15
local speedConnection

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "21Hub_Desync_V78"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 130)
mainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
mainFrame.BackgroundColor3 = Colors.BlueBG 
mainFrame.BackgroundTransparency = 0.4     
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "21 HUB - DESYNC"
title.TextColor3 = Colors.White
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local function respawnCharacter()
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Health = 0
    end
end

local function applySpeed()
    if speedConnection then speedConnection:Disconnect() end
    speedConnection = runService.Heartbeat:Connect(function()
        if desyncActive then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = DESYNC_SPEED
            end
        end
    end)
end

local enableBtn = Instance.new("TextButton")
enableBtn.Size = UDim2.new(0.9, 0, 0, 35)
enableBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
enableBtn.BackgroundColor3 = Colors.BlueBG
enableBtn.BackgroundTransparency = 0.2
enableBtn.Text = "ENABLE"
enableBtn.TextColor3 = Colors.White
enableBtn.Font = Enum.Font.GothamBold
enableBtn.TextSize = 12
enableBtn.Parent = mainFrame
Instance.new("UICorner", enableBtn)

local disableBtn = Instance.new("TextButton")
disableBtn.Size = UDim2.new(0.9, 0, 0, 35)
disableBtn.Position = UDim2.new(0.05, 0, 0.68, 0)
disableBtn.BackgroundColor3 = Colors.BlueBG
disableBtn.BackgroundTransparency = 0.2
disableBtn.Text = "DISABLE"
disableBtn.TextColor3 = Colors.White
disableBtn.Font = Enum.Font.GothamBold
disableBtn.TextSize = 12
disableBtn.Parent = mainFrame
Instance.new("UICorner", disableBtn)

enableBtn.MouseButton1Click:Connect(function()
    if not enableBtn.Active then return end
    pcall(function()
        desyncActive = true
        raknet.desync(true)
        applySpeed() 
        respawnCharacter()
        
        enableBtn.Active = false
        enableBtn.BackgroundColor3 = Colors.Disabled
        enableBtn.Text = "ACTIVE (SPEED 15)"
        
        disableBtn.Active = true
        disableBtn.BackgroundColor3 = Colors.BlueAccent
        disableBtn.Text = "DISABLE"
    end)
end)

disableBtn.MouseButton1Click:Connect(function()
    if not disableBtn.Active then return end
    pcall(function()
        desyncActive = false
        raknet.desync(false)
        if speedConnection then speedConnection:Disconnect() end
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 55
        end
        
        disableBtn.Active = false
        disableBtn.BackgroundColor3 = Colors.Disabled
        disableBtn.Text = "OFF"
        
        enableBtn.Active = true
        enableBtn.BackgroundColor3 = Colors.BlueBG
        enableBtn.Text = "ENABLE"
    end)
end)

disableBtn.Active = false
disableBtn.BackgroundColor3 = Colors.Disabled
