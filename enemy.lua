require('vector')
require('jTimer')
require('bullet')

Enemy = {}
Enemy.__index = Enemy;
local playerSprite = love.graphics.newImage('Sprites/Enemy.png')
function Enemy.new(world)
  local self = setmetatable({}, Enemy)
  self.pos = Vector2.new(love.graphics.getWidth() / 2, 70)
  self.sprite = playerSprite
  self.width, self.height = playerSprite:getDimensions()
  self.canFire = true;
  self.refreshTimer = JTimer.new(function () self.canFire = true end, 1)
  self.body = love.physics.newBody(world, self.pos.x, self.pos.y, "dynamic")
  self.shape = love.physics.newRectangleShape(self.width, self.height)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  return self;
end

function Enemy.Draw(self)
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
end

function Enemy.Update (self, dt)
  self.body:setPosition(self.pos.x, self.pos.y)
end