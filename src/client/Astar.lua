local pointer = {}

pointer.__index = pointer


local CLOSED = Color3.new(1, 0, 0.6352941176470588)
local OPEN = Color3.fromRGB(0, 134, 80)
local BORDER = Color3.new(0,0,0)
local START = Color3.new(0.06666666666666667, 1, 0)
local END = Color3.new(1, 0, 0)

function pointer.initialize(Grid : Frame)
    local self = {}

    setmetatable(self,pointer)
    self.Pointer = Grid:WaitForChild("Start").AbsolutePosition
end

function pointer:cost(Vector : Vector2,End : Frame)
    local GCost : number? = math.abs(self.pointer.AbsolutePosition - Vector).Magnitude
    local HCost : number? = math.abs(End - Vector).Magnitude

    if HCost == 0 then return true end

    local FCost : number = GCost + HCost

    return FCost,HCost,GCost,(self.Pointer + Vector) -- Returns a table of the Fcost the Hcost the Gcost and the place of the node in the screen
end

local x,y = 105,100

local positions : table = {
    Vector2.new(x,y),Vector2.new(-x,y),Vector2.new(x,-y),Vector2.new(x,0),Vector2.new(x,y),Vector2.new(-x,-y),Vector2.new(x,-y),Vector2.new(-x,y)
}

local open : table = {}
local closed : table = {}

function pointer:FindNextNode(Grid : Frame)
    local gridLayout : UIGridLayout = Grid:WaitForChild("UIGridLayout")
    local End : Frame = Grid:WaitForChild("End")
    local oldPos : Vector2 = self.Pointer

    local min : number = 2^10
    local index : number

    for _,v : Vector2 in pairs(positions) do -- Adds all the possible positions into the open table
        local correctV = self.Pointer + v

        local nodeFrame = Grid:FindFirstChild(tostring(correctV))

        -- Block of code where I do some checks --

        if not nodeFrame then continue end
        if table.find(open[#open],correctV) then continue end
        if nodeFrame.BackgroundColor3 == BORDER then continue end
        -- Add here a check to see if the vector is in the closed table

        ------------------------------------------

        table.insert(open,self:cost(v,End))
        Grid:FindFirstChild(tostring(open[#open][4])).BackgroundColor3 = OPEN
    end

    for i : number, v : table? in pairs(open) do -- Loop through the open nodes to see if something has a lower Fcost
        if v == true then return end -- here make sure to add later the function that computes the path back
        if v[1] < min then
            min = v[1]
            index = i
        elseif v[1] == min then
            if v[2] == open[i][2] then
                index = i
            end
        end
    end

    return open[index][4]  --return here the smallest Fcost OR the smallest Hcost
end

function pointer:CloseNode(Grid : Frame)
    local nodeToGo : Vector2 = self:FindNextNode(Grid)
    self.Pointer = nodeToGo

    local nodeInGUI : Frame = Grid:FindFirstChild(tostring(nodeToGo))

    nodeInGUI.BackgroundColor3 = CLOSED
end