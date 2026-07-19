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
		<โค้ด>
	end	  
})
