-- รอให้ JumpButton โหลด
local jumpButton
repeat
	jumpButton = playerGui:FindFirstChild("JumpButton", true)
	task.wait()
until jumpButton and jumpButton:IsA("ImageButton")

-- สร้าง GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MobileShiftLock"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local button = Instance.new("ImageButton")
button.Size = UDim2.fromOffset(50, 50)
button.AnchorPoint = Vector2.new(1, 1)

-- วางไว้ทางซ้ายของปุ่มกระโดด
button.Position = jumpButton.Position + UDim2.fromOffset(-60, 0)

button.Image = "rbxasset://textures/ui/mouseLock_off@2x.png"
button.BackgroundTransparency = 1
button.Parent = gui

local camera = workspace.CurrentCamera
local locked = false

button.MouseButton1Click:Connect(function()
	locked = not locked

	if locked then
		camera.CameraType = Enum.CameraType.Custom
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		button.Image = "rbxasset://textures/ui/mouseLock_on@2x.png"
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		button.Image = "rbxasset://textures/ui/mouseLock_off@2x.png"
	end
end)
