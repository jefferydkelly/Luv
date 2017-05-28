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
local curLevel = 0
local levelOver = false
local isGameOver = false

function LoadLevel()
  levelOver = false
  curLevel = curLevel + 1
  local json = LoadJson('json/level'..tostring(curLevel)..'.json')
  if json ~= nil then
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
  else
    GameOver()
  end
end

function GameOver()
  gameObjects:Clear()
  isGameOver = true
end

local loadTimer = JTimer.new(1)
JTimer.del = LoadLevel;


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

  if not levelOver then
    local numEnemies = 0
    for i = 1, #gameObjects do
      if gameObjects[i].tag == "Enemy" then
        numEnemies = numEnemies + 1
      end
    end

    if numEnemies == 0 then
      levelOver = true
      loadTimer:Start()
    end
  end
end

function GetPlayer()
  return player;
end

function Draw(self)
  if not isGameOver then
    for i = 1, #gameObjects do
      gameObjects[i]:Draw()
    end

    love.graphics.print("Lives: " .. player.livesRemaining, 50, 50)
  else
    love.graphics.print("Game Over", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  end
end

function love.load()
  love.graphics.setNewFont(28)
  gameObjects = JTable.new();
  player = Player.new()
  Obstacle.new(Vector2.new(love.graphics.getWidth(), love.graphics.getHeight()) / 2)
  LoadLevel()
end
function love.update(dt)
  GetCollisionManager():Update();
  GetTimerManager():Update(dt);
  Update(dt)
end
function love.draw()
  Draw()
end
