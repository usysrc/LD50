local Gamestate     = requireLibrary("hump.gamestate")
local Lost     = require("src.states.Lost")

local Tile = function(Game, x,y,img)
    local i = {}
    i.x = x
    i.y = y
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(img or Image.island, self.x*16, self.y*16)
    end
    i.update = function(self) end
    i.turn = function(self) end
    return i
end

return Tile