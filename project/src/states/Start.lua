--
--  Game
--

local Gamestate     = requireLibrary("hump.gamestate")
local timer         = requireLibrary("hump.timer")
local Vector        = requireLibrary("hump.vector")
local tween         = timer.tween

local Start = Gamestate.new()

function Start:enter() end

function Start:update(dt) end

function Start:draw()
    
    love.graphics.scale(2,2)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Captain Beardy", 300, 32)

    love.graphics.print([[
Please, Captain Beardy, help us!
We found sky crystals that can be used to stop time and all movement in the sky.
We are a peaceful town. But now the skypirates want the crystals and are attacking us with skydiving pirates.
Gather wood and use it as fuel in you airship. Crush rocks for cannon balls.
Board your ship and blast 'em away. Don't let them get to the ground.
Use the crystals on the beacon to stop time while the invaders come pooring from the sky.
]], 50, 100)

    love.graphics.print("Controls\nMovement: arrow keys\nx: interact, shoot cannon in ship", 50, 200)

    love.graphics.print("[enter] to start the game", 50, 300)

end

function Start:turn()
end

function Start:keypressed(key)
    if key == "return" then
        Gamestate.switch(Game)
    end
end
return Start