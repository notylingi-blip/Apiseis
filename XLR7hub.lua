-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- XLR7 HUB (PART 1: SETUP & UI)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Settings file management (Rebranded to XLR7)
local settingsFileName = "XLR7HubSettings.json"
local defaultSettings = {
    walkspeedEnabled = false, currentWalkSpeed = 80,
    infiniteJumpEnabled = false, boostJumpEnabled = false,
    currentBoostStrength = 150, espEnabled = false,
    timerEspEnabled = false, webSlingerAutoAimEnabled = false,
    antiTrapEnabled = false, antiHitEnabled = false,
    brainrotEspEnabled = false, flingEnabled = false,
    guiPosition = {0, 10, 1, -60}
}

local function saveSettings(st)
    pcall(function() writefile(settingsFileName, HttpService:JSONEncode(st)) end)
end

local function loadSettings()
    if isfile(settingsFileName) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(settingsFileName)) end)
        if success then
            for k, v in pairs(defaultSettings) do if decoded[k] == nil then decoded[k] = v end end
            return decoded
        end
    end
    return defaultSettings
end

local settings = loadSettings()

-- UI CONSTRUCTION (WHITE & BLACK EDITION)
local oldGui = PlayerGui:FindFirstChild("XLR7HubGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
screenGui.Name = "XLR7HubGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 450, 0, 320)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0) -- Black
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "XLR7 HUB - ELITE EDITION"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- XLR7 HUB (PART 2: CORE FEATURES)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Walkspeed Function
local function updateWalkspeed()
    task.spawn(function()
        while settings.walkspeedEnabled do
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = settings.currentWalkSpeed
            end
            task.wait(0.1)
        end
    end)
end

-- ESP System (Simple & Optimized)
local function createESP(target)
    if target == player then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "XLR7_ESP"
    highlight.FillColor = Color3.fromRGB(0, 0, 0) -- Black Fill
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White Outline
    highlight.Parent = target.Character
end

-- Fling Logic (Brutal)
local function toggleFling(state)
    settings.flingEnabled = state
    task.spawn(function()
        while settings.flingEnabled do
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.new(0, 10000, 0)
                RunService.Heartbeat:Wait()
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
            task.wait()
        end
    end)
end

-- Anti Trap Logic
local function toggleAntiTrap(state)
    settings.antiTrapEnabled = state
    task.spawn(function()
        while settings.antiTrapEnabled do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Trap" or obj.Name == "Bear Trap" then
                    obj:Destroy()
                end
            end
            task.wait(1)
        end
    end)
end
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- XLR7 HUB (PART 3: UI CONTROLS)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local container = Instance.new("ScrollingFrame", mainFrame)
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 5)

local function makeToggle(txt, key, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = settings[key] and Color3.new(0,0,0) or Color3.new(0.9,0.9,0.9)
    btn.TextColor3 = settings[key] and Color3.new(1,1,1) or Color3.new(0,0,0)
    btn.Text = txt .. ": " .. (settings[key] and "ON" or "OFF")
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        settings[key] = not settings[key]
        btn.Text = txt .. ": " .. (settings[key] and "ON" or "OFF")
        btn.BackgroundColor3 = settings[key] and Color3.new(0,0,0) or Color3.new(0.9,0.9,0.9)
        btn.TextColor3 = settings[key] and Color3.new(1,1,1) or Color3.new(0,0,0)
        saveSettings(settings)
        if callback then callback(settings[key]) end
    end)
end

-- Finalizing Toggles
makeToggle("Speed Bypass (80)", "walkspeedEnabled", function(v) if v then updateWalkspeed() end end)
makeToggle("Brutal Fling", "flingEnabled", toggleFling)
makeToggle("Anti Trap", "antiTrapEnabled", toggleAntiTrap)
makeToggle("Player ESP", "espEnabled", function(v) if v then for _,p in pairs(Players:GetPlayers()) do createESP(p) end end end)
makeToggle("Infinite Jump", "infiniteJumpEnabled")

-- Minimize Button
local mini = Instance.new("TextButton", screenGui)
mini.Size = UDim2.new(0, 40, 0, 40)
mini.Position = UDim2.new(0, 10, 0.5, 0)
mini.BackgroundColor3 = Color3.new(0,0,0)
mini.Text = "X7"
mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)
mini.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

print("XLR7 HUB LOADED SUCCESSFULLY")

