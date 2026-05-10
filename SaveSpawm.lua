-- [[ SCRIPT: KGM SAVE SPAWN V2 (FIX LỖI GIẬT VỀ SPAWN MẶC ĐỊNH) ]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or LP:WaitForChild("PlayerGui")

pcall(function()
    -- 1. DỌN DẸP GIAO DIỆN
    if targetGui:FindFirstChild("KGM_SaveSpawn_V2") then targetGui.KGM_SaveSpawn_V2:Destroy() end
    if targetGui:FindFirstChild("KGM_RainbowNotif") then targetGui.KGM_RainbowNotif:Destroy() end

    -- ==========================================
    -- 2. THÔNG BÁO CẦU VỒNG CHUẨN KIỀU GIA MINH
    -- ==========================================
    local function KGM_Notification(title, text)
        local sgNotif = Instance.new("ScreenGui", targetGui)
        sgNotif.Name = "KGM_RainbowNotif"
        sgNotif.DisplayOrder = 999999

        local frameNotif = Instance.new("Frame", sgNotif)
        frameNotif.Size = UDim2.new(0, 260, 0, 70)
        frameNotif.Position = UDim2.new(1, 20, 1, -100)
        frameNotif.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        frameNotif.BorderSizePixel = 0
        Instance.new("UICorner", frameNotif).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke", frameNotif)
        stroke.Thickness = 2.5

        local titleLbl = Instance.new("TextLabel", frameNotif)
        titleLbl.Size = UDim2.new(1, -20, 0, 30)
        titleLbl.Position = UDim2.new(0, 10, 0, 5)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 16

        local textLbl = Instance.new("TextLabel", frameNotif)
        textLbl.Size = UDim2.new(1, -20, 0, 30)
        textLbl.Position = UDim2.new(0, 10, 0, 30)
        textLbl.BackgroundTransparency = 1
        textLbl.Text = text
        textLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
        textLbl.Font = Enum.Font.Gotham
        textLbl.TextSize = 13
        textLbl.TextWrapped = true

        TweenService:Create(frameNotif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -280, 1, -100)}):Play()

        local hue = 0
        local conn = RunService.RenderStepped:Connect(function(dt)
            hue = (hue + dt * 0.4) % 1
            stroke.Color = Color3.fromHSV(hue, 1, 1)
        end)

        task.delay(5, function()
            pcall(function()
                TweenService:Create(frameNotif, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 1, -100)}):Play()
                task.wait(0.5)
                conn:Disconnect()
                sgNotif:Destroy()
            end)
        end)
    end

    KGM_Notification("By KieuGiaMinh", "Save Spawn V2 đã bật! Chế độ hồi sinh tại chỗ bất chấp Anti-Cheat.")

    -- ==========================================
    -- 3. BẢNG ĐIỀU KHIỂN (DRAGGABLE - PC CHUẨN)
    -- ==========================================
    local sg = Instance.new("ScreenGui", targetGui)
    sg.Name = "KGM_SaveSpawn_V2"
    sg.ResetOnSpawn = false

    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 160, 0, 80)
    frame.Position = UDim2.new(0.5, -80, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.Active = true
    frame.Draggable = true 
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local strokeMain = Instance.new("UIStroke", frame)
    strokeMain.Thickness = 2.5

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "By KieuGiaMinh"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14

    local btnSave = Instance.new("TextButton", frame)
    btnSave.Size = UDim2.new(0, 130, 0, 35)
    btnSave.Position = UDim2.new(0.5, -65, 0, 35)
    btnSave.BackgroundColor3 = Color3.fromRGB(200, 40, 40) -- Mặc định Đỏ (OFF)
    btnSave.Text = "Save Spawn"
    btnSave.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnSave.Font = Enum.Font.GothamBold
    btnSave.TextSize = 14
    Instance.new("UICorner", btnSave).CornerRadius = UDim.new(0, 6)

    task.spawn(function()
        local hue = 0
        while task.wait(0.01) do
            hue = (hue + 0.01) % 1
            strokeMain.Color = Color3.fromHSV(hue, 1, 1)
        end
    end)

    -- ==========================================
    -- 4. LOGIC HỒI SINH TÀN BẠO
    -- ==========================================
    local isSaved = false
    local lastDeathPos = nil

    btnSave.MouseButton1Click:Connect(function()
        isSaved = not isSaved
        if isSaved then
            btnSave.BackgroundColor3 = Color3.fromRGB(40, 200, 40) -- Xanh (ON)
            KGM_Notification("Hệ Thống", "Đã KÍCH HOẠT lưu điểm hồi sinh!")
        else
            btnSave.BackgroundColor3 = Color3.fromRGB(200, 40, 40) -- Đỏ (OFF)
            lastDeathPos = nil
            KGM_Notification("Hệ Thống", "Đã TẮT chức năng lưu điểm.")
        end
    end)

    -- Hàm xử lý cưỡng chế tọa độ
    local function OnCharacterRespawn(char)
        if isSaved and lastDeathPos then
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                -- Ép tọa độ liên tục trong 0.5s để thắng lệnh của game
                task.spawn(function()
                    local startTime = tick()
                    while tick() - startTime < 0.6 do
                        hrp.CFrame = lastDeathPos
                        RunService.Heartbeat:Wait()
                    end
                end)
            end
        end

        -- Canh lúc mày dẹo để lưu tọa độ
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.Died:Connect(function()
                if isSaved then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        lastDeathPos = root.CFrame -- Lưu cả vị trí và hướng nhìn
                    end
                end
            end)
        end
    end

    -- Bắt nhịp hồi sinh
    LP.CharacterAdded:Connect(OnCharacterRespawn)
    if LP.Character then OnCharacterRespawn(LP.Character) end
end)
