-- [[ ESP ANTI-INVIS: CHỐNG TÀNG HÌNH + HIGHLIGHT ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 1. TẠO THÔNG BÁO VIỀN CẦU VỒNG (RGB NOTIFICATION)
-- ==========================================
local function KGM_Notification(title, text)
    -- Lấy vị trí đặt GUI an toàn
    local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    
    -- Xóa thông báo cũ nếu bấm chạy script nhiều lần
    if targetGui:FindFirstChild("KGM_RainbowNotif") then
        targetGui.KGM_RainbowNotif:Destroy()
    end

    -- Tạo ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name = "KGM_RainbowNotif"
    sg.Parent = targetGui

    -- Khung thông báo
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 70)
    frame.Position = UDim2.new(1, 20, 1, -100) -- Nằm ẩn bên ngoài góc phải màn hình
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Màu nền xám đen giống Roblox
    frame.BorderSizePixel = 0
    frame.Parent = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    -- VIỀN CẦU VỒNG
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2.5
    stroke.Parent = frame

    -- Chữ Tiêu đề
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 30)
    titleLbl.Position = UDim2.new(0, 10, 0, 5)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 16
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = frame

    -- Chữ Nội dung
    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, -20, 0, 30)
    textLbl.Position = UDim2.new(0, 10, 0, 30)
    textLbl.BackgroundTransparency = 1
    textLbl.Text = text
    textLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLbl.Font = Enum.Font.Gotham
    textLbl.TextSize = 14
    textLbl.TextWrapped = true
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.Parent = frame

    -- Hiệu ứng trượt vào
    local slideIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -270, 1, -100)})
    slideIn:Play()

    -- Vòng lặp chạy màu RGB cho viền
    local hue = 0
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        hue = hue + dt * 0.4 -- Tốc độ chuyển màu cầu vồng (Chỉnh số 0.4 to lên thì đổi màu nhanh hơn)
        if hue >= 1 then hue = 0 end
        stroke.Color = Color3.fromHSV(hue, 1, 1)
    end)

    -- Tự động trượt ra và xóa sau 5 giây
    task.delay(5, function()
        local slideOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 1, -100)})
        slideOut:Play()
        slideOut.Completed:Wait()
        connection:Disconnect()
        sg:Destroy()
    end)
end

-- KÍCH HOẠT THÔNG BÁO NGAY KHI CHẠY SCRIPT
KGM_Notification("By KieuGiaMinh", "KGM")


-- ==========================================
-- 2. HỆ THỐNG ESP CHỐNG TÀNG HÌNH
-- ==========================================
-- Hàm tạo Khung và Tên (Cái này miễn nhiễm với Tàng Hình)
local function CreateAntiInvisTracker(character, player)
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    -- Tránh tạo trùng lặp
    if hrp:FindFirstChild("KGM_Tracker") then return end

    -- Tạo BillboardGui (Bảng tên luôn hiện trên màn hình)
    local bb = Instance.new("BillboardGui")
    bb.Name = "KGM_Tracker"
    bb.AlwaysOnTop = true -- Luôn hiện xuyên tường
    bb.Size = UDim2.new(4, 0, 5, 0) -- Kích thước khung to vừa bằng người
    bb.Adornee = hrp
    bb.Parent = hrp

    -- Khung đỏ mờ bao quanh người
    local frame = Instance.new("Frame")
    frame.Parent = bb
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.7
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Parent = frame
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Thickness = 1

    -- Tên người chơi
    local txt = Instance.new("TextLabel")
    txt.Parent = frame
    txt.Size = UDim2.new(1, 0, 0.2, 0)
    txt.Position = UDim2.new(0, 0, -0.25, 0)
    txt.BackgroundTransparency = 1
    txt.Text = player.Name
    txt.TextColor3 = Color3.fromRGB(255, 255, 0) -- Chữ Vàng
    txt.TextStrokeTransparency = 0 -- Viền chữ đen
    txt.Font = Enum.Font.GothamBold
    txt.TextScaled = true
end

-- Hàm tạo Highlight phát sáng
local function CreateHighlight(character)
    if character:FindFirstChild("KGM_Highlight") then return end
    local hl = Instance.new("Highlight")
    hl.Name = "KGM_Highlight"
    hl.Adornee = character
    hl.Parent = character
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
end

-- Vòng lặp liên tục: CHỐNG TÀNG HÌNH
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            
            -- Ép những bộ phận bị tàng hình phải hiện mờ mờ
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    -- Nếu game chỉnh trong suốt = 1 (Tàng hình) -> Ép về 0.5 (Hiện bóng)
                    if part.Transparency >= 1 then
                        part.Transparency = 0.5
                    end
                end
            end
        end
    end
end)

-- Hàm tổng Setup cho 1 người chơi
local function SetupPlayer(player)
    if player == LocalPlayer then return end
    
    local function initChar(char)
        task.wait(0.5)
        pcall(function()
            CreateHighlight(char)
            CreateAntiInvisTracker(char, player)
        end)
    end

    if player.Character then initChar(player.Character) end
    player.CharacterAdded:Connect(initChar)
end

-- Áp dụng cho mọi người trong server
for _, player in pairs(Players:GetPlayers()) do
    SetupPlayer(player)
end
Players.PlayerAdded:Connect(SetupPlayer)

-- In báo cáo vào khung Chat
game.StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = ">> ĐÃ BẬT ESP CHỐNG TÀNG HÌNH! KHÔNG THỂ TRỐN! <<";
    Color = Color3.fromRGB(255, 0, 0);
    Font = Enum.Font.GothamBold;
    TextSize = 18;
})
