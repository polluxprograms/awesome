require('lib.table-serialization')

local awful = require('awful')
local tags = require('pollux.tags')

local state_file = awful.util.get_cache_dir() .. '/state'

local map = function(table, f)
  local out = {}
  for k, v in pairs(table) do
    nk, nv = f(k, v)
    out[nk] = nv
  end
  return out
end

local save = function ()
  local tag_data = map(tags.tags, function (n, t)
    return n, {
      master_width_factor = t.master_width_factor,
      master_fill_policy = t.master_fill_policy,
      master_count = t.master_count,
      column_count = t.column_count
    }
  end)

  local client_data = map(client.get(), function (_, c)
    return c.window, {
      tag = c.first_tag.name
    }
  end)

  local state = {
    tag_data = tag_data,
    client_data = client_data
  }
  
  table.save(state, state_file)
end

local restore = function ()
  if io.open(state_file, 'r') == nil then
    return false
  end

  local state = table.load(state_file)
  os.remove(state_file)

  for k, v in pairs(state.tag_data) do
    local new_tag = tags.create_tag(k, awful.screen.focused())
    new_tag.master_width_factor = v.master_width_factor
    new_tag.master_fill_policy = v.master_fill_policy
    new_tag.master_count = v.master_count
    new_tag.column_count = v.column_count
  end

  client.connect_signal('manage', function (c)
    if state.client_data[c.window] then
      c:tags({tags.tags[state.client_data[c.window].tag]})
    end
  end)
;
  return true
end

return { save = save, restore = restore }
