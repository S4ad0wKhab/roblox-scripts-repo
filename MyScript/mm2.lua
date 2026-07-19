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
