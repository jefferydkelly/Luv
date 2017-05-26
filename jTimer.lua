require('jTable')
JTimer = {};
JTimer.__index = JTimer;

function JTimer.new(time)
  local self = setmetatable({}, JTimer)
  self.del = nil;
  self.tar = nil;
  self.time = time;
  self.runTime = 0;
  return self
end

function JTimer.Update(self, dt)
  self.runTime = self.runTime + dt;
  if self.runTime >= self.time then
    if self.del ~= nil then
      self.del(self.tar)
    end
    self.runTime = 0;
    return true;
  end
  return false;
end

function JTimer.Start(self)
  self.runTime = 0;
  GetTimerManager():Add(self)
end

function JTimer.Stop(self)
  GetTimerManager():Remove(self)
  self.runTime = 0;
end

TimerManager = {
}
local instance = nil;
TimerManager.__index = TimerManager;

function GetTimerManager()
  if instance == nil then
    instance = setmetatable({}, TimerManager)
    instance.timers = JTable.new();
    instance.toAdd = JTable.new();
    instance.toRemove = JTable.new();
  end
  return instance;
end

function TimerManager.Add (self, jt)
  self.toAdd:Add(jt)
end

function TimerManager.Remove(self, jt)
  self.toRemove:Add(jt)
end

function TimerManager.Update(self, dt)

  for i = 1, #self.toAdd do
    self.timers:Add(self.toAdd[i])
    self.toAdd:Remove(self.toAdd[i])
  end

  for i = 1, #self.timers do
    if self.timers[i]:Update(dt) then
      self.toRemove:Add(self.timers[i])
    end
  end

  for i = 1, #self.toRemove do
    self.timers:Remove(self.toRemove[i])
    self.toRemove:Remove(self.toRemove[i])
  end

end

