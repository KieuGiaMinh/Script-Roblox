-- [[ SCRIPT: CLICK TELEPORT (Bản cập nhật Thông báo Cầu vồng) ]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local isTeleportEnabled = false

-- ==========================================
-- 1. TẠO THÔNG BÁO VIỀN CẦU VỒNG (RGB NOTIFICATION)
-- ==========================================
local function KGM_Notification(title, text)
    local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    
    if targetGui:FindFirstChild("KGM_RainbowNotif") then
        targetGui.KGM_RainbowNotif:Destroy()
    end

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
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 16
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
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
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.Parent = frame

    local slideIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -270, 1, -100)})
    slideIn:Play()

    local hue = 0
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        hue = hue + dt * 0.4
        if hue >= 1 then hue = 0 end
        stroke.Color = Color3.fromHSV(hue, 1, 1)
    end)

    task.delay(5, function()
        local slideOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 1, -100)})
        slideOut:Play()
        slideOut.Completed:Wait()
        connection:Disconnect()
        sg:Destroy()
    end)
end

-- KÍCH HOẠT THÔNG BÁO NGAY KHI CHẠY SCRIPT
KGM_Notification("KGM", "by KieuGiaMinh")

-- ==========================================
-- 2. GIAO DIỆN & TÍNH NĂNG TELEPORT
-- ==========================================
-- DỌN DẸP GUI CŨ
local guiName = "KGM_TeleportGUI"
local targetGuiParent = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")

if targetGuiParent:FindFirstChild(guiName) then
    targetGuiParent[guiName]:Destroy()
end

-- TẠO GIAO DIỆN (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetGuiParent

local MainButton = Instance.new("TextButton")
MainButton.Name = "ToggleButton"
MainButton.Size = UDim2.new(0, 100, 0, 35) -- Chỉnh size nút nhỏ lại một chút cho vừa chữ
MainButton.Position = UDim2.new(0.5, -50, 0.1, 0) 
MainButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Màu Đỏ
MainButton.Text = "Off tele" -- CHỮ MẶC ĐỊNH
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Font = Enum.Font.GothamBold
MainButton.TextSize = 16
MainButton.AutoButtonColor = false
MainButton.BorderSizePixel = 0
MainButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Parent = MainButton

-- KÉO THẢ NÚT (DRAG)
local dragging, dragInput, dragStart, startPos

MainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainButton.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- BẬT/TẮT BẰNG PHÍM ALT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end 
    
    if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
        isTeleportEnabled = not isTeleportEnabled
        
        if isTeleportEnabled then
            -- Khi BẬT
            MainButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Xanh
            MainButton.Text = "On" -- Đổi chữ
        else
            -- Khi TẮT
            MainButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Đỏ
            MainButton.Text = "Off tele" -- Đổi chữ
        end
    end
end)

-- CLICK CHUỘT TELEPORT
Mouse.Button1Down:Connect(function()
    if isTeleportEnabled then
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = Mouse.Hit.Position
            Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
        end
    end
end)
