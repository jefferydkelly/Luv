CryWeapon = {}
CryWeapon.__index = CryWeapon;

function CryWeapon.new()
  local self = setmetatable({}, CryWeapon)
  self.cooldown = 0.25
  return self
end

function CryWeapon.Fire(self, player)
  local bullPos = player.pos + Vector2.new(0, -player.height * 0.8)
  Bullet.new(bullPos)
  bullPos = player.pos + Vector2.new(player.width, -player.height * 0.8)
  Bullet.new(bullPos)
end