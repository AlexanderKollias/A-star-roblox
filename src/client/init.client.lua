local pointer = require(script.Astar)
local func = require(script.localFunctions)


local player : Player = script.Parent
local Grid = player.ScreenGui.CompleteFrame.Grid

for _,v : Frame? in pairs(player.PlayerGui.ScreenGui.CompleteFrame.Grid:GetChildren()) do
    if v:IsA("Frame") and v.Name ~= "Start" or v.Name ~= "End" then
        v.Name = v.AbsolutePosition
        v.AttributeChanged:Connect(function()
            v.Name = v.AbsolutePosition
        end)
    end
end

local newPointer = pointer.initialize(Grid)

player.PlayerGui.ScreenGui.CompleteFrame:FindFirstChild("Start").Activated:Connect(function()
    while pointer.Finished do -- Until the value is changed to true continue the loop
        newPointer:FindNextNode(Grid) -- The script that starts it all
    end
end)