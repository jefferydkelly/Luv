require('vector')
require('jTimer')
require('bullet')
require('collisionManager')

Enemy = {}
Enemy.__index = Enemy;
local enemySprite = love.graphics.newImage('Sprites/Enemy.png')

function Enemy.new()
  local self = setmetatable({}, Enemy)
  self.pos = Vector2.new(love.graphics.getWidth() / 2, 70)
  self.sprite = enemySprite
  self.width, self.height = enemySprite:getDimensions()
  self.canFire = true;
  self.refreshTimer = JTimer.new(function () self.canFire = true end, 1)
  self.body = JCollider.newRectangleShape(self.width, self.height, self)
  self.body.gameObject = self;
  self.tag = "Enemy"
  AddGameObject(self)
  return self;
end

function Enemy.Draw(self)
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
  self.body:Draw({0, 0, 255})
end

function Enemy.Update (self, dt)

end

function Enemy.HandleCollision(self, other)
  if (other.tag == "Bullet") then
    RemoveGameObject(self)
  end
end