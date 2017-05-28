require('vector')
require('jTimer')
require('bullet')
require('collisionManager')

Enemy = {}
Enemy.__index = GameObject;
local enemySprite = love.graphics.newImage('Sprites/Enemy.png')

function Enemy.new()
  local self = setmetatable({}, Enemy)

  self.Update = function(self, dt)
    if (not self.moveLeft and self.pos.x <= 50) or (self.moveLeft and self.pos.x >= love.graphics.getWidth() - 50) then
      self.moveLeft = not self.moveLeft;
      self:HopForward()
    end

    if self.pos.y >= love.graphics.getHeight() then
      self.pos.y = self.pos.y - love.graphics.getHeight();
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

  self.HandleCollision = function(self, other)
    if other.tag == "Bullet" and other.isPlayerAligned then
      self:Die()
    elseif other.tag == "Enemy" then
      self.moveLeft = not self.moveLeft;
      if self.moveLeft then
        self.pos.x = self.pos.x + 5
      else
        self.pos.x = self.pos.x - 5
      end
      self:HopForward()
    elseif other.tag == "Obstacle" then
      self:HopForward()
    end
  end

  self.HopForward = function(self)
    self.pos.y = self.pos.y + self.height / 2
  end

  self.Fire = function(self)
    local bullet = Bullet.new(Vector2.new(self.pos.x, self.pos.y + self.height * 2))
    bullet:SetForward(Vector2.new(0, 1))
    self.canFire = false;
    self.cooldownTimer:Start()
  end

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