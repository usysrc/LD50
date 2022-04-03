local Gamestate     = requireLibrary("hump.gamestate")
local Lost          = require("src.states.Lost")
local timer         = requireLibrary("hump.timer")
local tween         = timer.tween
local Tile          = require("src.entities.Tile")


local Boulder = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.power = 0
    i.blocking = true
    i.interacttext = "x: to cut"
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Image.boulder, self.x*16, self.y*16)
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
        local t = Tile(Game, self.x, self.y, Image.hit)
        add(Game.effects, t)
        timer.after(0.05, function()
            del(Game.effects, t)
        end)
        if math.random() < 0.8 then return end
        local found
        for itemstack in all(other.inventory) do
            if #itemstack > 0 and itemstack[1].type == "cannonball" then
                found = itemstack
                break
            end
        end
        Sfx.crystal:play()
        if found then
            add(found, { type= "cannonball", img = Image.cannonball })
        else
            add(other.inventory, {
                { type= "cannonball", img = Image.cannonball }
            })
        end
    end
    return i
end

return Boulder