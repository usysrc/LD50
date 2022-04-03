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
local Beacon        = require("src.entities.Beacon")
local Mine          = require("src.entities.Mine")
local Boulder       = require("src.entities.Boulder")
local Tree          = require("src.entities.Tree")
local RepairShop    = require("src.entities.RepairShop")
local Bird          = require("src.entities.Bird")


Game = Gamestate.new()

function Game:enter()
    Game.rounds = 0
    love.audio.stop()
    Music.air:setVolume(0.2)
    Music.air:setLooping(true)
    Music.ground:setVolume(0.2)
    Music.ground:setLooping(true)
    love.audio.play(Music.ground)
    Game.entities = {}
    Game.tiles = {}
    Game.map = Map()
    Game.map:init()
    Game.horizon = 15
    Game.invaders = {}
    Game.effects = {}

    add(Game.entities, Bird(Game, 0, Game.horizon - 2))
    add(Game.entities, Bird(Game, 30, Game.horizon - 6))
    add(Game.entities, Vessel(Game, 1, 0))
    Game.player = Player(Game, 5, Game.horizon + 10)
    Game.human = Game.player
	add(Game.entities, Game.player)
    Game.skyship = Skyship(Game, 22, Game.horizon - 1)
    add(Game.entities, Game.skyship)

    -- add ground tiles
    for i=0,50 do
        for j=1,14 do
            local t = Tile(Game, i, Game.horizon + j -1, Image["grass"..math.floor(math.random(1,2))])
            add(Game.tiles, t)
            Game.map:set(t.x, t.y, t)
        end
    end

    local t = Beacon(Game, 25, Game.horizon + 5)
    add(Game.tiles, t)
    Game.map:set(t.x, t.y, t)
    
    local t = Mine(Game, 3, Game.horizon + 8)
    add(Game.tiles, t)
    Game.map:set(t.x, t.y, t)

    local t = Boulder(Game, 20, Game.horizon + 8)
    add(Game.tiles, t)
    Game.map:set(t.x, t.y, t)

    local t = Tree(Game, 15, Game.horizon + 3)
    add(Game.tiles, t)
    Game.map:set(t.x, t.y, t)

    local t = RepairShop(Game, 15, Game.horizon - 1)
    add(Game.tiles, t)
    Game.map:set(t.x, t.y, t)
    
    local t = Tile(Game, 2, Game.horizon + 8, Image.Mountain)
    add(Game.tiles, t)
    Game.map:set(t.x, t.y, t)
    
    
    -- add sky islands
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
    elseif love.keyboard.isDown("x") then
        if Game.player:keypressed("x") then
            Game:turn()
        end
    end
end

function Game:draw()
    love.graphics.clear(49/255, 162/255,242/255)
    love.graphics.scale(2,2)
    for e in all(Game.tiles) do
        e:draw()
    end
    for e in all(Game.entities) do
        e:draw()
    end
    for e in all(Game.effects) do
        e:draw()
    end
    love.graphics.setColor(1,1,1)
    love.graphics.line(0,Game.horizon*16,love.graphics.getWidth(), Game.horizon*16)
    Game.human:drawGui()
end

function Game:turn()
    Game.rounds = Game.rounds + 1
    for e in all(Game.entities) do
        e:turn()
    end
    for t in all(Game.tiles) do
        t:turn()
    end
end

function Game:keypressed(key)
    if Game.locked then return end
    
end