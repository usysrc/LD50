local Gamestate     = requireLibrary("hump.gamestate")
local Lost     = require("src.states.Lost")

local Mine = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.power = 0
    i.blocking = true
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Image.Mine, self.x*16, self.y*16)
        if self.lit then
            love.graphics.setColor(1,0,1,0.4)
            love.graphics.rectangle("fill", self.x*16+4, self.y*16+4, 8, -1000)
        end
    end
    i.update = function(self) end
    i.turn = function(self)
    end
    i.interact = function(self, other)
        
        if math.random() < 0.8 then return end
        local found
        for itemstack in all(other.inventory) do
            if #itemstack > 0 and itemstack[1].type == "sky-crystal" then
                found = itemstack
                break
            end
        end
        print(found)
        if found then
            add(found, { type= "sky-crystal" })
        end
    end
    return i
end

return Mine