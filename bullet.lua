require('vector')
require('jTimer')
Bullet = {}
Bullet.__index = GameObject;

local bulletSprite = love.graphics.newImage("Sprites/Bullet.png")
function Bullet.new(pos)
  local self = setmetatable({}, Bullet)
  self.sprite = bulletSprite;
  self.width, self.height = bulletSprite:getDimensions()
  self.pos = pos
  self.fwd = Vector2.new(0.0, -1.0)
  self.rotation = self.fwd:Get_Angle();
  self.moveSpeed = 500.0;
  self.body = JCollider.newRectangleShape(self.width, self.height, self)
  self.body.gameObject = self;
  self.destroyTimer = JTimer.new(2)
  self.destroyTimer.del = self.Die;
  self.destroyTimer.tar = self;
  self.destroyTimer:Start()
  self.tag = "Bullet"
  self.Update = function(self, dt)
    self.pos = self.pos + (self.fwd * self.moveSpeed * dt);
  end

  self.HandleCollision = function (self, other)
    if other.tag ~= "Bullet" then
      self:Die();
    end
  end
  AddGameObject(self)
  return self;
end