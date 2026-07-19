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

---------------------- ช่องในแท็บขวามือ ---------------------
-- ช่องปุ่ม --
Section:NewButton("ButtonText", "ButtonInfo", function()
    print("Clicked")
end)
button:UpdateButton("New Text") -- อัพเดทช่องปุ่ม

-- ช่องปุ่มติ๊กถูก --
Section:NewToggle("ToggleText", "ToggleInfo", function(state)
    if state then
        print("Toggle On")
    else
        print("Toggle Off")
    end
end)
-- อัพเดทช่องปุ่มติ๊กถูก --
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

-- ช่องเส้นสไลด์ --
Section:NewSlider("SliderText", "SliderInfo", 500, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- ช่องเขียนข้อความ --
Section:NewTextBox("TextboxText", "TextboxInfo", function(txt)
	print(txt)
end)



