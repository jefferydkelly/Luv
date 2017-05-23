require('vector')
require('jTimer')
require('bullet')
require('collisionManager')

Enemy = {}
Enemy.__index = GameObject;
local enemySprite = love.graphics.newImage('Sprites/Enemy.png')

function Enemy.new()
  local self = setmetatable({}, Enemy)
  self.pos = Vector2.new(love.graphics.getWidth() / 2, 70)
  self.sprite = enemySprite
  self.width, self.height = enemySprite:getDimensions()
  self.canFire = true;
  self.body = JCollider.newRectangleShape(self.width, self.height, self)
  self.body.gameObject = self;
  self.tag = "Enemy"
  self.rotation = 0;
  self.fwd = Vector2.new(0, 1)
  self.moveLeft = false;
  self.moveSpeed = 100
  self.cooldownTime = 0.5
  self.cooldownTimer = JTimer.new(self.cooldownTime)
  self.cooldownTimer.tar = self;
  self.cooldownTimer.del = function(self)
    self.canFire = true;
  end
  AddGameObject(self)
  return self;
end

function Enemy.Update (self, dt)
  if self.pos.x <= 50 or self.pos.x >= love.graphics.getWidth() - 50 then
    self.moveLeft = not self.moveLeft;
    self:HopForward()
  end
  local moveDir = Vector2.new(-1, 0)
  if self.moveLeft then
    moveDir = Vector2.new(1, 0)
  end
  self.pos = self.pos + (moveDir * self.moveSpeed * dt)

  if math.abs(self.pos.x - GetPlayer().pos.x) <= 50 and self.canFire then
    self:Fire()
  end
end

function Enemy.HandleCollision(self, other)
  if (other.tag == "Bullet") then
    RemoveGameObject(self)
  elseif other.tag == "Enemy" then
    self.moveLeft = not self.moveLeft;
    self:HopForward()
  elseif other.tag == "Obstacle" then
    self:HopForward()
  end
end

function Enemy.HopForward(self)
  self.pos.y = self.pos.y + self.height / 2
end

function Enemy.Fire(self)
  local bullet = Bullet.new(Vector2.new(self.pos.x, self.pos.y + self.height * 2))
  bullet:SetForward(Vector2.new(0, 1))
  self.canFire = false;
  self.cooldownTimer:Start()
end