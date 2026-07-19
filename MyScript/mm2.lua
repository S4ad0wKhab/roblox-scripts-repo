local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/S4ad0wKhab/roblox-scripts-repo/refs/heads/main/library/polar-ui"))()

local ok = library:CreateWindow("MM2 Script 1.0")

ok:Section("Main")

ok:Toggle("sup",function()
end)

ok:Button("a",function()
end)

ok:Box("WalkSpeed", function(object, focus)
 if focus then
     game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(object.Text) or 16
 end
end)

ok:Box("JumpSpeed", function(object, focus)
    if focus then
        local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = tonumber(object.Text) or 50
        end
    end
end)
