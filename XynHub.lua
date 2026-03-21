-- [[ XYN HUB V2.1 - SCROLLABLE EDITION ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local flags = {atk = false, aim = false, esp = false, hit = false, xray = false, rag = false}

-- ================= FUNCTIONS =================
local function removeItems(name)
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character then
            local obj = v.Character:FindFirstChild(name)
            if obj then obj:Destroy() end
        end
    end
end

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    if flags.rag and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        h.Health = h.MaxHealth
        if h:GetState() == Enum.HumanoidStateType.Ragdoll or h:GetState() == Enum.HumanoidStateType.FallingDown then
            h:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    end

    if flags.aim then
        local target, dist = nil, 40
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local d = (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d target = v.Character.HumanoidRootPart end
            end
        end
        if target and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(player.Character.HumanoidRootPart.Position, Vector3.new(target.Position.X, player.Character.HumanoidRootPart.Position.Y, target.Position.Z))
        end
    end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character then
            if flags.esp and not v.Character:FindFirstChild("XynESP") then
                local head = v.Character:FindFirstChild("Head")
                if head then
                    local bb = Instance.new("BillboardGui", v.Character)
                    bb.Name = "XynESP"; bb.Adornee = head; bb.Size = UDim2.new(0, 100, 0, 30); bb.AlwaysOnTop = true
                    local l = Instance.new("TextLabel", bb)
                    l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.Text = v.Name; l.TextColor3 = Color3.fromRGB(255, 0, 255); l.Font = Enum.Font.Arcade; l.TextScaled = true
                end
            end
            if flags.hit and not v.Character:FindFirstChild("XynHitbox") then
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local hb = Instance.new("BoxHandleAdornment", v.Character)
                    hb.Name = "XynHitbox"; hb.Adornee = hrp; hb.Size = Vector3.new(4, 6, 2); hb.Color3 = Color3.fromRGB(128, 0, 128); hb.Transparency = 0.6; hb.AlwaysOnTop = true
                end
            end
        end
    end

    if flags.xray then
        local p = Workspace:FindFirstChild("Plots")
        if p then for _, pl in pairs(p:GetChildren()) do if pl:IsA("Model") and pl:FindFirstChild("Decorations") then for _, pr in pairs(pl.Decorations:GetDescendants()) do if pr:IsA("BasePart") then pr.Transparency = 0.8 end end end end end
    end
end)

-- ================= UI WITH SCROLLING =================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
Main.Size = UDim2.new(0, 140, 0, 200) -- Ukuran Frame lu balik pendek
Main.Position = UDim2.new(0.05, 0, 0.35, 0)
Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 25); TopBar.BackgroundColor3 = Color3.fromRGB(10, 50, 120)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "⚡ XYN HUB"; Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.BackgroundTransparency = 1

-- SCROLLING CONTAINER
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -30)
Scroll.Position = UDim2.new(0, 0, 0, 30)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 300) -- Area scroll buat nampung semua tombol
Scroll.ScrollBarThickness = 2
Scroll.BorderSizePixel = 0

local function CreateButton(text, yPos, callback)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(0.85, 0, 0, 35)
    Btn.Position = UDim2.new(0.075, 0, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    Btn.Text = text; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 10
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    Btn.MouseButton1Click:Connect(function() callback(Btn) end)
end

-- TOMBOL DALEM SCROLL
CreateButton("AUTO BAT: OFF", 10, function(b) flags.atk = not flags.atk b.Text = "AUTO BAT: "..(flags.atk and "ON" or "OFF") end)
CreateButton("AIMBOT: OFF", 50, function(b) flags.aim = not flags.aim b.Text = "AIMBOT: "..(flags.aim and "ON" or "OFF") end)
CreateButton("ESP NAME: OFF", 90, function(b) flags.esp = not flags.esp if not flags.esp then removeItems("XynESP") end b.Text = "ESP NAME: "..(flags.esp and "ON" or "OFF") end)
CreateButton("HITBOX: OFF", 130, function(b) flags.hit = not flags.hit if not flags.hit then removeItems("XynHitbox") end b.Text = "HITBOX: "..(flags.hit and "ON" or "OFF") end)
CreateButton("X-RAY: OFF", 170, function(b) flags.xray = not flags.xray b.Text = "X-RAY: "..(flags.xray and "ON" or "OFF") end)
CreateButton("ANTI RAGDOLL: OFF", 210, function(b) flags.rag = not flags.rag b.Text = "ANTI RAGDOLL: "..(flags.rag and "ON" or "OFF") end)
