-- fix lag 

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer


-- 1. 

local function KGM_Notification(title, text)
    local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    if targetGui:FindFirstChild("KGM_RainbowNotif") then targetGui.KGM_RainbowNotif:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KGM_RainbowNotif"
    sg.Parent = targetGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 70)
    frame.Position = UDim2.new(1, 20, 1, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2.5
    stroke.Parent = frame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 30)
    titleLbl.Position = UDim2.new(0, 10, 0, 5)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(255, 215, 0) -- Mau vang cut
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 16
    titleLbl.Parent = frame

    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, -20, 0, 30)
    textLbl.Position = UDim2.new(0, 10, 0, 30)
    textLbl.BackgroundTransparency = 1
    textLbl.Text = text
    textLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLbl.Font = Enum.Font.Gotham
    textLbl.TextSize = 14
    textLbl.TextWrapped = true
    textLbl.Parent = frame

    local slideIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -270, 1, -100)})
    slideIn:Play()

    local hue = 0
    local connection = RunService.RenderStepped:Connect(function(dt)
        hue = hue + dt * 0.4
        if hue >= 1 then hue = 0 end
        stroke.Color = Color3.fromHSV(hue, 1, 1)
    end)

    task.delay(6, function()
        local slideOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 1, -100)})
        slideOut:Play()
        slideOut.Completed:Wait()
        connection:Disconnect()
        sg:Destroy()
    end)
end

-- Bắn thông báo ra màn hình
KGM_Notification("by KieuGiaMinh", "FPS Booster đã bật! Xóa sạch rác đồ họa ép xung máy mượt nhất.")


-- 2. phan xoa rac

task.spawn(function()
    -- Tắt bóng và ánh sáng nặng
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.ShadowSoftness = 0
    if sethiddenproperty then
        pcall(function() sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility) end)
    end

    -- xoa may
    for _, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("BlurEffect") then
            v:Destroy()
        end
    end

    -- nuoc
    Workspace.Terrain.WaterWaveSize = 0
    Workspace.Terrain.WaterWaveSpeed = 0
    Workspace.Terrain.WaterReflectance = 0
    Workspace.Terrain.WaterTransparency = 0

    -- min
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1 
        end
    end
end)




-- new nut tele full restore,black on off





-- [[ SCRIPT: KGM PC ULTIMATE NUKE V17 (FIX UI + XÓA INSTANT + TÀNG HÌNH NHÂN VẬT) ]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or LP:WaitForChild("PlayerGui")

pcall(function()
    -- 1. DIỆT SẠCH GIAO DIỆN LỖI CŨ
    if targetGui:FindFirstChild("KGM_V17") then targetGui.KGM_V17:Destroy() end

    -- 2. TẠO GIAO DIỆN MỚI (ÉP ZINDEX ĐỂ ĐÉO BAO GIỜ BỊ ĐÈ MẤT NÚT)
    local sg = Instance.new("ScreenGui", targetGui)
    sg.Name = "KGM_V17"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 9999 -- Bắt buộc nằm trên cùng màn hình

    -- MÀN HÌNH ĐEN CHO BLACK MODE (Nằm dưới cùng)
    local blackFrame = Instance.new("Frame", sg)
    blackFrame.Size = UDim2.new(1, 0, 1, 0)
    blackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blackFrame.BorderSizePixel = 0
    blackFrame.Visible = false -- Đổi sang Visible thay vì Transparency cho an toàn
    blackFrame.ZIndex = 1

    -- KHUNG BẢNG ĐIỀU KHIỂN (Nằm trên cùng)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 160, 0, 115)
    frame.Position = UDim2.new(0.5, -80, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.Active = true
    frame.Draggable = true 
    frame.ZIndex = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2.5
    stroke.Color = Color3.fromRGB(255, 0, 0)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "By KieuGiaMinh"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.ZIndex = 11

    local btnTele = Instance.new("TextButton", frame)
    btnTele.Size = UDim2.new(0, 130, 0, 32)
    btnTele.Position = UDim2.new(0.5, -65, 0, 35)
    btnTele.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btnTele.Text = "tele full"
    btnTele.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnTele.Font = Enum.Font.GothamBold
    btnTele.TextSize = 14
    btnTele.ZIndex = 11
    Instance.new("UICorner", btnTele).CornerRadius = UDim.new(0, 6)

    local btnBlack = Instance.new("TextButton", frame)
    btnBlack.Size = UDim2.new(0, 130, 0, 32)
    btnBlack.Position = UDim2.new(0.5, -65, 0, 75)
    btnBlack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btnBlack.Text = "black off"
    btnBlack.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnBlack.Font = Enum.Font.GothamBold
    btnBlack.TextSize = 14
    btnBlack.ZIndex = 11
    Instance.new("UICorner", btnBlack).CornerRadius = UDim.new(0, 6)

    -- Cầu vồng chạy viền an toàn
    task.spawn(function()
        local hue = 0
        while task.wait(0.01) do
            hue = (hue + 0.01) % 1
            stroke.Color = Color3.fromHSV(hue, 1, 1)
        end
    end)

    -- 3. LOGIC BLACK ON/OFF
    local isBlack = false
    btnBlack.MouseButton1Click:Connect(function()
        isBlack = not isBlack
        btnBlack.Text = isBlack and "black on" or "black off"
        btnBlack.TextColor3 = isBlack and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        blackFrame.Visible = isBlack
        pcall(function() RunService:Set3dRenderingEnabled(not isBlack) end)
    end)

    -- 4. LOGIC TELE FULL (XÓA CÙNG LÚC + TÀNG HÌNH ALL)
    local isNuked = false
    local hiddenParts = {}
    local hiddenEffects = {}

    local function TanSatTuyetDoi(v)
        pcall(function()
            -- Tàng hình 100% mọi thực thể (KỂ CẢ XÁC MÀY)
            if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") then
                if v.Transparency ~= 1 then
                    hiddenParts[v] = v.Transparency
                    v.Transparency = 1
                end
            -- Bóp cổ mọi hiệu ứng
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Light") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") or v:IsA("Highlight") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Explosion") then
                if v.Enabled == true then
                    hiddenEffects[v] = true
                    v.Enabled = false
                end
                if v:IsA("ParticleEmitter") then v.Rate = 0 end
            end
        end)
    end

    btnTele.MouseButton1Click:Connect(function()
        isNuked = not isNuked
        
        if isNuked then
            btnTele.Text = "khôi phục"
            btnTele.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            -- Tắt sạch sương mù
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, v in pairs(Lighting:GetChildren()) do pcall(function() v.Enabled = false end) end
            Workspace.Terrain.WaterTransparency = 1

            -- QUÉT CÙNG LÚC 100% ĐÉO CHỜ ĐỢI
            -- Càn quét Workspace
            local items = Workspace:GetDescendants()
            for i = 1, #items do TanSatTuyetDoi(items[i]) end
            
            -- Càn quét Camera (Nơi giấu skill ẩn của game)
            local camItems = Workspace.CurrentCamera:GetDescendants()
            for i = 1, #camItems do TanSatTuyetDoi(camItems[i]) end
            
            -- Càn quét thẳng vào nhân vật mày
            if LP.Character then
                local charItems = LP.Character:GetDescendants()
                for i = 1, #charItems do TanSatTuyetDoi(charItems[i]) end
            end
            
        else
            btnTele.Text = "tele full"
            btnTele.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            for v, trans in pairs(hiddenParts) do pcall(function() if v and v.Parent then v.Transparency = trans end end) end
            for v, _ in pairs(hiddenEffects) do pcall(function() if v and v.Parent then v.Enabled = true end end) end
            table.clear(hiddenParts)
            table.clear(hiddenEffects)
        end
    end)

    -- 5. LÍNH GÁC: GIẾT HIỆU ỨNG VŨ KHÍ LIÊN TỤC 60 FRAME/GIÂY
    RunService.RenderStepped:Connect(function()
        if isNuked then
            pcall(function()
                -- Giết mọi thứ spawn mới
                for _, v in pairs(Workspace.CurrentCamera:GetChildren()) do TanSatTuyetDoi(v) end
                
                -- Giết hiệu ứng vũ khí trên tay mày (Bất tử chém)
                if LP.Character then
                    for _, v in pairs(LP.Character:GetDescendants()) do
                        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Highlight") or v:IsA("Light") then
                            v.Enabled = false
                            if v:IsA("ParticleEmitter") then v.Rate = 0 end
                        elseif v:IsA("BasePart") then
                            v.Transparency = 1
                        end
                    end
                end
            end)
        end
    end)

    Workspace.DescendantAdded:Connect(function(v)
        if isNuked then task.defer(function() TanSatTuyetDoi(v) end) end
    end)
end)




