local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("TITLE", "DarkTheme")
-- Themes:
--    LightTheme
--    DarkTheme
--    GrapeTheme
--    BloodTheme
--    Ocean
--    Midnight
--    Sentinel
--    Synapse

local Tab = Window:NewTab("TabName") -- สร้างแท็บด้านซ้าย
local Section = Tab:NewSection("Section Name") -- สร้างแท็บด้านขวา
Section:UpdateSection("Section New Title") -- อัพเดทแท็บด้านขวา
Section:NewLabel("LabelText") -- ป้ายกำกับ
label:UpdateLabel("New Text") -- อัพเดทป้ายกำกับ

-- ปุ่ม --
Section:NewButton("ButtonText", "ButtonInfo", function()
    print("Clicked")
end)
button:UpdateButton("New Text") -- อัพเดทปุ่ม

-- ปุ่มติ๊กถูก --
Section:NewToggle("ToggleText", "ToggleInfo", function(state)
    if state then
        print("Toggle On")
    else
        print("Toggle Off")
    end
end)
-- อัพเดทปุ่มติ๊กถูก --
getgenv().Toggled = false

local toggle = Section:NewToggle("Toggle", "Info", (state)
    getgenv().Toggled = state
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if getgenv().Toggled then
		toggle:UpdateToggle("Toggle On")
	else
		toggle:UpdateToggle("Toggle Off")
	end
end)





