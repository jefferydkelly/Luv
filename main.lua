require('jTable')
require('jTimer')
require('collisionManager')
require('gameObject')
require('player')
require('enemy')
require('Obstacle')



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

function GetPlayer()
  return player;
end

function Draw(self)
  for i = 1, #gameObjects do
    gameObjects[i]:Draw()
  end
end

function love.load()
  gameObjects = JTable.new();
  player = Player.new()
  local e1 = Enemy.new()
  e1.pos.x = love.graphics.getWidth() / 5;
  e1.moveLeft = true;
  local e2 = Enemy.new()
  e2.pos.x = love.graphics.getWidth() * 4 / 5;
  Obstacle.new(Vector2.new(love.graphics.getWidth(), love.graphics.getHeight()) / 2)

end
function love.update(dt)
  GetCollisionManager():Update();
  GetTimerManager():Update(dt);
  Update(dt)
end
function love.draw()
  Draw()
end
