require('jTable')
local CollisionManager = {}
CollisionManager.__index = CollisionManager;
local cm = nil;

function GetCollisionManager()
  if cm == nil then
    cm = setmetatable({}, CollisionManager)
    cm.bodies = JTable.new();
    cm.toAdd = JTable.new();
    cm.toRemove = JTable.new();
  end
  return cm
end

function CollisionManager.Update(self)
  local bodyA, bodyB = nil, nil;

  for i = 1, #self.toAdd do
    self.bodies:Add(self.toAdd[i])
  end
  self.toAdd:Clear()
  for i = 1, #self.bodies do
    bodyA = self.bodies[i];
    for j = 1, i - 1 do
      bodyB = self.bodies[j];
      if (bodyA:CheckForCollision(bodyB)) then
        bodyA.gameObject:HandleCollision(bodyB.gameObject)
        bodyB.gameObject:HandleCollision(bodyA.gameObject)
      end
    end
  end

  for i = 1, #self.toRemove do
    self.bodies:Remove(self.toRemove[i])
  end
  self.toRemove:Clear()
end

function CollisionManager.AddBody(self, body)
  self.toAdd:Add(body)
end

function CollisionManager.RemoveBody(self, body)
  self.toRemove:Add(body)
end

JCollider = {}
JCollider.__index = JCollider;

function JCollider.newRectangleShape(wid, hite, go)
  local self = setmetatable({}, JCollider)
  self.points = {};
  table.insert(self.points, Vector2.new(-wid / 2, -hite / 2))
  table.insert(self.points, Vector2.new(wid / 2, -hite / 2))
  table.insert(self.points, Vector2.new(wid / 2, hite / 2))
  table.insert(self.points, Vector2.new(-wid / 2, hite / 2))
  self.gameObject = go;
  GetCollisionManager():AddBody(self)
  return self;
end

function JCollider.GetWorldPoints(self)
  local worldPoints = {};
  local pos = self.gameObject.pos + Vector2.new(self.gameObject.width, self.gameObject.height) / 2 or Vector2.new(0, 0)
  for i = 1, #self.points do
    table.insert(worldPoints, self.points[i]:Rotated(self.gameObject.rotation) + pos)
  end

  return worldPoints;
end

function JCollider.Draw(self, color)
  local verts = JTable.new()
  love.graphics.setColor(color or {255, 255, 255})
  local pos = self.gameObject.pos or Vector2.new(0, 0)
  for i = 1, #self.points do
    local pPos = pos - self.points[i]:Rotated(self.gameObject.rotation)
    verts:Add(pPos.x)
    verts:Add(pPos.y)
  end
  love.graphics.polygon("fill", verts)
  love.graphics.setColor(255, 255, 255)
end
function JCollider.CheckForCollision(self, other)
  local myWorldPoints, theirWorldPoints = self:GetWorldPoints(), other:GetWorldPoints()
  local a, b, c, d, r, s = myWorldPoints[#myWorldPoints], nil, nil, nil, -1, -1
  for i = 1, #myWorldPoints do
    b = myWorldPoints[i]
    c = theirWorldPoints[#theirWorldPoints]
    for j = 1, #theirWorldPoints do
      d = theirWorldPoints[j]
      r = (((a.y - c.y) * (d.x - c.x)) - ((a.x - c.x) * (d.y - c.y)))/ (((b.x - a.x) * (d.y - c.y)) - ((b.y - a.y) * (d.x - c.x)))
      s = (((a.y - c.y) * (b.x - a.x)) - ((a.x - c.x) * (b.y - a.y)))/ (((b.x - a.x) * (d.y - c.y)) - ((b.y - a.y) * (d.x - c.x)))
      if r >= 0 and r <= 1 and s >= 0 and s <= 1 then
        return true
      end
      c = d;
    end
    a = b;
  end
  return false
end