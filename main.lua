require('jTable')
require('jTimer')
require('collisionManager')
require('Player')
require('Enemy')



local player = nil;
local toAdd = {}
local toRemove = {};
local gameObjects = {};

function AddGameObject(go)
  Add(toAdd, go)
end

function RemoveGameObject(go)
  Add(toRemove, go)
end

function Update(dt)

  for i = 1, #toAdd do
    Add(gameObjects, toAdd[i])
  end
  toAdd = {};

  for i = 1, #gameObjects do
    gameObjects[i]:Update(dt)
  end

  for i = 1, #toRemove do
    Remove(gameObjects, toRemove[i])
  end
  toRemove = {};
end

function Draw(self)
  love.graphics.print(#toAdd, 100, 100)
  love.graphics.print(#gameObjects, 100, 200)
  for i = 1, #gameObjects do
    gameObjects[i]:Draw()
  end
end

function love.load()
  gameObjects = {};
  Player.new()
  Enemy.new()
end
function love.update(dt)
  GetCollisionManager():Update();
  GetTimerManager():Update(dt);
  Update(dt)
end
function love.draw()
  Draw()
end
