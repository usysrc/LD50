local Gamestate     = requireLibrary("hump.gamestate")
local Lost          = require("src.states.Lost")

local Bird = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.updatespeed = 1
    i.updatetimer = 0
    i.dropspeed = 0.025
    i.droptimer = 0.97
    i.dir = 1
    i.dx = 0
    i.dy = 0
    i.frame = 0
    i.type = "bird"
    i.draw = function(self)
        i.frame = i.frame + 0.1
        love.graphics.setColor(0,0,0)
        local frame = 1+math.floor(i.frame%2)
        love.graphics.draw(Image["bird"..frame], self.x*16+self.dx*16+8, self.y*16+self.dy*16+8, 0, self.dir, 1, 8, 8)
    end
    i.xDir = 1
    i.update = function(self)
    end
    i.turn = function(self)
        -- if Game.player == Game.human then return end
        if Game.timestop then return end
        i.updatetimer = i.updatetimer + i.updatespeed 
        if i.updatetimer >= 1 then
            i.updatetimer = 0
            self:move()
        end

      
    end
   
    i.move = function(self)
        self.modes[self.mode](self)
    end
    i.modes = {
        sidetoside = function(self)
            local x,y = i.xDir, 0
            self.x = self.x + x
            self.y = self.y + y
            if self.x * 16 >= love.graphics.getWidth()/2 then
                self.x = 0
            end
        end,
    }
    i.mode = "sidetoside"
    return i
end

return Bird