local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/lime"))()

local w = Library:Window("Push Gui 1.0 (R6)")

w:Button("Button", function()
    local ANIMATION_ID = "rbxassetid://10506078364" 
    local FLING_FORCE = 300 -- ปรับแรงขึ้นเพื่อความสะใจ
    local FLING_RADIUS = 15

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")

    if Humanoid and RootPart then
        -- เล่นแอนิเมชันผลัก
        local anim = Instance.new("Animation")
        anim.AnimationId = ANIMATION_ID
        local animTrack = Humanoid:LoadAnimation(anim)
        animTrack:Play()
        
        -- วนลูปหาคนโดนผลัก
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetChar = player.Character
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
                
                if targetRoot and targetHum and targetHum.Health > 0 then
                    local distance = (RootPart.Position - targetRoot.Position).Magnitude
                    
                    if distance <= FLING_RADIUS then
                        -- บังคับให้ระบบฟิสิกส์จำลองสถานะตกใจ (ทำให้แรงผลักทำงานได้ฝั่ง Client)
                        targetHum:ChangeState(Enum.HumanoidStateType.Physics)
                        
                        -- คำนวณทิศทางพุ่งกระเด็น
                        local pushDirection = (targetRoot.Position - RootPart.Position).Unit
                        local velocityVector = (pushDirection * FLING_FORCE) + Vector3.new(0, FLING_FORCE * 0.8, 0)
                        
                        -- ใส่แรงผลักมหาศาล
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.Velocity = velocityVector
                        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge) -- ใช้แรงอินฟินิตี้
                        bodyVelocity.P = 5000
                        bodyVelocity.Parent = targetRoot
                        
                        -- ทำลายแรงทิ้งหลังจากกระเด็นไปแล้ว
                        game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
                    end
                end
            end
        end
    end
end)
