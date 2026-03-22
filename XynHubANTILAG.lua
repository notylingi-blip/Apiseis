-- [[ XYN HUB - ANTI LAG (SUPER LIGHT EDITION) ]] --
--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()

-- [ 1. MODERN UI SETUP - ROUNDED BLACK ] --
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "XynHubAntiLagUi"
screenGui.ResetOnSpawn = false

local main = Instance.new("Frame", screenGui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 190, 0, 150) -- Kotak Minimalist
main.Position = UDim2.new(0.5, -95, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Hitam
main.BorderSizePixel = 0
main.Active = true

-- UI Modern: Rounded & Stroke
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15) -- Sudut Gak Lancip
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 255, 255) -- Outline Putih
stroke.Thickness = 1.2

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "XYN HUB - ANTI LAG" --
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 12

-- Template Buat Tombol Modern
local function CreateXynButton(Parent, Name, Pos)
    local btn = Instance.new("TextButton", Parent)
    btn.Name = Name
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = Pos
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local antiLagBtn = CreateXynButton(main, "AntiLagBtn", UDim2.new(0.075, 0, 0.3, 0))
antiLagBtn.Text = "ACTIVATE ANTI LAG" --

local noAnimBtn = CreateXynButton(main, "NoAnimBtn", UDim2.new(0.075, 0, 0.65, 0))
noAnimBtn.Text = "ACTIVATE NO ANIM" --

-- [ 2. SMART DRAGGABLE SYSTEM ] --
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- [ 3. XYN POWER ENGINE ] --

-- Fitur 1: Anti Lag Super Super Ringan
local function EnableAntiLag()
    -- Bantai Semua Lighting Effects
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostProcessEffect") then v.Enabled = false end
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    -- Sapu Bersih Tekstur & Partikel
    local function Clean(v)
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            v.Enabled = false
            v:Destroy()
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end
    for _, obj in pairs(workspace:GetDescendants()) do Clean(obj) end
    workspace.DescendantAdded:Connect(Clean)
end

antiLagBtn.MouseButton1Click:Connect(function()
    antiLagBtn.Text = "BOOSTING..."
    EnableAntiLag()
    task.wait(1)
    antiLagBtn.Text = "XYN BOOSTED ✅"
end)

-- Fitur 2: No Animation Player
noAnimBtn.MouseButton1Click:Connect(function()
    noAnimBtn.Text = "REMOVING ANIM..."
    local animate = Character:FindFirstChild("Animate")
    if animate then
        animate.Enabled = false -- Matiin paksa animasinya
        noAnimBtn.Text = "XYN STATIC ✅"
    else
        noAnimBtn.Text = "ANIM NOT FOUND"
        task.wait(1)
        noAnimBtn.Text = "ACTIVATE NO ANIM"
    end
end)
