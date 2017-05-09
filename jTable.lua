function Add(tab, val)
  table.insert(tab, val)
end

function Remove(tab, val)
  local ind = IndexOf(tab, val)
  if (ind > 0) then
    table.remove(tab, ind)
  end
end

function IndexOf(tab, val)
  for i = 1, #tab do
    if tab[i] == val then
      return i;
    end
  end
  return 0;
end