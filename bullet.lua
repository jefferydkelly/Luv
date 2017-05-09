require('vector')
require('jTimer')
Bullet = {
  pos = Vector2.new(0, 0),
  body = nil,
  Die = function(self)
    GetCollisionManager():RemoveBody(self.body)
    RemoveGameObject(self)
  end,
  Update = function(self, dt)
    self.pos.y = self.pos.y - self.moveSpeed * dt;
  end,
  Draw = function(self)
    love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
    self.body:Draw({0, 255, 0})
  end,
  HandleCollision = function(self, other)
    self:Die();
  end
}
Bullet.__index = Bullet;

local bulletSprite = love.graphics.newImage("Sprites/Bullet.png")
function Bullet.new(pos)
  local self = setmetatable({}, Bullet)
  self.sprite = bulletSprite;
  self.width, self.height = bulletSprite:getDimensions()

  self.pos = pos - Vector2.new(self.width / 2, 0);
  self.moveSpeed = 500;
  self.body = JCollider.newRectangleShape(self.width, self.height, self)
  self.body.gameObject = self;
  self.destroyTimer = JTimer.new(2)
  self.destroyTimer.del = self.Die;
  self.destroyTimer.tar = self;
  self.destroyTimer:Start()
  self.tag = "Bullet"
  AddGameObject(self)
  return self;
end