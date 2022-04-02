local timer         = requireLibrary("hump.timer")
local tween         = timer.tween

local Player = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.dx = 0
    i.dy = 0
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", self.x*16+self.dx*16, self.y*16+self.dy*16, 16,16)
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
        for e in all(Game.entities) do
            
        end
        if self.y + y < Game.horizon then
            -- enter the skyship
            if self.y + y == Game.skyship.y and self.x + x == Game.skyship.x then
                Game.human = Game.player
                Game.player = Game.skyship
                del(Game.entities, Game.human)
            end
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

return Player