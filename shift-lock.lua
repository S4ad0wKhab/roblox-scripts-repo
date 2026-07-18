-- LocalScript: ระบบ Mobile Shift Lock (แก้ปัญหากล้องและตัวละครสั่น)
-- วางใน StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ตรวจสอบหน้าจอสัมผัส (ถ้าทดสอบในคอมให้คอมเมนต์ 3 บรรทัดนี้ไว้)
if not UserInputService.TouchEnabled then
	return
end

-- 1. สร้าง GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileShiftLockGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local shiftLockButton = Instance.new("ImageButton")
shiftLockButton.Name = "ShiftLockButton"
shiftLockButton.Size = UDim2.new(0, 60, 0, 60)
shiftLockButton.AnchorPoint = Vector2.new(1, 1) 
shiftLockButton.Position = UDim2.new(1, -120, 1, -20) 
shiftLockButton.BackgroundTransparency = 1
shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_off.png"
shiftLockButton.Parent = screenGui

local crosshair = Instance.new("ImageLabel")
crosshair.Name = "Crosshair"
crosshair.Size = UDim2.new(0, 40, 0, 40)
crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.BackgroundTransparency = 1
crosshair.Image = "rbxasset://textures/MouseLockedCursor.png" 
crosshair.Visible = false
crosshair.Parent = screenGui

-- 2. ตัวแปรสถานะ
local isShiftLocked = false
local renderSteppedName = "MobileShiftLockUpdate"

-- 3. ฟังก์ชันเตรียมระบบฟิสิกส์หันหน้า (AlignOrientation)
local function setupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	-- สร้างจุดอ้างอิงให้ระบบฟิสิกส์
	local attachment = rootPart:FindFirstChild("ShiftLockAttachment")
	if not attachment then
		attachment = Instance.new("Attachment")
		attachment.Name = "ShiftLockAttachment"
		attachment.Parent = rootPart
	end
	
	-- สร้างตัวหมุนตามระบบฟิสิกส์ (แก้ปัญหาสั่น)
	local alignOrientation = rootPart:FindFirstChild("ShiftLockAlign")
	if not alignOrientation then
		alignOrientation = Instance.new("AlignOrientation")
		alignOrientation.Name = "ShiftLockAlign"
		alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
		alignOrientation.Attachment0 = attachment
		alignOrientation.RigidityEnabled = true -- ให้หันหน้าตามแบบทันที (เหมือน Shift Lock ของแท้)
		alignOrientation.Enabled = false
		alignOrientation.Parent = rootPart
	end
	
	return humanoid, rootPart, alignOrientation
end

-- 4. ฟังก์ชันอัปเดตระบบ
local function updateShiftLockState()
	local character = player.Character
	if not character then return end
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	local alignOrientation = rootPart and rootPart:FindFirstChild("ShiftLockAlign")

	if not (humanoid and rootPart and alignOrientation) then return end

	if isShiftLocked then
		-- เปิด Shift Lock
		shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_on.png"
		crosshair.Visible = true
		
		humanoid.CameraOffset = Vector3.new(1.75, 0, 0)
		humanoid.AutoRotate = false 
		alignOrientation.Enabled = true -- เปิดระบบบังคับหัน
		
		-- อัปเดตทิศทางเป้าหมายให้ AlignOrientation ตามมุมกล้อง
		RunService:BindToRenderStep(renderSteppedName, Enum.RenderPriority.Camera.Value, function()
			if humanoid.Health > 0 and not humanoid.Sit then
				local camLook = camera.CFrame.LookVector
				-- หมุนเฉพาะแกนแนวนอน ไม่ให้ตัวละครก้มเงยตามกล้อง
				alignOrientation.CFrame = CFrame.lookAt(Vector3.zero, Vector3.new(camLook.X, 0, camLook.Z))
			end
		end)
	else
		-- ปิด Shift Lock
		shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_off.png"
		crosshair.Visible = false
		
		humanoid.CameraOffset = Vector3.new(0, 0, 0)
		humanoid.AutoRotate = true 
		alignOrientation.Enabled = false -- ปิดระบบบังคับหัน
		
		RunService:UnbindFromRenderStep(renderSteppedName)
	end
end

-- 5. ตรวจจับการกดปุ่ม
shiftLockButton.MouseButton1Click:Connect(function()
	isShiftLocked = not isShiftLocked
	updateShiftLockState()
end)

-- 6. จัดการระบบเมื่อเกิดใหม่
player.CharacterAdded:Connect(function(character)
	setupCharacter(character) -- ติดตั้ง AlignOrientation ให้ตัวละครใหม่
	
	-- ถ้ากดเปิดค้างไว้ก่อนตาย ให้เปิดระบบต่อ
	if isShiftLocked then
		updateShiftLockState()
	end
end)

-- ติดตั้งให้ตัวละครปัจจุบันทันทีเผื่อสคริปต์รันหลังจากเกิดแล้ว
if player.Character then
	setupCharacter(player.Character)
end
