local plrs = game:GetService("Players")
local repsto = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

local lp = plrs.LocalPlayer
local plrgui = lp:WaitForChild("PlayerGui")

local AdminRemote = nil

task.spawn(function()
	if not lp.Character then lp.CharacterAdded:Wait() end
	task.wait(1)
	local net = repsto:WaitForChild("Packages"):WaitForChild("Net")
	local children = net:GetChildren()
	local byIdx, byName = {}, {}
	for i, obj in ipairs(children) do byIdx[i] = obj byName[obj.Name] = i end
	local anchorIdx = byName["RF/a0e78691-cb9b-4efc-ac08-9c06fea70059"]
	if anchorIdx then
		local actual = byIdx[anchorIdx + 1]
		if actual then AdminRemote = actual end
	end
end)

local function spamPlayer(p)
	if not AdminRemote then return end
	local id = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
	for _, cmd in ipairs({"balloon","jumpscare","rocket","jail","ragdoll"}) do
		task.spawn(function() AdminRemote:InvokeServer(id, p, cmd) end)
	end
end

-- [[ UI DESIGN: XYN HUB - DEFENDER ]] --
local sg = Instance.new("ScreenGui")
sg.Name = "XynHub_Defender"
sg.ResetOnSpawn = false
sg.Parent = plrgui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 300)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = sg

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "XYN HUB - DEFENDER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local line = Instance.new("Frame")
line.Size = UDim2.new(0.9, 0, 0, 1)
line.Position = UDim2.new(0.05, 0, 0, 35)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BorderSizePixel = 0
line.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 2
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

local playerBtns = {}

local function makePlayerBtn(p)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.95, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = "  " .. p.Name
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamMedium
	btn.BorderSizePixel = 0
	btn.Parent = scroll
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	local bStroke = Instance.new("UIStroke", btn)
    bStroke.Color = Color3.fromRGB(255, 255, 255)
    bStroke.Thickness = 1
    bStroke.Transparency = 0.8

	btn.MouseButton1Click:Connect(function()
		spamPlayer(p)
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextColor3 = Color3.fromRGB(0, 0, 0)
		task.delay(0.2, function()
			btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		end)
	end)

	return btn
end

local function refresh()
	for _, b in pairs(playerBtns) do b:Destroy() end
	playerBtns = {}
	for _, p in ipairs(plrs:GetPlayers()) do
		if p ~= lp then
			playerBtns[p.UserId] = makePlayerBtn(p)
		end
	end
end

refresh()
plrs.PlayerAdded:Connect(refresh)
plrs.PlayerRemoving:Connect(function() task.wait(0.1) refresh() end)

-- Draggable Logic
do
	local dragging, dragStart, frameStart = false, nil, nil
	mainFrame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true dragStart = i.Position frameStart = mainFrame.Position
		end
	end)
	mainFrame.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
	uis.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			mainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + d.X, frameStart.Y.Scale, frameStart.Y.Offset + d.Y)
		end
	end)
end

