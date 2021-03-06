--
--  Game
--

local Gamestate     = requireLibrary("hump.gamestate")
local timer         = requireLibrary("hump.timer")
local Vector        = requireLibrary("hump.vector")
local tween         = timer.tween

local Lost = Gamestate.new()
local rounds = 0
function Lost:enter(prev, r)
    rounds = r
end

function Lost:update(dt) end

function Lost:draw()
    Game:draw()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0,0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,1,1)
    love.graphics.print("Oh no, the invaders made it to the ground, you lost, try again!", 50, 200)
    love.graphics.print("You survived "..rounds.." rounds!", 50, 232)
    love.graphics.print("[enter] to restart!", 50, 264)
end

function Lost:turn()
end

function Lost:keypressed(key)
    if key == "return" then
        Gamestate.switch(Game)
    end
end
return Lost