-- LocalScript: ระบบ Mobile Shift Lock
-- วางใน StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ตรวจสอบว่าเป็นอุปกรณ์หน้าจอสัมผัส (มือถือ/แท็บเล็ต) หรือไม่
-- (หากต้องการทดสอบในคอมพิวเตอร์ด้วย ให้ทำเครื่องหมาย -- ปิด 3 บรรทัดนี้ไว้)
if not UserInputService.TouchEnabled then
	return
end

-- 1. สร้าง GUI สำหรับปุ่ม Shift Lock
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileShiftLockGui"
screenGui.ResetOnSpawn = false -- ไม่ให้ GUI หายเวลาตาย
screenGui.Parent = player:WaitForChild("PlayerGui")

local shiftLockButton = Instance.new("ImageButton")
shiftLockButton.Name = "ShiftLockButton"
shiftLockButton.Size = UDim2.new(0, 60, 0, 60)
-- จุด AnchorPoint (1, 1) คือมุมขวาล่าง
shiftLockButton.AnchorPoint = Vector2.new(1, 1) 
-- ตำแหน่ง UDim2.new(1, -120, 1, -20) จะอยู่ข้างซ้ายของปุ่มกระโดดพอดี
shiftLockButton.Position = UDim2.new(1, -120, 1, -20) 
shiftLockButton.BackgroundTransparency = 1
shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_off.png" -- ไอคอน Shift Lock ดั้งเดิม
shiftLockButton.Parent = screenGui

-- 2. ตัวแปรสถานะ
local isShiftLocked = false
local renderSteppedName = "MobileShiftLockUpdate"

-- ฟังก์ชันดึงชิ้นส่วนตัวละคร
local function getCharacterParts(character)
	if not character then return nil, nil end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	return humanoid, rootPart
end

-- 3. ฟังก์ชันอัปเดตระบบ Shift Lock
local function updateShiftLockState()
	local character = player.Character
	local humanoid, rootPart = getCharacterParts(character)

	if isShiftLocked then
		-- เปิด Shift Lock
		shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_on.png"
		if humanoid then
			humanoid.CameraOffset = Vector3.new(1.75, 0, 0) -- ดันกล้องไปทางขวา
			humanoid.AutoRotate = false -- ปิดการหมุนตัวอัตโนมัติของเกม
		end
		
		-- บังคับให้ตัวละครหันหน้าตามกล้องตลอดเวลา (ผูกกับ RenderStep เพื่อความสมูท)
		RunService:BindToRenderStep(renderSteppedName, Enum.RenderPriority.Character.Value, function()
			if not player.Character then return end
			local hum, root = getCharacterParts(player.Character)
			
			-- ตรวจสอบว่ายังมีชีวิต และไม่ได้นั่งอยู่ (ถ้ากำลังนั่งไม่ควรบังคับหัน)
			if hum and root and hum.Health > 0 and not hum.Sit then
				local camLook = camera.CFrame.LookVector
				-- คำนวณตำแหน่งเป้าหมายให้ตัวละครหันไป (บนแกน X, Z แนวราบ)
				local targetPosition = root.Position + Vector3.new(camLook.X, 0, camLook.Z)
				root.CFrame = CFrame.lookAt(root.Position, targetPosition)
			end
		end)
	else
		-- ปิด Shift Lock
		shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_off.png"
		if humanoid then
			humanoid.CameraOffset = Vector3.new(0, 0, 0) -- คืนค่ากล้องไว้ตรงกลาง
			humanoid.AutoRotate = true -- เปิดการหมุนตัวอัตโนมัติตามปกติ
		end
		-- หยุดลูปบังคับหันหน้า
		RunService:UnbindFromRenderStep(renderSteppedName)
	end
end

-- 4. การกดปุ่ม
shiftLockButton.MouseButton1Click:Connect(function()
	isShiftLocked = not isShiftLocked
	updateShiftLockState()
end)

-- 5. จัดการระบบเมื่อตัวละครตายแล้วเกิดใหม่ (Respawn)
player.CharacterAdded:Connect(function(character)
	-- รอให้ชิ้นส่วนสำคัญโหลดเสร็จก่อน
	character:WaitForChild("Humanoid")
	character:WaitForChild("HumanoidRootPart")
	
	-- หากผู้เล่นยังเปิด Shift Lock ค้างไว้อยู่ก่อนตาย ให้ทำงานต่อ
	if isShiftLocked then
		updateShiftLockState()
	end
end)
