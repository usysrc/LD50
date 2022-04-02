local timer         = requireLibrary("hump.timer")
local tween         = timer.tween

local Player = function(Game, x,y)
    local i = {}
    i.x = x
    i.y = y
    i.dx = 0
    i.dy = 0
    i.frame = 0
    i.dir = 1
    i.maxframes = 2
    i.inventory = {
        { -- itemstack
            { type = "sky-crystal" },
            { type = "sky-crystal" }
        }
    }
    i.draw = function(self)
        love.graphics.setColor(1,1,1)
        self.frame = self.frame + 0.2
        local frame = math.min(self.maxframes, math.floor(1+self.frame%self.maxframes))
        if not self.walking then
            frame = 1
        end
        love.graphics.draw(Image["player"..frame], self.x*16+self.dx*16+8, self.y*16+self.dy*16+8, 0, self.dir, 1, 8, 8)
        
    end
    i.drawGui = function(self)
        for itemstack in all(self.inventory) do
            love.graphics.setColor(1,1,1)
            local x,y = love.graphics.getWidth()/4-50, love.graphics.getHeight()/2-32
            -- love.graphics.rectangle("fill", x,y,16,16) --draw image of item
            love.graphics.draw(Image.crystal, x, y)
            love.graphics.print(#itemstack.."x "..itemstack[1].type, x,y+16)
        end
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
        local t = Game.map:get(self.x + x, self.y + y)
        local blocked
        if t and t.blocking then
            if t.interact then t:interact(self) end
            blocked = true
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
        if not blocked then
            Game.locked = true
            self.x = self.x + x
            self.y = self.y + y
            self.dx = -x
            self.dy = -y
            self.walking = true
            tween(0.2, self, {dx=0, dy=0},"linear", function()
                self.dx = 0
                self.dy = 0
                Game.locked = false
                self.walking = false
            end)
        else
            Game.locked = true
            timer.after(0.2, function()
                Game.locked = false
            end)
        end
        return true
    end
    return i
end

return Player