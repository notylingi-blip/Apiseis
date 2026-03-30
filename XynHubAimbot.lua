--========================      
-- CEBO SCRIPTS - BAT      
-- AUTO BAT + BODY AIMBOT CON DISTANCIA      
-- SOLO PARA TU JUEGO      
-- UI MÁS CORTA + BOTONES JUNTOS + EMOJIS      
-- LEAKED BY discord.gg/tokinu        
--========================      

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- CONFIGURACIÓN      
local AIMBOT_RANGE = 40      
local AIMBOT_DISABLE_RANGE = 45      

local attacking = false      
local aimbotEnabled = false      
local aimbotConnection      

local alignOri      
local attach0      

-- ================= UI =================      
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "XynHub_AutoBat"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 140, 0, 160)
Main.Position = UDim2.new(0.05, 0, 0.35, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0,12)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1,0,0,25)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 50, 120)
TopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "👿 XynHubScript"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12

-- ================= Discord =================
local DiscordLabel = Instance.new("TextButton", Main)
DiscordLabel.Size = UDim2.new(0.9,0,0,20)
DiscordLabel.Position = UDim2.new(0.05,0,0,30)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "discord.gg/ZxefdezK3"
DiscordLabel.Font = Enum.Font.GothamBold
DiscordLabel.TextSize = 10
DiscordLabel.AutoButtonColor = false

DiscordLabel.MouseButton1Click:Connect(function()
	setclipboard("discord.gg/tokinu")
end)

local rainbowColors = {
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(255,127,0),
	Color3.fromRGB(255,255,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,0,255),
	Color3.fromRGB(75,0,130),
	Color3.fromRGB(148,0,211)
}
local colorIndex = 1

RunService.Heartbeat:Connect(function()
	if DiscordLabel then
		DiscordLabel.TextColor3 = rainbowColors[colorIndex]
	end
end)

spawn(function()
	while true do
		colorIndex += 1
		if colorIndex > #rainbowColors then
			colorIndex = 1
		end
		task.wait(0.5)
	end
end)

-- ================= BOTONES =================
local Button = Instance.new("TextButton", Main)
Button.Size = UDim2.new(0.8,0,0,40)
Button.Position = UDim2.new(0.1,0,0,55)
Button.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
Button.Text = "🔴 AUTO BAT : OFF"
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 11
Button.AutoButtonColor = false

local BtnCorner = Instance.new("UICorner", Button)
BtnCorner.CornerRadius = UDim.new(0,10)
local AutoBatActiveColor = Color3.fromRGB(50, 200, 120)

local AimbotBtn = Instance.new("TextButton", Main)
AimbotBtn.Size = UDim2.new(0.8,0,0,40)
AimbotBtn.Position = UDim2.new(0.1,0,0,105)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
AimbotBtn.Text = "🎯 AIMBOT : OFF"
AimbotBtn.TextColor3 = Color3.fromRGB(255,255,255)
AimbotBtn.Font = Enum.Font.GothamBold
AimbotBtn.TextSize = 11
AimbotBtn.AutoButtonColor = false

local AimbotCorner = Instance.new("UICorner", AimbotBtn)
AimbotCorner.CornerRadius = UDim.new(0,10)
local AimbotActiveColor = Color3.fromRGB(250, 150, 50)

local function hoverEffect(button)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(85,85,85)
		}):Play()
	end)
	button.MouseLeave:Connect(function()
		if button == Button then
			local color = attacking and AutoBatActiveColor or Color3.fromRGB(50,120,200)
			TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
		elseif button == AimbotBtn then
			local color = aimbotEnabled and AimbotActiveColor or Color3.fromRGB(50,120,200)
			TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
		end
	end)
end

hoverEffect(Button)
hoverEffect(AimbotBtn)

-- ================= SONIDOS =================      
local OnSound = Instance.new("Sound")
OnSound.Parent = ScreenGui
OnSound.SoundId = "rbxassetid://8745692251"
OnSound.Volume = 1

local ASound = Instance.new("Sound")
ASound.Parent = ScreenGui
ASound.SoundId = "rbxassetid://5419098670"
ASound.Volume = 1

-- ================= AUTO BAT =================      
local function equipBat()
	local char = player.Character
	if not char then return nil end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return nil end

	local bat = player.Backpack:FindFirstChild("Bat") or char:FindFirstChild("Bat")
	if bat then
		hum:EquipTool(bat)
		return bat
	end
end

local function autoAttack()
	task.spawn(function()
		while attacking do
			local bat = equipBat()
			if bat then
				pcall(function()
					bat:Activate()
				end)
			end
			task.wait(0.15)
		end
	end)
end

-- ================= BODY AIMBOT =================      
local function getClosestTarget()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

	local hrp = char.HumanoidRootPart
	local closest = nil
	local shortestDistance = AIMBOT_RANGE

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
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.AutoRotate = false
	end

	attach0 = Instance.new("Attachment", hrp)

	alignOri = Instance.new("AlignOrientation")
	alignOri.Attachment0 = attach0
	alignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
	alignOri.RigidityEnabled = true
	alignOri.MaxTorque = math.huge
	alignOri.Responsiveness = 200
	alignOri.Parent = hrp

	aimbotConnection = RunService.RenderStepped:Connect(function()
		local target = getClosestTarget()
		if not target then return end

		local dist = (target.Position - hrp.Position).Magnitude
		if dist > AIMBOT_DISABLE_RANGE then return end

		local lookPos = Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)
		alignOri.CFrame = CFrame.lookAt(hrp.Position, lookPos)
	end)
end

local function stopBodyAimbot()
	if aimbotConnection then
		aimbotConnection:Disconnect()
		aimbotConnection = nil
	end

	if alignOri then
		alignOri:Destroy()
		alignOri = nil
	end

	if attach0 then
		attach0:Destroy()
		attach0 = nil
	end

	local char = player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.AutoRotate = true
		end
	end
end

-- ================= BOTONES =================      
Button.MouseButton1Click:Connect(function()
	attacking = not attacking

	if attacking then
		OnSound:Play()
		Button.Text = "🟢 AUTO BAT : ON"
		Button.BackgroundColor3 = AutoBatActiveColor
		autoAttack()
	else
		ASound:Play()
		Button.Text = "🔴 AUTO BAT : OFF"
		Button.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
	end
end)

AimbotBtn.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled

	if aimbotEnabled then
		OnSound:Play()
		AimbotBtn.Text = "🟢 AIMBOT : ON"
		AimbotBtn.BackgroundColor3 = AimbotActiveColor
		startBodyAimbot()
	else
		ASound:Play()
		AimbotBtn.Text = "🎯 AIMBOT : OFF"
		AimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
		stopBodyAimbot()
	end
end)

-- ================= ATAJOS INVISIBLES PC =================
-- [R] AUTO BAT
-- [T] AIMBOT
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.R then
		attacking = not attacking

		if attacking then
			OnSound:Play()
			Button.Text = "🟢 AUTO BAT : ON"
			Button.BackgroundColor3 = AutoBatActiveColor
			autoAttack()
		else
			ASound:Play()
			Button.Text = "🔴 AUTO BAT : OFF"
			Button.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
		end
	end

	if input.KeyCode == Enum.KeyCode.T then
		aimbotEnabled = not aimbotEnabled

		if aimbotEnabled then
			OnSound:Play()
			AimbotBtn.Text = "🟢 AIMBOT : ON"
			AimbotBtn.BackgroundColor3 = AimbotActiveColor
			startBodyAimbot()
		else
			ASound:Play()
			AimbotBtn.Text = "🎯 AIMBOT : OFF"
			AimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
			stopBodyAimbot()
		end
	end
end)
