local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/lime"))()

local w = Library:Window("Push Gui 1.0 (R6)")

w:Button("Button", function()
    local ANIMATION_ID = "rbxassetid://10506078364" 
    local FLING_RADIUS = 8 -- ระยะห่างที่จะล็อคเป้าหมายไปผลัก (หน่วยเป็น Studs)

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")

    if Humanoid and RootPart then
        -- 1. เล่นแอนิเมชันผลักขำๆ ของเราก่อน
        local anim = Instance.new("Animation")
        anim.AnimationId = ANIMATION_ID
        local animTrack = Humanoid:LoadAnimation(anim)
        animTrack:Play()
        
        -- 2. ค้นหาเป้าหมายที่อยู่ใกล้ที่สุด
        local targetRoot = nil
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local tChar = player.Character
                local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                local tHum = tChar:FindFirstChildOfClass("Humanoid")
                
                if tRoot and tHum and tHum.Health > 0 then
                    local distance = (RootPart.Position - tRoot.Position).Magnitude
                    if distance <= FLING_RADIUS then
                        targetRoot = tRoot
                        break -- เจอคนแรกในระยะแล้วเลือกเลย
                    end
                end
            end
        end

        -- 3. ถ้าระยะได้... เริ่มกระบวนการฟิสิกส์มหาประลัย (บั๊กผลัก)
        if targetRoot then
            -- บันทึกตำแหน่งเดิมของเราไว้เพื่อวาร์ปกลับมาหลังผลักเสร็จ
            local oldPosition = RootPart.CFrame
            
            -- สร้างแรงหมุนความเร็วสูงที่ตัวเรา (ทำให้เรากลายเป็นกงจักร)
            local angularVelocity = Instance.new("BodyAngularVelocity")
            angularVelocity.AngularVelocity = Vector3.new(0, 99999, 0) -- หมุนแนวนอนเร็วสุดขีด
            angularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
            angularVelocity.Parent = RootPart

            -- สร้างแรงพุ่งตัว
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = RootPart

            -- ล็อคตัวเราพุ่งไปกระแทกเป้าหมายเป็นเวลา 0.3 วินาที (เสี้ยววินาทีจนมองไม่ทัน)
            local startTime = tick()
            while tick() - startTime < 0.3 do
                task.wait()
                if targetRoot and targetRoot.Parent then
                    -- วาร์ปตัวเราไปประกบข้างๆ เป้าหมายพร้อมหมุนติ้วเพื่อผลักให้ปลิว
                    RootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1)
                    bodyVelocity.Velocity = Vector3.new(0, 50, 0) -- แอบเสยขึ้นฟ้า
                else
                    break
                end
            end

            -- ผลักเสร็จแล้ว ทำลายแรงฟิสิกส์ทิ้ง และวาร์ปเรากลับมาจุดเดิมเนียนๆ
            angularVelocity:Destroy()
            bodyVelocity:Destroy()
            RootPart.CFrame = oldPosition
        end
    end
end)
