require('vector')
require('jTable')
require('jTimer')
require('bullet')
require('collisionManager')
require('CryWeapon')
require('AngerWeapon')
Player = {}
Player.__index = GameObject;
local playerSprite = love.graphics.newImage('Sprites/Player.png')
function Player.new()
  local self = setmetatable({}, Player)

  self.Update = function(self, dt)
    if not self.isDead then
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
  end
  self.Draw = function(self)
    if not self.isDead then
      local drawPos = self:GetDrawPos()
      love.graphics.draw(self.sprite, drawPos.x, drawPos.y, self.rotation)
    end
    --love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
    love.graphics.print("Lives: " .. self.livesRemaining, 50, 50)
  end
  self.Fire = function(self)
    self.weapon:Fire(self)
    self.canFire = false;
    self.refreshTimer:Start()
  end
  self.HandleCollision = function(self, other)
    if other.tag == "Bullet" and not self.isDead then
      if self.livesRemaining > 0 then
        self.isDead = true;
        self.refreshTimer:Stop()
        self.respawnTimer:Start()
        self.livesRemaining = self.livesRemaining - 1
      else
        GameOver()
      end
    end
  end

  self.Reset = function(self)
    self.canFire = true
  end

  self.Respawn = function(self)
    self.isDead = false
    self.canFire = true
  end
  self.livesRemaining = 3
  self.pos = Vector2.new(love.graphics.getWidth() / 2, love.graphics.getHeight() - 70)
  self.sprite = playerSprite
  self.width, self.height = playerSprite:getDimensions()
  self.canFire = true;
  self.refreshTimer = JTimer.new(1)
  self.refreshTimer.tar = self;
  self.refreshTimer.del = self.Reset;
  self.respawnTimer = JTimer.new(2)
  self.respawnTimer.del = self.Respawn;
  self.respawnTimer.tar = self
  self.body = JCollider.newRectangleShape(self.width, self.height, self)
  self.body.gameObject = self;
  self.tag = "Player"
  self.weapon = CryWeapon.new()
  self.rotation = 0;
  self.isDead = false;
  AddGameObject(self)
  return self;
end
