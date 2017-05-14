Vector2 = {
  __add = function(lhs, rhs)
    return Vector2.new(lhs.x + rhs.x, lhs.y + rhs.y)
  end,
  __sub = function(lhs, rhs)
    return Vector2.new(lhs.x - rhs.x, lhs.y - rhs.y)
  end,
  __mul = function(lhs, rhs)
    if (type(rhs) == "number") then
      return Vector2.new(lhs.x * rhs, lhs.y * rhs)
    else
      return lhs.x * rhs.x + lhs.y * rhs.y
    end
  end,
  __div = function(lhs, rhs)
    return Vector2.new(lhs.x / rhs, lhs.y / rhs)
  end
}
Vector2.__index = Vector2;

function Vector2.new(dx, dy)
  local self = setmetatable({}, Vector2)
  self.x = dx
  self.y = dy
  return self
end

function Vector2.copy (vec)
  return Vector2.new(vec.x, vec.y)
end

function Vector2.Normalize (self)
  local mag = self.Get_Magnitude()
  self.x = self.x / mag
  self.y = self.y / mag
end

function Vector2.Normalized (self)
  local mag = self:Get_Magnitude()
  if mag > 0 then
    return self / mag
  else
    return self
  end
end

function Vector2.Get_Magnitude(self)
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector2.Get_MagnitudeSqr(self)
  return self.x * self.x + self.y * self.y
end

function Vector2.Rotate(self, ang)
  local cos = math.cos(ang)
  local sin = math.sin(ang)
  local dx = self.x * cos - self.y * sin
  local dy = self.x * sin + self.y * cos
  x = dx;
  y = dy;
end

function Vector2.Rotated(self, ang)
  local cos = math.cos(ang)
  local sin = math.sin(ang)
  return Vector2.new(self.x * cos - self.y * sin, self.x * sin + self.y * cos)
end

function Vector2.Get_Angle(self)
  return math.pi / 2 + math.atan2(self.y, self.x)
end

function Vector2.Get_Info(self)
  return "X: " .. self.x .. " Y: " .. self.y;
end