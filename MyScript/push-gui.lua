local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/lime"))()

local w = Library:Window("Push Gui 1.0 (R6)")

w:Button("Button", function()
   -- รหัส Animation ID ที่ต้องการใช้ (เปลี่ยนตัวเลขด้านล่างเป็น ID แอนิเมชันผลักของคุณ)
local ANIMATION_ID = "rbxassetid:10506078364" 
local FLING_FORCE = 150 -- ความแรงในการผลัก (ปรับเพิ่ม/ลดได้)
local FLING_RADIUS = 6 -- ระยะห่างที่จะโดนผลัก (หน่วยเป็น Studs ยิ่งมากยิ่งผลักไกล)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local RootPart = Character:FindFirstChild("HumanoidRootPart")

if Humanoid and RootPart then
    -- 1. เล่น Animation ผลัก
    local anim = Instance.new("Animation")
    anim.AnimationId = ANIMATION_ID
    local animTrack = Humanoid:LoadAnimation(anim)
    animTrack:Play()
    
    -- 2. ค้นหาผู้เล่นที่อยู่ใกล้ๆ เพื่อผลักกระเด็น
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetChar = player.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
            
            if targetRoot and targetHum and targetHum.Health > 0 then
                -- คำนวณระยะห่างระหว่างเรากับเป้าหมาย
                local distance = (RootPart.Position - targetRoot.Position).Magnitude
                
                if distance <= FLING_RADIUS then
                    -- คำนวณทิศทางที่จะผลัก (ผลักออกจากตัวเรา + เสยขึ้นฟ้านิดๆ เพิ่มความขำขัน)
                    local pushDirection = (targetRoot.Position - RootPart.Position).Unit
                    local velocityVector = (pushDirection * FLING_FORCE) + Vector3.new(0, FLING_FORCE * 0.6, 0)
                    
                    -- สร้างแรงฟิสิกส์เพื่อผลักตัวเป้าหมาย
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = velocityVector
                    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000) -- แรงส่งมหาศาล
                    bodyVelocity.P = 1250
                    bodyVelocity.Parent = targetRoot
                    
                    -- ทำลายแรงผลักทิ้งหลังจากผ่านไป 0.2 วินาที (เพื่อให้ตัวลอยไปตามแรงเฉื่อย ไม่พุ่งค้าง)
                    game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
                end
            end
        end
    end
end)

w:ButtonName("Script By S4ad0wKhab", function()
end)
  
w:ButtonName("Library Load Code By x2Swiftz", function()
end)

w:ButtonName("Library Made By ?", function()
end)
