local path = require(script.Astar)

local player : Player = script.Parent

for _,v : Frame? in pairs(player.PlayerGui.ScreenGui.CompleteFrame.Grid:GetChildren()) do
    if v:IsA("Frame") and v.Name ~= "Start" or v.Name ~= "End" then
        v.Name = v.AbsolutePosition
        v.AttributeChanged:Connect(function()
            v.Name = v.AbsolutePosition
        end)
    end
end


