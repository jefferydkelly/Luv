JTimer = {};
JTimer.__index = JTimer;

function JTimer.new(del, time)
  local self = setmetatable({}, JTimer)
  self.del = del;
  self.time = time;
  self.runTime = 0;
  return self
end

function JTimer.Update(self, dt)
  self.runTime = self.runTime + dt;
  if self.runTime >= self.time then
    self.del();
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
  timers = {
    indexOf = function (self, val)
      for i = 1, #self do
        if self[i] == val then
          return i;
        end
      end
      return 0;
    end
  }
}
local instance = nil;
TimerManager.__index = TimerManager;

function GetTimerManager()
  if instance == nil then
    instance = setmetatable({}, TimerManager)
  end
  return instance;
end

function TimerManager.Add (self, jt)
  table.insert(self.timers, jt)
end

function TimerManager.Remove(self, jt)
  table.remove(jt)
end

function TimerManager.Update(self, dt)
  local toRemove = {}
  for i = 1, #self.timers do
    if self.timers[i]:Update(dt) then
      table.insert(toRemove, self.timers[i])
    end
  end

  for i = 1, #toRemove do
    local ind = self.timers:indexOf(toRemove[i]);
    if ind > 0 then
      table.remove(self.timers, ind)
    end
  end
end

