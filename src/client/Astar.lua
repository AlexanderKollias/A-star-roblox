local pointer = {}

pointer.__index = pointer

function pointer.initialize(Grid : Frame)
    local self = {}

    setmetatable(self,pointer)
    self.Pointer = Grid:WaitForChild("Start").AbsolutePosition
end

function pointer:cost(self,Vector : Vector2,End : Frame)
    local GCost : number? = math.abs(self.pointer.AbsolutePosition - Vector).Magnitude
    local HCost : number? = math.abs(End - Vector).Magnitude

    if HCost == 0 then
        return true
    end

    local FCost : number = GCost + HCost

    return FCost,Vector
end

function pointer:SearchPath(self,Grid : Frame)
    local gridLayout : UIGridLayout = Grid:WaitForChild("UIGridLayout")
    local End : Frame = Grid:WaitForChild("End")
    local oldPos : Vector2 = self.Pointer
    local values : table = {pointer:cost(Vector2.new(105,100),End),pointer:cost(Vector2.new(-105,100),End),pointer:cost(Vector2.new(105,0),End),pointer:cost(Vector2.new(-105,0),End),pointer:cost(Vector2.new(105,-100),End),pointer:cost(Vector2.new(0,100),End),pointer:cost(Vector2.new(0,-100),End),pointer:cost(Vector2.new(-105,-100),End)}
    local min : table = values[1][1]

    local placeHolder = 0
    for i = 2,#values do 
        if values[i][1] == true then return true end;
        if values[i][1] < min then
            min = values[i]
            placeHolder = i
        end
    end

    self.Pointer = values[placeHolder][2]

    return self.Pointer
end