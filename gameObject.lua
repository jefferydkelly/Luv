require('vector')
local GameObject = {
  fwd = Vector2.new(0, 0),
  pos = Vector2.new(0, 0),
  sprite = nil,
  width, height = 0, 0,
  rotation = 0,
  body = nil,
  Die = function(self)
    GetCollisionManager():RemoveBody(self.body)
    RemoveGameObject(self)
  end,
  GetDrawPos = function(self)
    return Vector2.new(self.pos.x - (self.width * math.cos(self.rotation)) / 2, self.pos.y - (self.height * math.sin(self.rotation)) / 2)
  end,
  Draw = function(self)
    local drawPos = self:GetDrawPos()
    love.graphics.draw(self.sprite, drawPos.x, drawPos.y, self.rotation)
    self.body:Draw({255, 0, 0})
  end,
  SetForward = function(self, fwd)
    self.fwd = fwd;
    self.rotation = self.fwd:Get_Angle()
  end

}
GameObject.__index = GameObject;

function GameObject.new()
  local self = setmetatable({}, GameObject)
  return self
end