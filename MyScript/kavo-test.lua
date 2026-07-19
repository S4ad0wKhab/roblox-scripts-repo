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

