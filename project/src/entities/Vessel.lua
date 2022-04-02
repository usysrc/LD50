local Gamestate     = requireLibrary("hump.gamestate")
local Lost     = require("src.states.Lost")
local Invader       = require("src.entities.Invader")

local Invader = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.updatespeed = 1
    i.updatetimer = 0
    i.dropspeed = 0.1
    i.droptimer = 0.97
    i.dir = 1
    i.dx = 0
    i.dy = 0
    i.draw = function(self)
        love.graphics.setColor(0,0,0)
        love.graphics.draw(Image.skyship, self.x*16+self.dx*16+8, self.y*16+self.dy*16+8, 0, self.dir, 1, 8, 8)
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

        i.droptimer = i.droptimer + i.dropspeed
        if i.droptimer >= 1 then
            i.droptimer = 0
            i.droptimer = -math.random()
            self:drop()
        end
    end
    i.drop = function(self)
        if #Game.invaders > 3 then return end
        local inv = Invader(Game, self.x, self.y + 1)
        add(Game.entities, inv)
        add(Game.invaders, inv)
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

return Invader