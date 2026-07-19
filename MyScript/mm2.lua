local LocalPlayer = game:GetService("Players").LocalPlayer

-- ป้องกันสคริปต์ทำงานซ้ำซ้อนเวลาเปิดใหม่
if _G.SpeedBoxConnection then _G.SpeedBoxConnection:Disconnect() end
if _G.JumpConnection then _G.JumpConnection:Disconnect() end

_G.SavedWalkSpeed = _G.SavedWalkSpeed or 16
_G.SavedJumpPower = _G.SavedJumpPower or 50

-- ฟังก์ชันดักจับตอนเกิดใหม่
local function onCharacterAdded(char)
    task.wait(0.5) -- รอให้โมเดลโหลดเสร็จสมบูรณ์
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = _G.SavedWalkSpeed
        hum.UseJumpPower = true
        hum.JumpPower = _G.SavedJumpPower
    end
end

-- ผูก event ตอนเกิดใหม่
_G.SpeedBoxConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
_G.JumpConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
------------------------------------------------------------------------------

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/polar"))()

local ok = library:CreateWindow("MM2 Script 1.0")

ok:Section("Main")

ok:Toggle("sup",function()
end)

ok:Button("a",function()
end)

ok:Box("WalkSpeed", function(object, focus)
    if focus then
        -- แปลงข้อความที่พิมพ์เป็นตัวเลข ถ้าพิมพ์มั่วจะใช้ค่า 16
        local val = tonumber(object.Text) or 16
        _G.SavedWalkSpeed = val -- บันทึกค่าลงตัวแปรส่วนกลาง
        
        -- ปรับความเร็วตัวละครปัจจุบันทันที
        local hum = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = val
        end
    end
end)

ok:Box("JumpSpeed", function(object, focus)
    if focus then
        -- แปลงค่าที่พิมพ์เป็นตัวเลข ถ้าพิมพ์มั่วให้กลับไป 50
        local val = tonumber(object.Text) or 50
        _G.SavedJumpPower = val -- บันทึกค่าใหม่ไว้ในตัวแปรส่วนกลาง
        
        -- อัปเดตตัวละครปัจจุบันทันที
        local hum = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = val
        end
    end
end)

------------------------------------------------------------------------
local coreGui = game:GetService("CoreGui")
local screenGui = coreGui:FindFirstChild("ScreenGui")
if screenGui then
    local mainFrame = screenGui:FindFirstChild("main")
    if mainFrame then
        -- เรียกใช้ฟังก์ชันดรากเกอร์ที่ไลบารีทำทิ้งไว้ในระบบมาผูกกับเฟรมหลัก
        dragger.new(mainFrame)
    end
end
