AngerWeapon = {}
AngerWeapon.__index = AngerWeapon;

function AngerWeapon.new()
  local self = setmetatable({}, AngerWeapon)
  self.cooldown = 1
  return self
end

function AngerWeapon.Fire(self, player)
  local bullPos = player.pos + Vector2.new(player.width / 2, -player.height)
  for i = 1, 4 do
    local ang = -math.pi * (2 * i - 2) / 6
    local bullet = Bullet.new(bullPos)
    bullet:SetForward(Vector2.new(math.cos(ang), math.sin(ang)))
  end

end