local Gamestate     = requireLibrary("hump.gamestate")
local Lost     = require("src.states.Lost")

local Tile = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.fallspeed = 0.2
    i.fall = 0
    i.draw = function(self)
        love.graphics.setColor(1,1,0)
        love.graphics.rectangle("fill", self.x*16, self.y*16, 16,16)
    end
    i.update = function(self)
    end
    i.turn = function(self)
    end
    return i
end

return Tile