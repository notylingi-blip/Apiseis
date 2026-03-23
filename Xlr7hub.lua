-- [[ XLR7 HUB - v6.4 RADIUS "O" FIX ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local _p = Players.LocalPlayer
getgenv().LockEnabled = false
getgenv().UnwalkEnabled = false
getgenv().FloatEnabled = false
getgenv().HitboxEnabled = false
getgenv().PlayerSpeed = 20
getgenv().LockRadius = 150

local AllUI = {} 

-- [[ 1. RADIUS VISUAL "O" SHAPE ]] --
local RadiusPart = Instance.new("Part")
RadiusPart.Name = "XLR7_Radius"
RadiusPart.Transparency = 1
RadiusPart.Anchored = true
RadiusPart.CanCollide = false
RadiusPart.Parent = workspace

local Ring = Instance.new("CylinderHandleAdornment")
Ring.Parent = RadiusPart
Ring.Adornee = RadiusPart
Ring.Height = 0.05 -- Tipis kayak garis
Ring.InnerRadius = getgenv().LockRadius - 1 -- Membuat efek "O" (Bolong tengah)
Ring.Radius = getgenv().LockRadius
Ring.Transparency = 0.3
Ring.Color3 = Color3.new(1, 1, 1)
Ring.AlwaysOnTop = false

RunService.RenderStepped:Connect(function()
    local char = _p.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root and getgenv().LockEnabled then
        -- POSISI AGAK ATASAN (Gak nempel tanah banget)
        RadiusPart.CFrame = CFrame.new(root.Position - Vector3.new(0, 2.5, 0)) * CFrame.Angles(math.rad(90), 0, 0)
        Ring.Visible = true
        Ring.Radius = getgenv().LockRadius
        Ring.InnerRadius = getgenv().LockRadius - 1.5 -- Ketebalan garis "O"
    else
        Ring.Visible = false
    end
end)

-- [[ 2. GLOBAL HITBOX ]] --
RunService.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= _p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            if getgenv().HitboxEnabled then
                hrp.Size = Vector3.new(20, 20, 20) 
                hrp.Transparency = 0.7 
                hrp.Color = Color3.new(1, 1, 1)
                hrp.AlwaysOnTop = true
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end
end)

-- [[ 3. ORIGINAL LOGIC RECOVERY ]] --
local function MakeDraggable(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true dragStart = input.Position startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function() dragToggle = false end)
end

local _plt, _fConn
local function ToggleFloat(state)
    if state then
        _plt = Instance.new("Part"); _plt.Size = Vector3.new(7, 1, 7); _plt.Anchored = true; _plt.CanCollide = true;
        _plt.Transparency = 0.5; _plt.Color = Color3.fromRGB(0, 85, 255); _plt.Parent = workspace
        _fConn = RunService.RenderStepped:Connect(function()
            if _p.Character and _p.Character:FindFirstChild("HumanoidRootPart") and _plt then 
                _plt.Position = _p.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0) 
            end
        end)
    else
        if _fConn then _fConn:Disconnect() end
        if _plt then _plt:Destroy() end
    end
end

RunService.Stepped:Connect(function()
    if not _p.Character then return end
    local r = _p.Character:FindFirstChild("HumanoidRootPart")
    local h = _p.Character:FindFirstChild("Humanoid")
    if r and h and h.Health > 0 then
        if getgenv().UnwalkEnabled then for _, t in pairs(h:GetPlayingAnimationTracks()) do t:Stop(0) end end
        if getgenv().LockEnabled then
            local target, sDist = nil, getgenv().LockRadius
            for _, other in pairs(Players:GetPlayers()) do
                if other ~= _p and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                    local tR = other.Character.HumanoidRootPart
                    local d = (tR.Position - r.Position).Magnitude
                    if d < sDist then sDist = d target = tR end
                end
            end
            if target then
                r.CFrame = r.CFrame:Lerp(CFrame.lookAt(r.Position, target.Position), 0.1)
                local tPos = target.Position + (target.CFrame.LookVector * 3.5)
                if (tPos - r.Position).Magnitude > 0.5 then
                    local mDir = (tPos - r.Position).Unit
                    r.Velocity = Vector3.new(mDir.X*getgenv().PlayerSpeed, mDir.Y*getgenv().PlayerSpeed, mDir.Z*getgenv().PlayerSpeed)
                else r.Velocity = Vector3.new(0,0,0) end
                h.PlatformStand = true
            else h.PlatformStand = false end
        else h.PlatformStand = false end
        if not getgenv().LockEnabled then
            local mDir = h.MoveDirection
            if mDir.Magnitude > 0 then r.Velocity = Vector3.new(mDir.X*getgenv().PlayerSpeed, r.Velocity.Y, mDir.Z*getgenv().PlayerSpeed) end
        end
    end
end)

-- [[ 4. UI CONSTRUCTION ]] --
local Screen = Instance.new("ScreenGui", CoreGui)
local Dis = Instance.new("TextLabel", Screen)
Dis.Size = UDim2.new(0, 300, 0, 30); Dis.Position = UDim2.new(0.5, -150, 0.5, -15);
Dis.BackgroundTransparency = 1; Dis.Text = "Discord: discord.gg/ZxefdezK3";
Dis.TextColor3 = Color3.new(1, 1, 1); Dis.Font = Enum.Font.Arcade; Dis.TextSize = 18;

local MT = Instance.new("Frame", Screen); MT.Size = UDim2.new(0, 80, 0, 35); MT.Position = UDim2.new(0, 10, 0.1, 0); MT.BackgroundColor3 = Color3.new(0,0,0);
Instance.new("UICorner", MT).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", MT).Color = Color3.new(1,1,1);
local MB = Instance.new("TextButton", MT); MB.Size = UDim2.new(1,0,1,0); MB.BackgroundTransparency = 1; MB.Text = "XLR7"; MB.TextColor3 = Color3.new(1,1,1); MB.Font = Enum.Font.Arcade; MB.TextSize = 18;
MakeDraggable(MT)

local function MkMod(txt, conf, pos, cb)
    local f = Instance.new("Frame", Screen); f.Size = UDim2.new(0, 100, 0, 40); f.Position = pos; f.BackgroundColor3 = Color3.fromRGB(12,12,12);
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", f).Color = Color3.new(1,1,1);
    table.insert(AllUI, f); MakeDraggable(f)
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(1,0,1,0); b.BackgroundTransparency = 1; b.Text = txt..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Arcade; b.TextSize = 14;
    b.MouseButton1Click:Connect(function() getgenv()[conf] = not getgenv()[conf]; b.Text = txt..": "..(getgenv()[conf] and "ON" or "OFF"); b.TextColor3 = getgenv()[conf] and Color3.fromRGB(0, 255, 150) or Color3.new(1,1,1); if cb then cb(getgenv()[conf]) end end)
end

MkMod("LOCK", "LockEnabled", UDim2.new(1, -110, 0.1, 0))
MkMod("UNWALK", "UnwalkEnabled", UDim2.new(1, -110, 0.1, 45))
MkMod("FLOAT", "FloatEnabled", UDim2.new(1, -110, 0.1, 90), function(s) ToggleFloat(s) end)
MkMod("HITBOX", "HitboxEnabled", UDim2.new(1, -110, 0.1, 135))

local HB = Instance.new("Frame", Screen); HB.Size = UDim2.new(0, 200, 0, 120); HB.Position = UDim2.new(0.5, -100, 0.1, 0); HB.BackgroundColor3 = Color3.fromRGB(15, 15, 15);
Instance.new("UICorner", HB).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", HB).Color = Color3.new(1, 1, 1); table.insert(AllUI, HB); MakeDraggable(HB)

local Title = Instance.new("TextLabel", HB); Title.Size = UDim2.new(1, 0, 0, 35); Title.Text = "XLR7 HUB"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = Enum.Font.Arcade; Title.TextSize = 20; Title.BackgroundTransparency = 1;

function MkIn(p, y, c)
    local b = Instance.new("TextBox", HB); b.Size = UDim2.new(1, -20, 0, 25); b.Position = UDim2.new(0, 10, 0, y); b.PlaceholderText = p; b.Text = ""; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.fromRGB(0, 255, 150); b.Font = Enum.Font.Arcade;
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5);
    b.FocusLost:Connect(function() local n = tonumber(b.Text:match("%d+")); if n then getgenv()[c] = n; b.Text = p:split(" ")[1] .. ": " .. n end end)
end
MkIn("SPEED (0-150)", 40, "PlayerSpeed")
MkIn("RADIUS (10-300)", 75, "LockRadius")

local Visible = true
MB.MouseButton1Click:Connect(function() Visible = not Visible; for _, ui in pairs(AllUI) do ui.Visible = Visible end; MB.TextColor3 = Visible and Color3.new(1,1,1) or Color3.fromRGB(255, 50, 50) end)

print("💀 XLR7 HUB v6.4 - RADIUS 'O' STABLE READY 💀")

