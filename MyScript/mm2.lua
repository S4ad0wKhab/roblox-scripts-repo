local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "S4ad0wKhab's MM2 Script (Beta 1.0)", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

OrionLib:MakeNotification({
	Name = "MM2 Script By S4ad0wKhab!",
	Content = "Beta 1.0 is a test version; please let me know if you encounter any issues!",
	Image = "rbxassetid://116152473553878",
	Time = 5
})

local Tab = Window:MakeTab({
	Name = "Home",
	Icon = "rbxassetid://77451122306832",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Speed & Jump"
})

Tab:AddTextbox({
	Name = "Speed",
	Default = "16",
	TextDisappear = true,
	Callback = function(Value)
		-- แปลงข้อความที่พิมพ์ให้เป็นตัวเลข ถ้านึกสนุกพิมพ์ตัวอักษรระบบจะใช้ค่าเริ่มต้น (16)
        local speedValue = tonumber(Value) or 16

        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        -- 1. ทำการเปลี่ยนความเร็วของตัวละครปัจจุบันทันทีที่พิมพ์เสร็จ
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
        end

        -- 2. สร้างระบบดักจับตอนเกิดใหม่ (ถ้าเคยมีระบบดักจับตัวเก่าอยู่ให้เคลียร์ทิ้งก่อน)
        if _G.SpeedConnection then
         _G.SpeedConnection:Disconnect()
        end

        -- สั่งให้ทุกครั้งที่เกิดใหม่ (CharacterAdded) ให้ปรับความเร็วเป็นค่าล่าสุดเสมอ
        _G.SpeedConnection = LocalPlayer.CharacterAdded:Connect(function(newCharacter)
            -- รอให้ Humanoid โหลดเสร็จสมบูรณ์ในตัวละครใหม่
            local humanoid = newCharacter:WaitForChild("Humanoid", 5)
            if humanoid then
                task.wait(0.1) -- หน่วงเวลาจังหวะเกิดนิดนึงเพื่อให้แน่ใจว่าค่าไม่โดนเกมรีเซตทับ
                humanoid.WalkSpeed = speedValue
            end
        end)
})

Tab:AddTextbox({
	Name = "Jump",
	Default = "50",
	TextDisappear = true,
	Callback = function(Value)
		-- แปลงข้อความให้เป็นตัวเลข ถ้านึกสนุกพิมพ์มั่วจะปรับเป็นค่าเริ่มต้น (50)
		local jumpValue = tonumber(Value) or 50

		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer

		-- ฟังก์ชันสำหรับตั้งค่าแรงกระโดดและเปิดระบบ JumpPower
		local function applyJump(character)
		    local humanoid = character:FindFirstChildOfClass("Humanoid")
		    if humanoid then
		        humanoid.UseJumpPower = true -- บังคับให้แมพใช้ค่า JumpPower (กันบั๊กบางแมพที่ใช้เป็น JumpHeight)
		        humanoid.JumpPower = jumpValue
		    end
		end

		-- 1. เปลี่ยนแรงกระโดดของตัวละครปัจจุบันทันที
		if LocalPlayer.Character then
		    applyJump(LocalPlayer.Character)
		end

		-- 2. เคลียร์ระบบดักจับตัวเก่า (ถ้าเคยตั้งค่า Jump ไว้ก่อนหน้านี้)
		if _G.JumpConnection then
		    _G.JumpConnection:Disconnect()
		end

		-- 3. ตั้งค่าระบบดักจับตอนเกิดใหม่ ให้แรงกระโดดยังคงอยู่ตลอด
		_G.JumpConnection = LocalPlayer.CharacterAdded:Connect(function(newCharacter)
		    local humanoid = newCharacter:WaitForChild("Humanoid", 5)
		    if humanoid then
		        task.wait(0.1) -- หน่วงเวลาจังหวะเกิดเล็กน้อยเพื่อความเสถียร
		        applyJump(newCharacter)
		    end
		end)
})
