-- [[ XLR7 HUB - LAGGER V6 FINAL VERSION ]]
-- [[ OWNER: PemaiSab ]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local LPlayerName = player.Name

-- [[ DATABASE KEY 50 USERS + OWNER ]]
local whitelistDatabase = {
    ["PemaiSab"] = "Key-Owner",
    ["Shaka_426"] = "XLR7-A92B-4412", ["User2"] = "XLR7-B11X-9902", ["User3"] = "XLR7-C33Z-1123",
    ["User4"] = "XLR7-D44Y-8871", ["User5"] = "XLR7-E55W-6625", ["User6"] = "XLR7-F66V-4410",
    ["User7"] = "XLR7-G77U-2298", ["User8"] = "XLR7-H88T-0012", ["User9"] = "XLR7-I99S-3345",
    ["User10"] = "XLR7-J00R-5567", ["User11"] = "XLR7-K11Q-7789", ["User12"] = "XLR7-L22P-9901",
    ["User13"] = "XLR7-M33O-1122", ["User14"] = "XLR7-N44N-3344", ["User15"] = "XLR7-O55M-5566",
    ["User16"] = "XLR7-P66L-7788", ["User17"] = "XLR7-Q77K-9911", ["User18"] = "XLR7-R88J-2233",
    ["User19"] = "XLR7-S99I-4455", ["User20"] = "XLR7-T00H-6677", ["User21"] = "XLR7-U11G-8899",
    ["User22"] = "XLR7-V22F-0011", ["User23"] = "XLR7-W33E-2244", ["User24"] = "XLR7-X44D-4466",
    ["User25"] = "XLR7-Y55C-6688", ["User26"] = "XLR7-Z66B-8800", ["User27"] = "XLR7-A11Z-1234",
    ["User28"] = "XLR7-B22Y-2345", ["User29"] = "XLR7-C33X-3456", ["User30"] = "XLR7-D44W-4567",
    ["User31"] = "XLR7-E55V-5678", ["User32"] = "XLR7-F66U-6789", ["User33"] = "XLR7-G77T-7890",
    ["User34"] = "XLR7-H88S-8901", ["User35"] = "XLR7-I99R-9012", ["User36"] = "XLR7-J00Q-0123",
    ["User37"] = "XLR7-K11P-1357", ["User38"] = "XLR7-L22O-2468", ["User39"] = "XLR7-M33N-3579",
    ["User40"] = "XLR7-N44M-4680", ["User41"] = "XLR7-O55L-5791", ["User42"] = "XLR7-P66K-6802",
    ["User43"] = "XLR7-Q77J-7913", ["User44"] = "XLR7-R88I-8024", ["User45"] = "XLR7-S99H-9135",
    ["User46"] = "XLR7-T00G-0246", ["User47"] = "XLR7-U11F-1358", ["User48"] = "XLR7-V22E-2469",
    ["User49"] = "XLR7-W33D-3570", ["User50"] = "XLR7-X44C-4681",
}

local function SecureKick()
    local msg = "You Not Buy The XLR7 Hub lagger. Join This Discord: https://discord.gg/ZxefdezK3"
    task.wait(0.3); player:Kick(msg)
end

local isLagging, speedActive = false, false
local packetMultiplier, walkSpeedVal = 124, 54
local uuid = "d80e2217-36b8-4bdc-9a46-2281c6f70b28"

local function StartScript()
    local target
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name ~= "friendmain" and v.Name ~= "ping" then target = v; break end
    end

    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "XLR7_V6_Final"; gui.ResetOnSpawn = false

    -- [ FRAME UTAMA ]
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 320, 0, 380)
    main.Position = UDim2.new(0.5, -160, 0.4, -190)
    main.BackgroundColor3 = Color3.new(1, 1, 1); main.BorderSizePixel = 0
    main.Active = true; main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    
    local grad = Instance.new("UIGradient", main)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 15, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 2, 5))
    })
    grad.Rotation = 90
    Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 160, 255)

    -- [ HEADER ]
    local header = Instance.new("Frame", main); header.Size = UDim2.new(1, 0, 0, 50); header.BackgroundTransparency = 1
    local title = Instance.new("TextLabel", header); title.Size = UDim2.new(0.6, 0, 1, 0); title.Position = UDim2.new(0, 18, 0, 0)
    title.Text = "XLR7 HUB - LAGGER"; title.TextColor3 = Color3.new(1,1,1); title.Font = "GothamBold"; title.TextSize = 15; title.TextXAlignment = "Left"; title.BackgroundTransparency = 1

    local pingLog = Instance.new("TextLabel", header); pingLog.Size = UDim2.new(0, 85, 0, 20); pingLog.Position = UDim2.new(1, -125, 0.5, -10)
    pingLog.TextColor3 = Color3.fromRGB(0, 255, 255); pingLog.Font = "Code"; pingLog.TextSize = 13; pingLog.BackgroundTransparency = 1
    task.spawn(function() while task.wait(0.5) do pcall(function() pingLog.Text = ":ping " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) .. " -" end) end end)

    local miniIcon = Instance.new("TextButton", gui); miniIcon.Size = UDim2.new(0, 45, 0, 45); miniIcon.Position = UDim2.new(0.1, 0, 0.1, 0); miniIcon.Text = "XLR7"; miniIcon.Visible = false; miniIcon.Draggable = true; miniIcon.BackgroundColor3 = Color3.fromRGB(5, 15, 30); miniIcon.TextColor3 = Color3.new(0, 0.8, 1); Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1,0)
    local minBtn = Instance.new("TextButton", header); minBtn.Size = UDim2.new(0, 30, 0, 30); minBtn.Position = UDim2.new(1, -35, 0.5, -15); minBtn.Text = "-"; minBtn.TextColor3 = Color3.new(1,1,1); minBtn.BackgroundTransparency = 1; minBtn.TextSize = 25
    
    minBtn.MouseButton1Click:Connect(function() main.Visible = false; miniIcon.Visible = true end)
    miniIcon.MouseButton1Click:Connect(function() main.Visible = true; miniIcon.Visible = false end)

    -- [ CONTENT ]
    local container = Instance.new("ScrollingFrame", main); container.Size = UDim2.new(1, 0, 1, -90); container.Position = UDim2.new(0, 0, 0, 60); container.BackgroundTransparency = 1; container.ScrollBarThickness = 0
    Instance.new("UIListLayout", container).HorizontalAlignment = "Center"; Instance.new("UIPadding", container).PaddingTop = UDim.new(0, 5)

    local function createModule(name, callback, min, max, default, sliderCallback)
        local card = Instance.new("Frame", container); card.Size = UDim2.new(0, 285, 0, 110); card.BackgroundColor3 = Color3.fromRGB(255, 255, 255); card.BackgroundTransparency = 0.96; Instance.new("UICorner", card)
        Instance.new("UIStroke", card).Color = Color3.fromRGB(30, 40, 60)

        local tgl = Instance.new("TextButton", card); tgl.Size = UDim2.new(0, 75, 0, 30); tgl.Position = UDim2.new(1, -85, 0, 12); tgl.BackgroundColor3 = Color3.fromRGB(0, 160, 255); tgl.Text = "ON"; tgl.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tgl)
        tgl.MouseButton1Click:Connect(function() local s = callback(); tgl.Text = s and "ON" or "OFF"; tgl.BackgroundColor3 = s and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(40, 45, 60) end)
        
        local l = Instance.new("TextLabel", card); l.Text = name:upper(); l.Size = UDim2.new(0.6,0,0,30); l.Position = UDim2.new(0,12,0,10); l.TextColor3 = Color3.new(1,1,1); l.Font = "GothamBold"; l.BackgroundTransparency = 1; l.TextXAlignment = "Left"
        local vL = Instance.new("TextLabel", card); vL.Text = "INTENSITY: "..default; vL.Position = UDim2.new(0,12,0,45); vL.TextColor3 = Color3.fromRGB(150,150,150); vL.BackgroundTransparency = 1; vL.TextXAlignment = "Left"; vL.TextSize = 10

        local bar = Instance.new("TextButton", card); bar.Size = UDim2.new(0, 260, 0, 5); bar.Position = UDim2.new(0.5, -130, 0, 85); bar.BackgroundColor3 = Color3.fromRGB(40, 45, 60); bar.Text = ""; Instance.new("UICorner", bar)
        local fill = Instance.new("Frame", bar); fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 220, 255); Instance.new("UICorner", fill)
        local knob = Instance.new("Frame", bar); knob.Size = UDim2.new(0, 16, 0, 16); knob.AnchorPoint = Vector2.new(0.5, 0.5); knob.Position = UDim2.new((default-min)/(max-min), 0, 0.5, 0); knob.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

        local dragging = false
        local function move(i)
            local r = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(r, 0, 0.5, 0); fill.Size = UDim2.new(r, 0, 1, 0)
            local v = math.floor(min + (r * (max-min))); vL.Text = "INTENSITY: "..v; sliderCallback(v)
        end
        bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; move(i) end end)
        UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then move(i) end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    end

    createModule("Network Lag", function() isLagging = not isLagging return isLagging end, 1, 500, 124, function(v) packetMultiplier = v end)
    createModule("Speed Booster", function() speedActive = not speedActive return speedActive end, 1, 300, 54, function(v) walkSpeedVal = v end)

    RunService.Heartbeat:Connect(function()
        if speedActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hum = player.Character.Humanoid
            player.Character.HumanoidRootPart.Velocity = Vector3.new(hum.MoveDirection.X * walkSpeedVal, player.Character.HumanoidRootPart.Velocity.Y, hum.MoveDirection.Z * walkSpeedVal)
        end
        if isLagging and target then for i = 1, packetMultiplier do pcall(function() target:FireServer(uuid, string.rep("x", 5000)) end) end end
    end)
end

-- [[ SYSTEM LOGIN ]]
if whitelistDatabase[LPlayerName] then
    local kG = Instance.new("ScreenGui", player.PlayerGui)
    local kF = Instance.new("Frame", kG); kF.Size = UDim2.new(0, 300, 0, 160); kF.Position = UDim2.new(0.5, -150, 0.5, -80); kF.BackgroundColor3 = Color3.fromRGB(5, 10, 20); Instance.new("UICorner", kF)
    Instance.new("UIStroke", kF).Color = Color3.fromRGB(0, 200, 255)
    local kI = Instance.new("TextBox", kF); kI.Size = UDim2.new(0.8, 0, 0, 40); kI.Position = UDim2.new(0.1, 0, 0.3, 0); kI.PlaceholderText = "Paste Ticket Key..."; kI.BackgroundColor3 = Color3.fromRGB(15, 20, 35); kI.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", kI)
    local sB = Instance.new("TextButton", kF); sB.Size = UDim2.new(0.8, 0, 0, 35); sB.Position = UDim2.new(0.1, 0, 0.65, 0); sB.Text = "LOGIN TO XLR7"; sB.BackgroundColor3 = Color3.fromRGB(0, 160, 255); sB.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", sB)
    sB.MouseButton1Click:Connect(function() if string.gsub(kI.Text, "%s+", "") == whitelistDatabase[LPlayerName] then kG:Destroy(); StartScript() else SecureKick() end end)
else SecureKick() end
