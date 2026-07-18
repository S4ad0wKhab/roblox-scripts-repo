-- LocalScript: ระบบ Mobile Shift Lock (พร้อมเป้าเล็งกึ่งกลางจอ)
-- วางใน StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ตรวจสอบว่าเป็นหน้าจอสัมผัสหรือไม่ (ถ้าทดสอบในคอมให้คอมเมนต์ 3 บรรทัดนี้ไว้)
if not UserInputService.TouchEnabled then
	return
end

-- 1. สร้าง GUI หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileShiftLockGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- 2. สร้างปุ่ม Shift Lock (มุมขวาล่าง ซ้ายของปุ่มกระโดด)
local shiftLockButton = Instance.new("ImageButton")
shiftLockButton.Name = "ShiftLockButton"
shiftLockButton.Size = UDim2.new(0, 60, 0, 60)
shiftLockButton.AnchorPoint = Vector2.new(1, 1) 
shiftLockButton.Position = UDim2.new(1, -120, 1, -20) 
shiftLockButton.BackgroundTransparency = 1
shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_off.png"
shiftLockButton.Parent = screenGui

-- 3. สร้างเป้าเล็ง (Crosshair) แบบในภาพตัวอย่าง
local crosshair = Instance.new("ImageLabel")
crosshair.Name = "Crosshair"
crosshair.Size = UDim2.new(0, 40, 0, 40) -- ขนาดเป้าเล็ง
crosshair.Position = UDim2.new(0.5, 0, 0.5, 0) -- กึ่งกลางจอ
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.BackgroundTransparency = 1
-- ใช้ไอคอนเป้าเล็งดั้งเดิมของ Roblox (ตรงกับภาพอ้างอิง)
crosshair.Image = "rbxasset://textures/MouseLockedCursor.png" 
crosshair.Visible = false -- ซ่อนไว้ก่อนเมื่อเริ่มเกม
crosshair.Parent = screenGui

-- 4. ตัวแปรสถานะ
local isShiftLocked = false
local renderSteppedName = "MobileShiftLockUpdate"

-- ฟังก์ชันดึงชิ้นส่วนตัวละคร
local function getCharacterParts(character)
	if not character then return nil, nil end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	return humanoid, rootPart
end

-- 5. ฟังก์ชันอัปเดตระบบ
local function updateShiftLockState()
	local character = player.Character
	local humanoid, rootPart = getCharacterParts(character)

	if isShiftLocked then
		-- เปิด Shift Lock
		shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_on.png"
		crosshair.Visible = true -- แสดงเป้าเล็งกลางจอ
		
		if humanoid then
			humanoid.CameraOffset = Vector3.new(1.75, 0, 0) -- ดันกล้องเยื้องขวา
			humanoid.AutoRotate = false -- ปิดการหมุนตัวอัตโนมัติ
		end
		
		-- บังคับให้ตัวละครหันตามกล้องตลอดเวลา
		-- (การหมุนตรงนี้ผู้เล่นอื่นจะเห็นด้วยโดยอัตโนมัติผ่าน Network Ownership)
		RunService:BindToRenderStep(renderSteppedName, Enum.RenderPriority.Character.Value, function()
			if not player.Character then return end
			local hum, root = getCharacterParts(player.Character)
			
			if hum and root and hum.Health > 0 and not hum.Sit then
				local camLook = camera.CFrame.LookVector
				-- ล็อกแกน Y ไว้ไม่ให้ตัวละครก้ม/เงยตามกล้อง
				local targetPosition = root.Position + Vector3.new(camLook.X, 0, camLook.Z)
				root.CFrame = CFrame.lookAt(root.Position, targetPosition)
			end
		end)
	else
		-- ปิด Shift Lock
		shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_off.png"
		crosshair.Visible = false -- ซ่อนเป้าเล็ง
		
		if humanoid then
			humanoid.CameraOffset = Vector3.new(0, 0, 0) -- กล้องกลับมาตรงกลาง
			humanoid.AutoRotate = true -- เปิดการหมุนตัวตามปกติ
		end
		
		RunService:UnbindFromRenderStep(renderSteppedName)
	end
end

-- 6. ตรวจจับการกดปุ่ม
shiftLockButton.MouseButton1Click:Connect(function()
	isShiftLocked = not isShiftLocked
	updateShiftLockState()
end)

-- 7. จัดการระบบเมื่อเกิดใหม่
player.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid")
	character:WaitForChild("HumanoidRootPart")
	
	-- รีเซ็ตและใช้สถานะเดิมของ Shift Lock อย่างต่อเนื่อง
	if isShiftLocked then
		updateShiftLockState()
	end
end)
