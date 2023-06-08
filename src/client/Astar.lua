local pointer = {}

pointer.__index = pointer

function pointer.initialize(Grid : Frame)
    local self = {}

    setmetatable(self,pointer)
    self.Pointer = Grid:WaitForChild("Start")
end

function pointer.SearchPath(self,Grid : Frame)
    local gridLayout : UIGridLayout = Grid:WaitForChild("UIGridLayout")

    
end