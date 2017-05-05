require('Player')
require('jTimer')
require('Enemy')
local player = nil;
local gameObjects = {Player}
local gm = nil;
local GameManager = {}
local numCollisions = 0;
GameManager.__index = GameManager;
local type1 = ""
local type2 = ""
function GetGameManager()
  return gm;
end

function GameManager.AddGameObject(self, go)
  table.insert(self.toAdd, go)
end

function GameManager.RemoveGameObject(self, go)
  table.insert(self.toRemove, go)
end

function GameManager.NumObjects(self)
  return #self.gameObjects;
end
function GameManager.Update(self, dt)
  for i = 1, #self.gameObjects do
    self.gameObjects[i]:Update(dt)
  end

  for i = 1, #self.toAdd do
    table.insert(self.gameObjects, self.toAdd[i])
  end
  self.toAdd = {};
end

function GameManager.GetWorld (self)
  return self.world;
end
function GameManager.Draw(self)
  love.graphics.print(type1, 100, 100)
  love.graphics.print(type2, 100, 200)
  for i = 1, #self.gameObjects do
    self.gameObjects[i]:Draw()
  end
end

function love.load()
  gm = setmetatable({},GameManager)
  gm.toAdd = {}
  gm.toRemove = {}
  gm.world = love.physics.newWorld(0, 0, true);
  gm.world:setCallbacks(beginContact)
  player = Player.new(gm.world)
  gm.gameObjects = {player, Enemy.new(gm.world)};
end
function love.update(dt)
  gm.world:update(dt)
  GetTimerManager():Update(dt);
  GetGameManager():Update(dt)
end
function love.draw()
  GetGameManager():Draw()
end

function beginContact(a, b, coll)
  if a == player.fixture or b == player.fixture then
    type1 = "Destroyed"
  end
end
