-- บริการที่ต้องใช้ (Services)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ==========================================
-- 1. สร้าง GUI สำหรับปุ่มและเป้าเล็ง
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileShiftLockGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ตรวจสอบว่าเป็นอุปกรณ์จอสัมผัส (มือถือ) หรือไม่ (เพื่อซ่อน/แสดงปุ่มให้ถูกประเภทอุปกรณ์)
if not UserInputService.TouchEnabled then
	return
end

-- ปุ่ม Shift Lock (ตำแหน่งข้างๆ ปุ่มกระโดดของมือถือ)
local shiftButton = Instance.new("ImageButton")
shiftButton.Name = "ShiftLockButton"
shiftButton.Size = UDim2.new(0, 60, 0, 60)
-- ปรับตำแหน่งให้อยู่ฝั่งขวาล่าง เยื้องมาทางซ้ายของปุ่มกระโดดปกติ
shiftButton.Position = UDim2.new(1, -170, 1, -140) 
shiftButton.AnchorPoint = Vector2.new(0.5, 0.5)
shiftButton.BackgroundTransparency = 1
shiftButton.Image = "rbxasset://textures/ui/mouseLock_off@2x.png"
shiftButton.Visible = isMobile -- แสดงผลเฉพาะบนหน้าจอมือถือ/แท็บเล็ต
shiftButton.Parent = screenGui

-- เป้าเล็งกลางหน้าจอ (Crosshair)
local crosshair = Instance.new("ImageLabel")
crosshair.Name = "Crosshair"
crosshair.Size = UDim2.new(0, 50, 0, 50)
crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.BackgroundTransparency = 1
crosshair.Visible = false
crosshair.Parent = screenGui

-- [!] คำแนะนำสำหรับการใส่รูป 322373.png [!]
-- ให้นำไฟล์ 322373.png ไปอัปโหลดใน Roblox เพื่อรับ Asset ID 
-- จากนั้นให้นำตัวเลข ID มาใส่แทนที่ YOUR_ASSET_ID_HERE ด้านล่างนี้
-- ตัวอย่างเช่น: crosshair.Image = "rbxassetid://1234567890"
crosshair.Image = "rbxassetid://YOUR_ASSET_ID_HERE" 


-- ==========================================
-- 2. ระบบตรรกะและฟังก์ชันการทำงาน (Logic)
-- ==========================================
local isShiftLocked = false

-- ดึงข้อมูลตัวละคร
local function getCharacterData()
    local char = player.Character
    if not char then return nil, nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    return char, root, hum
end

-- ฟังก์ชันเปิด/ปิด Shift Lock
local function toggleShiftLock()
    isShiftLocked = not isShiftLocked

    if isShiftLocked then
        shiftButton.Image = "rbxasset://textures/ui/mouseLock_on@2x.png"
        crosshair.Visible = true
    else
        shiftButton.Image = "rbxasset://textures/ui/mouseLock_off@2x.png"
        crosshair.Visible = false

        -- คืนค่ามุมกล้องและการหันเมื่อปิดใช้งาน
        local _, _, hum = getCharacterData()
        if hum then
            hum.CameraOffset = Vector3.new(0, 0, 0)
            hum.AutoRotate = true
        end
    end
end

-- รับคำสั่งเมื่อกดปุ่ม (รองรับทั้งการสัมผัสบนมือถือและการคลิกเมาส์)
shiftButton.Activated:Connect(toggleShiftLock)

-- ==========================================
-- 3. ระบบประมวลผลการหมุนตัวละคร (Core Update Loop)
-- ==========================================
-- ใช้ BindToRenderStep พร้อม Priority เป็น Camera + 1 เพื่อให้การหมุนตัวละครเกิดขึ้น "หลัง" กล้องขยับ
-- วิธีนี้จะช่วยแก้ปัญหา "ตัวละครสั่น (Stuttering)" ได้ 100% 
RunService:BindToRenderStep("MobileShiftLockCore", Enum.RenderPriority.Camera.Value + 1, function()
    if not isShiftLocked then return end

    local char, root, hum = getCharacterData()
    local camera = workspace.CurrentCamera

    if root and hum and hum.Health > 0 then
        -- 1. เลื่อนมุมกล้องไปทางขวา (เอกลักษณ์ของ Shift Lock)
        hum.CameraOffset = Vector3.new(1.75, 0, 0)

        -- 2. ปิดการหันหน้าอัตโนมัติตามทิศทางการเดินของ Roblox เพื่อไม่ให้แย่งกันหัน
        hum.AutoRotate = false 

        -- 3. หันหน้าตัวละครตามมุมกล้องแบบสมูท
        -- คำนวณเฉพาะแกน X และ Z (ซ้าย-ขวา) โดยให้แกน Y เป็น 0 เพื่อป้องกันตัวละครเงยหรือก้มหน้า
        local camLook = camera.CFrame.LookVector
        local targetLook = Vector3.new(camLook.X, 0, camLook.Z).Unit

        -- ป้องกัน Error ในกรณีที่ผู้เล่นมองตรงลงพื้นดินหรือมองขึ้นฟ้าตรงๆ
        if targetLook.Magnitude > 0.1 then
            local currentPos = root.Position
            -- อัปเดต CFrame ของ HumanoidRootPart ทันที (ไร้การสั่น)
            root.CFrame = CFrame.lookAt(currentPos, currentPos + targetLook)
        end
    end
end)
