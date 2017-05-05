require('vector')
require('jTimer')
Bullet = {}
Bullet.__index = Bullet;

local bulletSprite = love.graphics.newImage("Sprites/Bullet.png")
function Bullet.new(pos)
  local self = setmetatable({}, Bullet)
  self.sprite = bulletSprite;
  self.width, self.height = bulletSprite:getDimensions()

  self.pos = pos - Vector2.new(self.width / 2, 0);
  self.moveSpeed = 500;
  self.body = love.physics.newBody(GetGameManager():GetWorld(), self.pos.x, self.pos.y, "dynamic")
  self.shape = love.physics.newRectangleShape(self.width, self.height)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  return self;
end

function Bullet.Update (self, dt)
  self.pos.y = self.pos.y - self.moveSpeed * dt;
  self.body:setPosition(self.pos.x, self.pos.y)
end

function Bullet.Draw(self)
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
end