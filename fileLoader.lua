function split(s, sub)
  local splits = {}
  local startIndex = 1;
  local str = s;
  local si, ei = str:find(sub)
  while  si ~= nil do
    table.insert(splits, str:sub(1, ei-1))
    str = str:sub(ei+1)
    si, ei = str:find(sub)
  end
  table.insert(splits, str)
  return splits
end

function LoadJson(file)
  if love.filesystem.exists(file) then
    local rFile = love.filesystem.read(file):sub(2,-2)
    local json = {}
    local splits = split(rFile, ",")

    local testString = split(splits[1], ":")

    for i = 1, #splits do
      local ss = split(splits[i], ':')
      local k = removeWrapQuotes(ss[1])
      local v = parseValue(ss[2])
      json[k] = v
    end

    return json
  else
    return nil;
  end
end

function removeWrapQuotes(s)
  local si, ei = s:find('\".*\"')
  if si == nil then
    return s;
  end
  return s:sub(si+1, ei-1)
end

function parseValue(s)
  local si, ei = s:find('\".*\"')
  if si ~= nil then
    return s:sub(si+1, ei-1)
  elseif tonumber(s) ~= nil then
    return tonumber(s)
  else
    return s:lower() == "true"
  end
end


