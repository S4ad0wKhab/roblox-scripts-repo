local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Title of the library", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

-- แท็บซ้าย --
local Tab = Window:MakeTab({
	Name = "Tab 1", -- ชื่อแท็บ
	Icon = "rbxassetid://4483345998", -- ไอคอน
	PremiumOnly = false
})

-- หัวข้อในแท็บขวา --
local Section = Tab:AddSection({
	Name = "Section" -- ชื่อหัวข้อ
})

-- แจ้งเตือนเมื่อรัน --
OrionLib:MakeNotification({
	Name = "Title!", -- ชื่อแจ้งเตือน
	Content = "Notification content... what will it say??", -- ข้อความแจ้งเตือน
	Image = "rbxassetid://4483345998", -- ไอคอน
	Time = 5 -- เวลาแสดง ค่าเป็นวินาที
})

------------ ช่องต่อไปนี้จะอยู่ในแท็บขวาตลอด -------------'''

-- ช่องปุ่ม --
Tab:AddButton({
	Name = "Button!", -- ชื่อปุ่ม
	Callback = function() -- ข้างล่างจะเป็นระบบ
      		print("button pressed")
  	end    
})

-- ช่องปุ่มติ๊กถูก --
Tab:AddToggle({
	Name = "This is a toggle!",
	Default = false,
	Callback = function(Value)
		print(Value)
	end    
})
CoolToggle:Set(true) --[[ ค่าที่จะกำหนดว่าตอนรันครั้งแรกจะให้ติ๊กหรือไม่
                        true = ติ๊ก
                        false = ไม่ติ๊ก
                       ]]
-- ช่องตัวเลือกสี --
Tab:AddColorpicker({
	Name = "Colorpicker",
	Default = Color3.fromRGB(255, 0, 0),
	Callback = function(Value)
		print(Value)
	end	  
})
ColorPicker:Set(Color3.fromRGB(255,255,255)) -- ค่าที่จะกำหนดว่าตอนรันครั้งแรกจะให้ตั้งเป็นสีไหนก่อน

