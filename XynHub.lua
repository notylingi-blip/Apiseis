-- [[ XYN HUB V1.4 - FIX TOGGLE CLEANUP ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local attacking, aimbotEnabled = false, false
local espEnabled, hitboxEnabled = false, false

-- ================= CLEANUP FUNCTIONS =================
local function removeAllESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character then
            local esp = v.Character:FindFirstChild("XynESP")
            if esp then esp:Destroy() end
        end
    end
end

local function removeAllHitbox()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character then
            local hb = v.Character:FindFirstChild("XynHitbox")
            if hb then hb:Destroy() end
        end
    end
end

-- ================= CORE LOGIC =================
local function equipBat()
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local bat = player.Backpack:FindFirstChild("Bat") or char:FindFirstChild("Bat")
    if bat then
        char.Humanoid:EquipTool(bat)
        return bat
    end
end

local function autoAttack()
    task.spawn(function()
        while attacking do
            local bat = equipBat()
            if bat then bat:Activate() end
            task.wait(0.1)
        end
    end)
end

-- MAIN LOOP (ESP, HITBOX, AIMBOT)
RunService.RenderStepped:Connect(function()
    -- AIMBOT LOGIC
    if aimbotEnabled then
        local closest, dist = nil, 40
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local d = (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d closest = v.Character.HumanoidRootPart end
            end
        end
        if closest and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(closest.Position.X, hrp.Position.Y, closest.Position.Z))
        end
    end

    -- ESP & HITBOX RE-APPLY OR STOP
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character then
            -- ESP Logic
            if espEnabled then
                if not v.Character:FindFirstChild("XynESP") then
                    local head = v.Character:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui", v.Character)
                        bb.Name = "XynESP"
                        bb.Adornee = head
                        bb.Size = UDim2.new(0, 200, 0, 50)
                        bb.AlwaysOnTop = true
                        local l = Instance.new("TextLabel", bb)
                        l.Size = UDim2.new(1, 0, 1, 0)
                        l.BackgroundTransparency = 1
                        l.Text = v.DisplayName or v.Name
                        l.TextColor3 = Color3.fromRGB(255, 0, 255)
                        l.Font = Enum.Font.Arcade
                        l.TextScaled = true
                    end
                end
            end
            
            -- Hitbox Logic
            if hitboxEnabled then
                if not v.Character:FindFirstChild("XynHitbox") then
                    local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local hb = Instance.new("BoxHandleAdornment", v.Character)
                        hb.Name = "XynHitbox"
                        hb.Adornee = hrp
                        hb.Size = Vector3.new(4, 6, 2)
                        hb.Color3 = Color3.fromRGB(128, 0, 128)
                        hb.Transparency = 0.6
                        hb.AlwaysOnTop = true
                    end
                end
            end
        end
    end
end)

-- ================= UI SYSTEM (ORIGINAL) =================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
Main.Size = UDim2.new(0, 140, 0, 240)
Main.Position = UDim2.new(0.05, 0, 0.35, 0)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 50, 120)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "⚡ XYN HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1

local function CreateButton(text, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.8, 0, 0, 35)
    Btn.Position = pos
    Btn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    Btn.MouseButton1Click:Connect(function() callback(Btn) end)
end

CreateButton("AUTO BAT: OFF", UDim2.new(0.1, 0, 0, 40), function(b)
    attacking = not attacking
    b.Text = attacking and "AUTO BAT: ON" or "AUTO BAT: OFF"
    b.BackgroundColor3 = attacking and Color3.fromRGB(50, 200, 120) or Color3.fromRGB(50, 120, 200)
    if attacking then autoAttack() end
end)

CreateButton("AIMBOT: OFF", UDim2.new(0.1, 0, 0, 85), function(b)
    aimbotEnabled = not aimbotEnabled
    b.Text = aimbotEnabled and "AIMBOT: ON" or "AIMBOT: OFF"
    b.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(250, 150, 50) or Color3.fromRGB(50, 120, 200)
end)

CreateButton("ESP NAME: OFF", UDim2.new(0.1, 0, 0, 130), function(b)
    espEnabled = not espEnabled
    if not espEnabled then removeAllESP() end
    b.Text = espEnabled and "ESP NAME: ON" or "ESP NAME: OFF"
    b.BackgroundColor3 = espEnabled and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(50, 120, 200)
end)

CreateButton("HITBOX: OFF", UDim2.new(0.1, 0, 0, 175), function(b)
    hitboxEnabled = not hitboxEnabled
    if not hitboxEnabled then removeAllHitbox() end
    b.Text = hitboxEnabled and "HITBOX: ON" or "HITBOX: OFF"
    b.BackgroundColor3 = hitboxEnabled and Color3.fromRGB(128, 0, 128) or Color3.fromRGB(50, 120, 200)
end)
