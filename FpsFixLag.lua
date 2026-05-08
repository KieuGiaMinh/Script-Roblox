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




-- new nut tele




-- [[ SCRIPT: KGM INSTANT NUKE (NÚT TELE FULL TỐI THƯỢNG) ]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or LP:WaitForChild("PlayerGui")

pcall(function()
    -- 1. Dọn dẹp UI cũ nếu có
    if targetGui:FindFirstChild("KGM_NukePanel") then targetGui.KGM_NukePanel:Destroy() end

    -- 2. Tạo Bảng Điều Khiển (Kéo Thả Được)
    local sg = Instance.new("ScreenGui", targetGui)
    sg.Name = "KGM_NukePanel"
    sg.ResetOnSpawn = false

    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 160, 0, 75)
    frame.Position = UDim2.new(0.5, -80, 0.15, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Active = true
    frame.Draggable = true -- Có thể kéo di chuyển mượt mà
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    -- Viền cầu vồng
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2.5

    -- Tiêu đề
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "By KieuGiaMinh"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15

    -- Nút TELE FULL
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 130, 0, 32)
    btn.Position = UDim2.new(0.5, -65, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = "tele full"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    -- Hiệu ứng cầu vồng chạy liên tục
    task.spawn(function()
        local hue = 0
        while task.wait(0.01) do
            hue = (hue + 0.01) % 1
            stroke.Color = Color3.fromHSV(hue, 1, 1)
        end
    end)

    -- 3. LOGIC TÀN SÁT (XÓA CÙNG LÚC & KHÔI PHỤC)
    local isNuked = false
    local hiddenParts = {}

    btn.MouseButton1Click:Connect(function()
        isNuked = not isNuked
        
        if isNuked then
            -- TRẠNG THÁI: TÀNG HÌNH TOÀN BỘ MAP (TĂNG FPS KỊCH TRẦN)
            btn.Text = "khôi phục"
            btn.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            -- Ép chết sương mù và nước
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then pcall(function() v:Destroy() end) end
            end
            Workspace.Terrain.WaterTransparency = 1
            Workspace.Terrain.Decoration = false

            -- Quét một phát ăn ngay toàn bộ vật thể
            for _, v in pairs(Workspace:GetDescendants()) do
                pcall(function()
                    if v:IsA("BasePart") and not v:IsDescendantOf(LP.Character) then
                        local p1 = v.Parent
                        -- Bỏ qua NPC và Quái vật (giữ lại để farm)
                        if not (p1 and p1:FindFirstChild("Humanoid")) then
                            hiddenParts[v] = v.Transparency -- Lưu lại để tí khôi phục
                            v.Transparency = 1
                            v.Material = Enum.Material.SmoothPlastic
                        end
                    -- Xóa sổ mọi hiệu ứng, vệt chém, hạt nhấp nháy, hình dán
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Light") or v:IsA("PointLight") or v:IsA("SurfaceLight") then
                        v.Enabled = false
                    elseif v:IsA("Decal") or v:IsA("Texture") then
                        v.Transparency = 1
                    end
                end)
            end
        else
            -- TRẠNG THÁI: KHÔI PHỤC
            btn.Text = "tele full"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            -- Lôi toàn bộ hình dạng ra lại cùng 1 lúc
            for part, trans in pairs(hiddenParts) do
                pcall(function() if part and part.Parent then part.Transparency = trans end end)
            end
            table.clear(hiddenParts) -- Xóa bộ nhớ dọn rác RAM
        end
    end)
end)
