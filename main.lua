require('jTable')
require('jTimer')
require('fileLoader')
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
  local json = LoadJson('json/test.json')
  local epr = json["enemiesPerLine"]
  local sy = json["startY"]
  for i = 1, json["numberOfLines"] do
    local moveLeft = true
    for j = 1, epr do
      local enemy = Enemy.new()
      enemy.pos = Vector2.new(love.graphics.getWidth() * j / (epr + 1), sy - 100 * (i - 1))
      enemy.moveLeft = moveLeft
      moveLeft = not moveLeft
    end
  end
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
