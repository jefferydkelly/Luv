Obstacle = {}
Obstacle.__index = Obstacle;

local obsImg = love.graphics.newImage("Sprites/Obstacle.png")

function Obstacle.new(pos)
  local self = setmetatable({}, Obstacle)
  self.pos = pos
  self.sprite = obsImg
  self.width, self.height = obsImg:getDimensions()
  self.body = JCollider.newRectangleShape(self.width, self.height, self)
  self.hp = 5
  self.tag = "Obstacle"
  self.rotation = 0
  self.drawPos = self.pos - Vector2.new(self.width, self.height) / 2
  AddGameObject(self)
end

function Obstacle.Update(self)
end

function Obstacle.GetDrawPos(self)
end
function Obstacle.Draw(self)
  love.graphics.draw(self.sprite, self.drawPos.x, self.drawPos.y, self.rotation)
end

function Obstacle.HandleCollision(self, other)
  if other.tag == "Bullet" then
    self.hp = self.hp - 1
    if self.hp <= 0 then
      GetCollisionManager():RemoveBody(self.body)
      RemoveGameObject(self)
    end
  end
end