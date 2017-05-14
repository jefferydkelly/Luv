require('jTable')
require('jTimer')
require('collisionManager')
require('GameObject')
require('Player')
require('Enemy')



local player = nil;
local toAdd = JTable.new()
local toRemove = JTable.new();
local gameObjects = JTable.new();

function AddGameObject(go)
  toAdd:Add(go)
end

function RemoveGameObject(go)
  toRemove:Add(go)
end

function Update(dt)

  for i = 1, #toAdd do
    gameObjects:Add(toAdd[i])
    toAdd:Remove(toAdd[i])
  end

  for i = 1, #gameObjects do
    gameObjects[i]:Update(dt)
  end

  for i = 1, #toRemove do
    gameObjects:Remove(toRemove[i])
    toRemove:Remove(toRemove[i])
  end
end

function Draw(self)
  love.graphics.print(#gameObjects, 100, 100)
  for i = 1, #gameObjects do
    gameObjects[i]:Draw()
  end
end

function love.load()
  gameObjects = JTable.new();
  player = Player.new()
end
function love.update(dt)
  GetCollisionManager():Update();
  GetTimerManager():Update(dt);
  Update(dt)
end
function love.draw()
  Draw()
end
