require('vector')
require('jTimer')
require('bullet')
Player = {}
Player.__index = Player;
local playerSprite = love.graphics.newImage('Sprites/Player.png')
function Player.new(world)
  local self = setmetatable({}, Player)
  self.pos = Vector2.new(love.graphics.getWidth() / 2, love.graphics.getHeight() - 70)
  self.sprite = playerSprite
  self.width, self.height = playerSprite:getDimensions()
  self.canFire = true;
  self.refreshTimer = JTimer.new(function () self.canFire = true end, 1)
  self.body = love.physics.newBody(world, self.pos.x, self.pos.y, "dynamic")
  self.shape = love.physics.newRectangleShape(self.width, self.height)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  return self;
end

function Player.Draw(self)
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
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
  self.body:setPosition(self.pos.x, self.pos.y)
end

function Player.Fire(self)
  local bullPos = self.pos + Vector2.new(self.width / 2, -self.height * 0.8)
  local bull = Bullet.new(bullPos)
  GetGameManager():AddGameObject(bull)
  self.canFire = false;
  self.refreshTimer:Start()
end