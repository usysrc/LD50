local Gamestate     = requireLibrary("hump.gamestate")
local Lost          = require("src.states.Lost")
local timer         = requireLibrary("hump.timer")
local tween         = timer.tween
local Tile          = require("src.entities.Tile")


local House = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.power = 0
    i.blocking = true
    i.interacttext = "x: repair ship, 15 crystals"
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Image.House, self.x*16, self.y*16)
    end
    i.update = function(self) end
    i.turn = function(self)
    end
    i.interact = function(self, other)
        if not Game.skyship.broken then return end
        local found, stack
        for itemstack in all(Game.human.inventory) do
            if itemstack[1] and itemstack[1].type == "sky-crystal" then
                found = itemstack[1]
                stack = itemstack
            end
        end
        if found and #stack >= 15 then
            for i=1,15 do
                del(stack, stack[1])
            end
            Sfx.repair:play()
            if #stack == 0 then
                del(Game.human.inventory, stack)
            end
            Game.skyship.broken = false
        end
    end
    return i
end

return House