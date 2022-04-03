local Gamestate     = requireLibrary("hump.gamestate")
local Lost     = require("src.states.Lost")

local Invader = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.dx = 0
    i.dy = 0
    i.hp = 3
    i.updatespeed = 0.05
    i.updatetimer = 0
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        if self.mode == "falling" then
            love.graphics.draw(Image.chute, self.x*16+self.dx*16, self.y*16+self.dy*16-8)
        end
        love.graphics.draw(Image.invader, self.x*16+self.dx*16, self.y*16+self.dy*16)
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
        falling = function(self)
            local x,y = 0, 0
            y = y + 1

            if self.y + y >= Game.horizon -1 then
                Gamestate.switch(Lost, Game.rounds)
            end
            if y > 0 and self.x + x == Game.player.x and self.y + y == Game.player.y then
                x,y = 0, 0
                Game.player.broken = true
                Game.player.y = Game.player.y + 1
            end
            self.x = self.x + x
            self.y = self.y + y
            local t = Game.map:get(self.x, self.y+1)
            if t then
                self.mode = "walking"
                self.xDir = math.random() < 0.5 and -1 or 1
            end
        end,
        walking = function(self)
            local x,y = i.xDir, 0
            local t = Game.map:get(self.x+x, self.y)
            if t then
                i.xDir = -i.xDir
                x = i.xDir
            end
            
            self.x = self.x + x
            self.y = self.y + y
            local t = Game.map:get(self.x, self.y+1)
            if not t then
                self.mode = "falling"
            end
        end,
    }
    i.mode = "falling"
    return i
end

return Invader