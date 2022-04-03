local timer         = requireLibrary("hump.timer")
local tween         = timer.tween
local Tile          = require("src.entities.Tile")

local Cannonball = function(Game, x,y, dir)
    local i = {}
    i.x = x
    i.y = y
    i.dir = dir
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Image.cannonball, self.x*16, self.y*16)
    end
    i.update = function(self, dt) end
    i.turn = function(self) end
    print("fly")
    i.fly = function(self, dx)
        local tx = self.x + dx
        tween(0.05, i, {x = tx}, "linear", function()
            self.x = tx
            if self.x < 0 or self.x > love.graphics.getWidth()/2/16 then
                del(Game.entities, self)
                Game.locked = false
                return
            end
            for e in all(Game.invaders) do
                if e.x == self.x and e.y == self.y then
                    del(Game.entities, self)
                    del(Game.invaders, e)
                    del(Game.entities, e)
                    Sfx.invaderhit:play()
                    local e = Tile(Game, self.x, self.y, Image.smoke)
                    add(Game.effects, e)
                    timer.after(0.1, function()
                        del(Game.effects,e)
                    end)
                    Game.locked = false
                    return
                end
            end
            i:fly(self.dir)
        end)
    end
    Game.locked = true
    i:fly(i.dir)
    return i
end

return Cannonball