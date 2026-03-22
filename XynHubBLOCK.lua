-- [[ Xyn Hub - Block (PURE MANUAL + REFRESH) ]] --
--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- [ 1. MODERN UI SETUP ] --
local screenGui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
screenGui.Name = "XynHubBlockPure"
screenGui.ResetOnSpawn = false

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 220, 0, 120)
main.Position = UDim2.new(0.5, -110, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15) -- Sudut Membulat
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.new(1, 1, 1) -- Outline Putih
stroke.Thickness = 1.5

-- Tombol X Close Script
local closeScript = Instance.new("TextButton", main)
closeScript.Size = UDim2.new(0, 25, 0, 25)
closeScript.Position = UDim2.new(1, -30, 0, 5)
closeScript.Text = "X"
closeScript.TextColor3 = Color3.new(1, 0, 0)
closeScript.BackgroundTransparency = 1
closeScript.Font = Enum.Font.GothamBold

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Xyn Hub - Block" -- Nama Baru
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Buka List
local selectBtn = Instance.new("TextButton", main)
selectBtn.Size = UDim2.new(0.85, 0, 0, 40)
selectBtn.Position = UDim2.new(0.075, 0, 0.45, 0)
selectBtn.Text = "SELECT PLAYER"
selectBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
selectBtn.TextColor3 = Color3.new(1, 1, 1)
selectBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", selectBtn)

-- [ 2. LIST PLAYER & REFRESH SETUP ] --
local listFrame = Instance.new("Frame", main)
listFrame.Size = UDim2.new(1, 0, 0.8, 0)
listFrame.Position = UDim2.new(0, 0, 0.15, 0)
listFrame.BackgroundTransparency = 1
listFrame.Visible = false

-- TOMBOL REFRESH
local refreshBtn = Instance.new("TextButton", listFrame)
refreshBtn.Size = UDim2.new(0.4, 0, 0, 25)
refreshBtn.Position = UDim2.new(0.05, 0, 0, 0)
refreshBtn.Text = "REFRESH ↻"
refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 10
Instance.new("UICorner", refreshBtn)

-- TOMBOL BACK
local backBtn = Instance.new("TextButton", listFrame)
backBtn.Size = UDim2.new(0.4, 0, 0, 25)
backBtn.Position = UDim2.new(0.55, 0, 0, 0)
backBtn.Text = "BACK"
backBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
backBtn.TextColor3 = Color3.new(1, 1, 1)
backBtn.Font = Enum.Font.GothamBold
backBtn.TextSize = 10
Instance.new("UICorner", backBtn)

local scroll = Instance.new("ScrollingFrame", listFrame)
scroll.Size = UDim2.new(0.9, 0, 0.65, 0)
scroll.Position = UDim2.new(0.05, 0, 0.15, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- [ 3. LOGIC PURE MANUAL & REFRESH ] --
local function UpdateList()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then
            local pBtn = Instance.new("TextButton", scroll)
            pBtn.Size = UDim2.new(0.95, 0, 0, 30)
            pBtn.Text = p.DisplayName
            pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            pBtn.TextColor3 = Color3.new(1, 1, 1)
            pBtn.Font = Enum.Font.Gotham
            Instance.new("UICorner", pBtn)
            
            pBtn.MouseButton1Click:Connect(function()
                StarterGui:SetCore("PromptBlockPlayer", p)
            end)
        end
    end
end

refreshBtn.MouseButton1Click:Connect(UpdateList) -- Execute Refresh

selectBtn.MouseButton1Click:Connect(function()
    selectBtn.Visible = false
    main:TweenSize(UDim2.new(0, 220, 0, 280), "Out", "Quart", 0.3)
    task.wait(0.2)
    listFrame.Visible = true
    UpdateList()
end)

backBtn.MouseButton1Click:Connect(function()
    listFrame.Visible = false
    main:TweenSize(UDim2.new(0, 220, 0, 120), "Out", "Quart", 0.3)
    task.wait(0.2)
    selectBtn.Visible = true
end)

closeScript.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- [ 4. DRAG SYSTEM ] --
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

