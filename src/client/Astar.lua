local pointer = {["Finished"] = false,}

pointer.__index = pointer


local CLOSED = Color3.new(1, 0, 0.6352941176470588)
local OPEN = Color3.fromRGB(0, 134, 80)
local BORDER = Color3.new(0,0,0)
local START = Color3.new(0.06666666666666667, 1, 0)
local END = Color3.new(1, 0, 0)
local BLANK = Color3.new(255,255,255)
local PATH = Color3.new(0.011764, 0.243137, 1)

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


local open : table = {}
local closed : table = {}

function pointer:FindNextNode(Grid : Frame)
    local End : Frame = Grid:WaitForChild("End")
    local gridLayout : UIGridLayout = Grid:WaitForChild("UIGridLayout")
    local x,y = gridLayout.CellSize.X,gridLayout.CellSize.Y
    
    local positions : table = {
        Vector2.new(x,y),Vector2.new(-x,y),Vector2.new(x,-y),Vector2.new(x,0),Vector2.new(x,y),Vector2.new(-x,-y),Vector2.new(x,-y),Vector2.new(-x,y)
    }

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
        if v == true then return true end -- here make sure to add later the function that computes the path back
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

function FinishPathfinding(Grid : Frame)
    local min : number = 2^10
    local index : number = 0
    local costOfv : table = {}
    local path = {}
    local End : Frame = Grid:FindFirstChild("End")

    for j : number = 1,#closed do -- loops once through all the indexes in closed (ps. yeah I know it is O(n^2) but honestly I'm in a plane to Canarian Islands and I couldn't care less

        for i : number,v : Vector2 in pairs(closed) do -- Now loops so through the items in closed
            table.insert(costOfv,pointer:cost(v,End))
            if costOfv[i][1] < min then -- Simple bubble sort
                min = costOfv[i][1]
                index = i
            elseif costOfv[i][1] == min then
                if costOfv[i][2] < costOfv[index][2] then
                    index = i
                end
            end
        end

        table.remove(closed,index) -- remove the smallest from the closed so it doesn't get used again

        -- I just add it to path to compute the path
        table.insert(path,costOfv[index][4])
        Grid:FindFirstChild(tostring(costOfv[index][4])).BackgroundColor3 = PATH
        Grid:FindFirstChild(tostring(costOfv[index][4])).Name = "Path"
    end
end

function pointer:StartPathfinding(Grid : Frame)
    local nodeToGo : Vector2 = self:FindNextNode(Grid) -- Gets the smallest FCost or the smallest HCost
    
    table.insert(closed,nodeToGo)
    if nodeToGo == true then
        pointer:FinishPathfinding() -- To be added function
        pointer.Finished = true
    end

    self.Pointer = nodeToGo

    local nodeInGUI : Frame = Grid:FindFirstChild(tostring(nodeToGo))

    nodeInGUI.BackgroundColor3 = CLOSED
end
