local module = {}

local CLOSED = Color3.new(1, 0, 0.6352941176470588)
local OPEN = Color3.fromRGB(0, 134, 80)
local BORDER = Color3.new(0,0,0)
local START = Color3.new(0.06666666666666667, 1, 0)
local END = Color3.new(1, 0, 0)
local BLANK = Color3.new(255,255,255)

function module:MoveStart(touched : Frame, Grid : Frame)
    local startInGui : Frame = Grid:FindFirstChild("Start")

    startInGui.Name = startInGui.AbsolutePosition
    startInGui.BackgroundColor3 = BLANK

    touched.Name = "Start"
    touched.BackgroundColor3 = START
end

function module:MoveEnd(touched : Frame, Grid : Frame)
    local endInGui : Frame = Grid:FindFirstChild("End")

    endInGui.Name = endInGui.AbsolutePosition
    endInGui.BackgroundColor3 = BLANK

    touched.Name = "End"
    touched.BackgroundColor3 = END
end

function module:MakeBorder(touched : Frame, Grid : Frame)
    touched.Name  = "Border"
    touched.BackgroundColor3 = BORDER
end

return module