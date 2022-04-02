--
--  Game
--

local Gamestate     = requireLibrary("hump.gamestate")
local timer         = requireLibrary("hump.timer")
local Vector        = requireLibrary("hump.vector")
local tween         = timer.tween
local Player        = require("src.entities.Player")
local Skyship       = require("src.entities.Skyship")
local Vessel        = require("src.entities.Vessel")
local Tile          = require("src.entities.Tile")


Game = Gamestate.new()

function Game:enter()
    Game.entities = {}
    Game.tiles = {}
    Game.map = Map()
    Game.map:init()
    Game.horizon = 30
    Game.invaders = {}

    add(Game.entities, Vessel(Game, 1, 0))
    Game.player = Player(Game, 5, Game.horizon+10)
    Game.human = Game.player
	add(Game.entities, Game.player)
    Game.skyship = Skyship(Game, 22, Game.horizon-1)
    add(Game.entities, Game.skyship)
    
    local starts = {}
    for i=1,6 do
        starts[#starts+1] = {
            x = (i-1)*10 + math.random(0, 4),
            y = math.random(5, Game.horizon - 10),
            l = math.random(6, 12)
        }
    end
    
    for s in all(starts) do
        for k=1,3 do
            for i=k, s.l-k do
                local t = Tile(Game, s.x+i, s.y+k)
                add(Game.tiles, t)
                Game.map:set(t.x, t.y, t)
            end
        end
    end
end

function Game:update(dt)
    timer.update(dt)
    for e in all(Game.entities) do
        e:update(dt)
    end
    if Game.locked then return end
    if love.keyboard.isDown("left") then
        if Game.player:keypressed("left") then
            Game:turn()
        end
    elseif love.keyboard.isDown("right") then
        if Game.player:keypressed("right") then
            Game:turn()
        end
    elseif love.keyboard.isDown("up") then
        if Game.player:keypressed("up") then
            Game:turn()
        end
    elseif love.keyboard.isDown("down") then
        if Game.player:keypressed("down") then
            Game:turn()
        end
    end
end

function Game:draw()
    for e in all(Game.tiles) do
        e:draw()
    end
    for e in all(Game.entities) do
        e:draw()
    end
    love.graphics.setColor(1,1,1)
    love.graphics.line(0,Game.horizon*16,love.graphics.getWidth(), Game.horizon*16)
end

function Game:turn()
    for e in all(Game.entities) do
        e:turn()
    end
end

function Game:keypressed(key)
    
end