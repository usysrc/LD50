local timer         = requireLibrary("hump.timer")
local tween         = timer.tween

local Skyship = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.dx = 0
    i.dy = 0
    i.frame = 0
    i.bobbingAmplitude = 0.5
    i.draw = function(self)
        self.frame = self.frame + 0.05
        i.bobbingAmplitude = 0.5
        if self.moving then
            self.frame = self.frame + 0.1
            i.bobbingAmplitude = 1
        end

        love.graphics.setColor(1,1,1)
        love.graphics.draw(Image.skyship, self.x*16+self.dx*16+8, self.y*16+self.dy*16+8+math.cos(self.frame)*self.bobbingAmplitude, 0, self.dir, 1, 8, 8)
    end
    i.update = function(self)
    end
    i.turn = function()

    end
    i.keypressed = function(self, key)
        local x,y = 0, 0
        if key == "left" then
            self.dir = -1
            x = x - 1
        elseif key == "right" then
            self.dir = 1
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
                    y = Game.horizon - self.y - 1
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
        self.moving = true
        tween(0.2, self, {dx=0, dy=0},"linear", function()
            self.dx = 0
            self.dy = 0
            self.moving = false
            Game.locked = false
        end)
        return true
    end
    return i
end

return Skyship