require('Player')
require('jTimer')
local player = Player.new()
local gameObjects = {Player}
local gm = nil;
local GameManager = {}
GameManager.__index = GameManager;
function GetGameManager()
  if gm == nil then
    gm = setmetatable({},GameManager)
    gm.gameObjects = {player};
    gm.toAdd = {}
    gm.toRemove = {}
  end
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

function GameManager.Draw(self)
  love.graphics.print(#GetTimerManager().timers, 100, 100)
  for i = 1, #self.gameObjects do
    self.gameObjects[i]:Draw()
  end
end
function love.update(dt)
  GetTimerManager():Update(dt);
  GetGameManager():Update(dt)
end
function love.draw()
  GetGameManager():Draw()
end
