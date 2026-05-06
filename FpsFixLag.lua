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
