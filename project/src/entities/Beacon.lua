local Gamestate     = requireLibrary("hump.gamestate")
local Lost     = require("src.states.Lost")

local Beacon = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.power = 0
    i.blocking = true
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Image.beacon, self.x*16, self.y*16)
        if self.lit then
            love.graphics.setColor(1,0,1,0.4)
            love.graphics.rectangle("fill", self.x*16+4, self.y*16+4, 8, -1000)
        end
    end
    i.update = function(self) end
    i.turn = function(self)
        self.power = self.power - 1
        if self.power < 0 then
            self.lit = false
            Game.timestop = false
        end
    end
    i.interact = function(self, other)
        if self.lit then return end
        local found
        for itemstack in all(other.inventory) do
            if #itemstack > 0 and itemstack[1].type == "sky-crystal" then
                found = itemstack[1]
                del(itemstack, found)
                if #itemstack == 0 then
                    del(other.inventory, itemstack)
                end
                break
            end
        end
        if found then
            self.power = 10
            self.lit = true
            Game.timestop = true
        end
    end
    return i
end

return Beacon