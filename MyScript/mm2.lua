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
task.spawn(function()
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    
    -- รอให้หน้าต่างหลักถูกสร้างขึ้นมาใน CoreGui ก่อน
    local screenGui = CoreGui:WaitForChild("ScreenGui", 5)
    local mainFrame = screenGui and screenGui:WaitForChild("main", 5)
    
    if mainFrame then
        local dragging, dragInput, dragStart, startPos
        
        -- ดักจับตอนเอาเมาส์คลิกซ้ายลงบนหน้าต่างเพื่อเริ่มลาก
        mainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        -- ดักจับตอนขยับเมาส์
        mainFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        -- อัปเดตตำแหน่งหน้าต่างตามเมาส์แบบสมูท (ไม่หลุดแม้สะบัดเมาส์ไว)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                local targetPosition = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X, 
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
                -- ใช้ Tween เพื่อความลื่นไหลเวลารัน
                TweenService:Create(mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPosition}):Play()
            end
        end)
    end
end)
