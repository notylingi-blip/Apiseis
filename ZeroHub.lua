-- ==========================================================
-- 💀 ZERO HUB [v1.1] - MINIMIZE SUPPORT 💀
-- Created by Quantum V13.0 (RianModss)
-- Theme: DARK VOID / WHITE OUTLINE
-- ==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- ================= STATE & SETTINGS =================
local FeatureStates = {
    ESP = false, Hitbox = false, AutoBat = false, 
    Aimbot = false, Float = false, AntiRagdoll = true, 
    SpeedBypass = false, XRay = false, InfJump = false
}

local guiVisible = true

-- ================= GUI CONSTRUCTION =================
local ZeroHub_GUI = Instance.new("ScreenGui")
ZeroHub_GUI.Name = "ZeroHub_V1.1"
ZeroHub_GUI.ResetOnSpawn = false
pcall(function() ZeroHub_GUI.Parent = CoreGui end)
if not ZeroHub_GUI.Parent then ZeroHub_GUI.Parent = player:WaitForChild("PlayerGui") end

-- 1. MAIN FRAME
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ZeroHub_GUI
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -150, 0.5, -200)
Main.Size = UDim2.new(0, 300, 0, 400)
Main.Active = true
Main.Draggable = true

local Outline = Instance.new("UIStroke")
Outline.Color = Color3.fromRGB(255, 255, 255)
Outline.Thickness = 2
Outline.Parent = Main

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

-- 2. MINIMIZE BUTTON (DI DALAM MAIN)
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Parent = Main
MinBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "_"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 20

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Color3.fromRGB(255, 255, 255)
MinStroke.Parent = MinBtn

-- 3. FLOATING ICON (SAAT MINIMIZED)
local OpenIcon = Instance.new("TextButton")
OpenIcon.Name = "OpenIcon"
OpenIcon.Parent = ZeroHub_GUI
OpenIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenIcon.Position = UDim2.new(0, 20, 0.5, 0)
OpenIcon.Size = UDim2.new(0, 50, 0, 50)
OpenIcon.Font = Enum.Font.Arcade
OpenIcon.Text = "ZERO"
OpenIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenIcon.Visible = false
OpenIcon.Draggable = true

local IconOutline = Instance.new("UIStroke")
IconOutline.Color = Color3.fromRGB(255, 255, 255)
IconOutline.Thickness = 2
IconOutline.Parent = OpenIcon

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0) -- Circle
IconCorner.Parent = OpenIcon

-- ================= TOGGLE VISIBILITY LOGIC =================
local function toggleGUI()
    guiVisible = not guiVisible
    Main.Visible = guiVisible
    OpenIcon.Visible = not guiVisible
end

MinBtn.MouseButton1Click:Connect(toggleGUI)
OpenIcon.MouseButton1Click:Connect(toggleGUI)

-- Keybind Toggle (Right Shift)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        toggleGUI()
    end
end)

-- ================= TITLE & CONTENT =================
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.Text = "💀 ZERO HUB [V1.1]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Arcade
Title.TextSize = 18

local Content = Instance.new("ScrollingFrame")
Content.Parent = Main
Content.Position = UDim2.new(0, 10, 0, 50)
Content.Size = UDim2.new(1, -20, 1, -60)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2

local Layout = Instance.new("UIListLayout")
Layout.Parent = Content
Layout.Padding = UDim.new(0, 5)

-- ================= FUNCTIONAL BUTTONS =================
local function createButton(name, feat)
    local btn = Instance.new("TextButton")
    btn.Parent = Content
    btn.Size = UDim2.new(1, -5, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.Text = name .. " : OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Arcade
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Parent = btn

    btn.MouseButton1Click:Connect(function()
        FeatureStates[feat] = not FeatureStates[feat]
        btn.Text = name .. (FeatureStates[feat] and " : ON" or " : OFF")
        btn.BackgroundColor3 = FeatureStates[feat] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        btn.TextColor3 = FeatureStates[feat] and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    end)
end

-- Tambah fitur-fitur lu di sini, Boss!
createButton("PLAYER ESP", "ESP")
createButton("BIG HITBOX", "Hitbox")
createButton("AUTO BAT", "AutoBat")
createButton("AIMBOT", "Aimbot")
createButton("GHOST FLOAT", "Float")
createButton("SPEED BYPASS", "SpeedBypass")
createButton("X-RAY PLOTS", "XRay")
createButton("INFINITY JUMP", "InfJump")

print("💀 ZERO HUB [v1.1] LOADED. Use RightShift to Hide/Show. 💀")

