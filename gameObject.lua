require('vector')
GameObject = {
  fwd = Vector2.new(0, 0),
  pos = Vector2.new(0, 0),
  sprite = nil,
  width, height = 0, 0,
  rotation = 0,
  body = nil,
  isPlayerAligned = false,
  Die = function(self)
    GetCollisionManager():RemoveBody(self.body)
    RemoveGameObject(self)
  end,
  GetDrawPos = function(self)
    local dims = Vector2.new(self.width, self.height):Rotated(self.rotation) / 2
    return Vector2.new(self.pos.x - dims.x, self.pos.y - dims.y)
  end,
  Draw = function(self)
    local drawPos = self:GetDrawPos()
    love.graphics.draw(self.sprite, drawPos.x, drawPos.y, self.rotation)
  end,
  SetForward = function(self, fwd)
    self.fwd = fwd;
    self.rotation = self.fwd:Get_Angle()
  end,
  SetSprite = function (self, sprite)
    self.sprite = sprite;
    self.width, self.height = sprite:getDimensions()
    self.body:updateDimensions()
  end,
  Update = function(self, dt)
  end,
  HandleCollision = function(self, other)
  end
}
GameObject.__index = GameObject;

function GameObject.new()
  local self = setmetatable({}, GameObject)
  return self
end