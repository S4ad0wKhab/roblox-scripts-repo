-- LocalScript: ระบบ Mobile Shift Lock (เวอร์ชันแก้ไขปัญหากล้องและตัวละครสั่น)
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

-- 3. ฟังก์ชันอัปเดตระบบ
local function updateShiftLockState()
	local character = player.Character
	if not character then return end
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if not (humanoid and rootPart) then return end

	if isShiftLocked then
		-- เปิด Shift Lock
		shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_on.png"
		crosshair.Visible = true
		
		humanoid.AutoRotate = false 
		
		-- ใช้ Priority เป็น Character เพื่อให้ตัวละครหันหน้าเสร็จก่อนที่กล้องจะเรนเดอร์ (แก้ปัญหาสั่น 100%)
		RunService:BindToRenderStep(renderSteppedName, Enum.RenderPriority.Character.Value, function()
			if humanoid.Health > 0 and not humanoid.Sit then
				-- หันตัวละครไปตามมุมกล้องในแกน Y (แนวนอนเท่านั้น)
				local _, cameraY, _ = camera.CFrame:ToEulerAnglesYXZ()
				rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, cameraY, 0)
				
				-- ปรับ CameraOffset แบบนุ่มนวลร่วมด้วยในลูป
				humanoid.CameraOffset = Vector3.new(1.75, 0, 0)
			end
		end)
	else
		-- ปิด Shift Lock
		shiftLockButton.Image = "rbxasset://textures/ui/mouseLock_off.png"
		crosshair.Visible = false
		
		RunService:UnbindFromRenderStep(renderSteppedName)
		
		-- คืนค่าเดิม
		humanoid.CameraOffset = Vector3.new(0, 0, 0)
		humanoid.AutoRotate = true 
	end
end

-- 4. ตรวจจับการกดปุ่ม
shiftLockButton.MouseButton1Click:Connect(function()
	isShiftLocked = not isShiftLocked
	updateShiftLockState()
end)

-- 5. จัดการระบบเมื่อเกิดใหม่
player.CharacterAdded:Connect(function(character)
	-- รอให้ Humanoid โหลดเสร็จก่อนเริ่มระบบใหม่
	character:WaitForChild("Humanoid")
	
	if isShiftLocked then
		-- ดีเลย์เล็กน้อยเพื่อให้ตัวละครเซ็ตอัพฟิสิกส์เริ่มต้นเสร็จก่อน Shift Lock ทำงาน
		task.wait(0.1)
		updateShiftLockState()
	end
end)

-- ติดตั้งเมื่อสคริปต์เริ่มรันครั้งแรก
if player.Character then
	updateShiftLockState()
end
