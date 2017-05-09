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
    self.del(self.tar)
    self.runTime = 0;
    return true;
  end
  return false;
end

function JTimer.Start(self)
  self.runTime = 0;
  GetTimerManager():Add(self)
end

TimerManager = {
}
local instance = nil;
TimerManager.__index = TimerManager;

function GetTimerManager()
  if instance == nil then
    instance = setmetatable({}, TimerManager)
    instance.timers = {};
    instance.toAdd = {};
    instance.toRemove = {};
  end
  return instance;
end

function TimerManager.Add (self, jt)
  Add(instance.toAdd, jt)
end

function TimerManager.Remove(self, jt)
  Add(instance.toRemove, jt)
end

function TimerManager.Update(self, dt)

  for i = 1, #self.toAdd do
    Add(instance.timers, self.toAdd[i])
  end
  self.toAdd = {}
  for i = 1, #self.timers do
    if self.timers[i]:Update(dt) then
      Add(self.toRemove, self.timers[i])
    end
  end

  for i = 1, #self.toRemove do
    Remove(self.timers, self.toRemove[i])
  end
  self.toRemove = {}
end

