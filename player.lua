require('vector')
require('jTable')
require('jTimer')
require('bullet')
require('collisionManager')
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
  AddGameObject(self)
  return self;
end

function Player.Reset(self)
  self.canFire = true
end
function Player.Draw(self)
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
  self.body:Draw({255, 0, 0})
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
  local bullPos = self.pos + Vector2.new(self.width / 2, -self.height * 0.8)

  Bullet.new(bullPos)
  self.canFire = false;
  self.refreshTimer:Start()
end

function Player.HandleCollision(self, other)
  if (other.tag == "Bullet") then
    RemoveGameObject(self)
  end
end