local timer         = requireLibrary("hump.timer")
local tween         = timer.tween
local Cannonball     = require("src.entities.Cannonball")

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
        local bobbing = math.cos(self.frame)*self.bobbingAmplitude
        if self.broken then bobbing = 0 end
        love.graphics.draw(Image.skyship, self.x*16+self.dx*16+8, self.y*16+self.dy*16+8+bobbing, 0, self.dir, 1, 8, 8)
        if self.broken then
            love.graphics.draw(Image.redx, self.x*16+self.dx*16+8, self.y*16+self.dy*16+8, 0, self.dir, 1, 8, 8)
        end
    end
    i.update = function(self)
    end
    i.turn = function()

    end
    i.shoot = function(self)
        local found, stack
        for itemstack in all(Game.human.inventory) do
            if itemstack[1] and itemstack[1].type == "cannonball" then
                found = itemstack[1]
                stack = itemstack
            end
        end
        if not found then return end
        del(stack, found)
        if #stack == 0 then
            del(Game.human.inventory, stack)
        end
        Sfx.shootcannon:play()
        local c = Cannonball(Game, self.x, self.y, i.dir)
        add(Game.entities, c)
    end
    i.keypressed = function(self, key)
        if key == "x" then
            self:shoot()
            return true
        end
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
        if self.y == Game.horizon - 1 and x ~= 0 then
            x = 0
        end 
        if self.broken then x = 0; y = 1 end
        for e in all(Game.invaders) do
            if e.x == self.x + x and e.y == self.y + y then
                -- your ship breaks
                Sfx.fall:play()
                e.updatetimer = 0
                self.broken = true
                x = 0
                y = Game.horizon - self.y - 1
            end
        end
        for e in all(Game.entities) do
            if e.type == "bird" and e.x == self.x + x and e.y == self.y + y then
                -- your ship breaks
                Sfx.fall:play()
                e.updatetimer = 0
                self.broken = true
                x = 0
                y = Game.horizon - self.y - 1
            end
        end
        if self.y + y >= Game.horizon then
            Game.player = Game.human
            add(Game.entities, Game.human)
            Game.human.x = Game.skyship.x
            love.audio.stop()
            Music.ground:play()
            Sfx.entry:play()
            return false
        end
        
        if y < 0 then
            local found, stack
            for itemstack in all(Game.human.inventory) do
                if itemstack[1] and itemstack[1].type == "wood" then
                    found = itemstack[1]
                    stack = itemstack
                end
            end
            if not found then 
                if self.y == Game.horizon - 1 then
                    -- dont move if on horizon and no fuel
                    x = 0
                    y = 0
                    return false
                else
                    Sfx.fall:play()
                    self.broken = true
                    x = 0
                    y = Game.horizon - self.y - 1
                end
            else 
                del(stack, found)
                if #stack == 0 then
                    del(Game.human.inventory, stack)
                end
            end
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
            if self.broken then Sfx.crashland:play() end
        end)
        return true
    end
    return i
end

return Skyship