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
  self.rotation = 0;
  self.fwd = Vector2.new(0, 1)
  AddGameObject(self)
  return self;
end

function Enemy.GetDrawPos(self)
  return Vector2.new(self.pos.x - (self.width * math.cos(self.rotation)) / 2, self.pos.y - (self.height * math.sin(self.rotation)) / 2)
end

function Enemy.SetForward(self, fwd)
  self.fwd = fwd;
  self.rotation = self.fwd:Get_Angle()
end
function Enemy.Draw(self)
  local drawPos = self:GetDrawPos()
  love.graphics.draw(self.sprite, drawPos.x, drawPos.y, self.rotation)
end

function Enemy.Update (self, dt)

end

function Enemy.HandleCollision(self, other)
  if (other.tag == "Bullet") then
    RemoveGameObject(self)
  end
end