require('vector')
require('jTable')
require('jTimer')
require('bullet')
require('collisionManager')
require('CryWeapon')
require('AngerWeapon')
Player = {}
Player.__index = Player;
local playerSprite = love.graphics.newImage('Sprites/Player.png')
function Player.new()
  local self = setmetatable({}, Player)
  self.pos = Vector2.new(love.graphics.getWidth() / 2, love.graphics.getHeight() - 70)
  self.sprite = playerSprite
  self.width, self.height = playerSprite:getDimensions()
  self.canFire = true;
  self.refreshTimer = JTimer.new(1)
  self.refreshTimer.tar = self;
  self.refreshTimer.del = self.Reset;
  self.body = JCollider.newRectangleShape(self.width, self.height, self)
  self.body.gameObject = self;
  self.tag = "Player"
  self.weapon = AngerWeapon.new()
  self.rotation = 0;
  AddGameObject(self)
  return self;
end

function Player.Reset(self)
  self.canFire = true
end
function Player.Draw(self)
  local drawPos = self:GetDrawPos()
  love.graphics.draw(self.sprite, drawPos.x, drawPos.y, self.rotation)
end

function Player.GetDrawPos(self)
  local dims = Vector2.new(self.width, self.height):Rotated(self.rotation) / 2
  return Vector2.new(self.pos.x - dims.x, self.pos.y - dims.y)
end

function Player.SetForward(self, fwd)
  self.fwd = fwd;
  self.rotation = self.fwd:Get_Angle()
end
function Player.Update (self, dt)
  if self.canFire and love.mouse.isDown(1) then
    self:Fire()
  end
  local move = Vector2.new(0, 0)
  if love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
    move.x = -1;
  elseif love.keyboard.isDown('d') and not love.keyboard.isDown('a') then
    move.x = 1;
  end

  self.pos = self.pos + move:Normalized() * dt * 100
end

function Player.Fire(self)
  self.weapon:Fire(self)
  self.canFire = false;
  self.refreshTimer:Start()
end

function Player.HandleCollision(self, other)
  if (other.tag == "Bullet") then
    RemoveGameObject(self)
  end
end