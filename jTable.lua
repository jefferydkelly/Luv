JTable = {}
JTable.__index = JTable;
function JTable.new()
  local self = setmetatable({}, JTable)
  return self;
end

function JTable.Add(self, el)
  table.insert(self, el)
end

function JTable.Remove (self, el)
  local ind = self:IndexOf(el)
  if (ind > 0) then
    table.remove(self, ind)
  end
end

function JTable.IndexOf(self, el)
  for i = 1, #self do
    if self[i] == el then
      return i;
    end
  end
  return 0;
end

function JTable.Clear(self)
  for i = 1, #self do
    self[i] = nil
  end
end
