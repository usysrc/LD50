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
    i.ox = 0
    i.oy = 0
    i.maxframes = 2
    i.interacttext = ""
    i.inventory = {
        { -- itemstack
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
            { type = "sky-crystal", img = Image.crystal },
        },
        { -- itemstack
            { type = "cannonball", img = Image.cannonball },
            { type = "cannonball", img = Image.cannonball },
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
        love.graphics.setColor(0,0,0)
        local x,y = love.graphics.getWidth()/4-love.graphics.getWidth()/8, love.graphics.getHeight()/2-32
        -- love.graphics.rectangle("fill", x-16, y-16, x+16*5, y + 16)
        for i=0,4 do
            love.graphics.setColor(1,1,1)
            love.graphics.draw(Image.border, x-8+i*33, y-16)
        end
        local i = 0
        for itemstack in all(self.inventory) do
            love.graphics.setColor(1,1,1)
            -- love.graphics.draw(Image.border, x-16+i, y-16)
            love.graphics.draw(itemstack[1].img, x+i*33, y)
            love.graphics.printf(#itemstack.." ", x-8+i*33, y+16, 32,"center")
            i = i + 1
        end
        love.graphics.setColor(1,1,1)
        love.graphics.print(self.interacttext, 0, love.graphics.getHeight()/2-16)
    end
    i.update = function(self)
    end
    i.turn = function()

    end
    i.keypressed = function(self, key)
        if key == "x" then 
            local t = Game.map:get(self.x + self.ox, self.y + self.oy)
            if t and t.blocking then
                if t.interact then t:interact(self) end
            end
            Game.locked = true
            timer.after(0.2, function()
                Game.locked = false
            end)
            return true
        end
        self.interacttext = ""
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
        self.ox = x
        self.oy = y
        local t = Game.map:get(self.x + x, self.y + y)
        local blocked
        if t and t.blocking then
            if t.interacttext then self.interacttext = t.interacttext end
            blocked = true
        end
        if self.y + y < Game.horizon then
            -- enter the skyship
            if not Game.skyship.broken and self.y + y == Game.skyship.y and self.x + x == Game.skyship.x then
                love.audio.stop()
                Music.air:play()
                Sfx.entry:play()
                Game.human = Game.player
                Game.player = Game.skyship
                del(Game.entities, Game.human)
            end
            return false
        end
        if not blocked and self.x + x >= 0 and self.x + x < -1 + love.graphics.getWidth()/2/16 and self.y + y < -1 + love.graphics.getHeight()/2/16  then
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