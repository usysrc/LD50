local Gamestate     = requireLibrary("hump.gamestate")
local Lost          = require("src.states.Lost")
local timer         = requireLibrary("hump.timer")
local tween         = timer.tween
local Tile          = require("src.entities.Tile")


local Mine = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.power = 0
    i.blocking = true
    i.interacttext = "x: to mine"
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Image.Mine, self.x*16, self.y*16)
        if Game.player.interacttext == self.interacttext then
            love.graphics.draw(Image.bubble, self.x*16 - 100/2, self.y*16-40)
            love.graphics.print(self.interacttext, self.x*16-16, self.y*16-28)
        end
    end
    i.update = function(self) end
    i.turn = function(self)
    end
    i.interact = function(self, other)
        Sfx.mine:play()
        Sfx.clank:play()
        local t = Tile(Game, self.x+math.random()/2, self.y+math.random()/2, Image.hit)
        add(Game.effects, t)
        timer.after(0.05, function()
            del(Game.effects, t)
        end)
        if math.random() < 0.8 then return end
        local found
        for itemstack in all(other.inventory) do
            if #itemstack > 0 and itemstack[1].type == "sky-crystal" then
                found = itemstack
                break
            end
        end
        Sfx.crystal:play()
        if found then
            add(found, { type = "sky-crystal", img = Image.crystal })
        else
            add(other.inventory, {
                { type= "sky-crystal", img = Image.crystal }
            })
        end
    end
    return i
end

return Mine