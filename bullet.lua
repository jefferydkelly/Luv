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
    self.pos = self.pos + (self.fwd * self.moveSpeed * dt);
  end,
  GetDrawPos = function(self)
    local dims = Vector2.new(self.width, self.height):Rotated(self.rotation) / 2
    return Vector2.new(self.pos.x - dims.x, self.pos.y - dims.y)
  end,
  Draw = function(self)
    local drawPos = self:GetDrawPos()
    love.graphics.draw(self.sprite, drawPos.x, drawPos.y, self.rotation)
  end,
  HandleCollision = function(self, other)
    if not other.tag == "Bullet" then
      self:Die();
    end
  end,
  SetForward = function(self, fwd)
    self.fwd = fwd;
    self.rotation = fwd:Get_Angle()
  end
}
Bullet.__index = Bullet;

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
  AddGameObject(self)
  return self;
end