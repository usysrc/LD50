local timer         = requireLibrary("hump.timer")
local tween         = timer.tween

local Skyship = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.dx = 0
    i.dy = 0
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line", self.x*16+self.dx*16, self.y*16+self.dy*16, 16,16)
    end
    i.update = function(self)
    end
    i.turn = function()

    end
    i.keypressed = function(self, key)
        local x,y = 0, 0
        if key == "left" then
            x = x - 1
        elseif key == "right" then
            x = x + 1
        elseif key == "up" then
            y = y - 1
        elseif key == "down" then
            y = y + 1
        end
        if self.broken then x = 0; y = 1 end
        for e in all(Game.invaders) do
            if e.x == self.x + x and e.y == self.y + y then
                -- player has to attack from the sides!
                if e.y >= self.y then
                    del(Game.invaders, e)
                    del(Game.entities, e)
                    return
                elseif e.y < self.y then
                    -- if you attack from underneath you break
                    e.updatetimer = 0
                    self.broken = true
                    x = 0
                end
            end
        end
        if self.y + y >= Game.horizon then
            Game.player = Game.human
            add(Game.entities, Game.human)
            Game.human.x = Game.skyship.x
            return false
        end
        Game.locked = true
        self.x = self.x + x
        self.y = self.y + y
        self.dx = -x
        self.dy = -y
        tween(0.1, self, {dx=0, dy=0},"linear", function()
            self.dx = 0
            self.dy = 0
            Game.locked = false
        end)
        return true
    end
    return i
end

return Skyship