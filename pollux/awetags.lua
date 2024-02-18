require('table-serialization')
local awful = require('awful')

local state_file = awful.util.get_cache_dir() .. '/state'
local awetags = { tags = {} }

awetags.close_tag = function (tag)
  -- Close all clients to prevent orphans
  for _, c in pairs(tag:clients()) do
    c:kill()
  end
  awetags.tags[tag.name] = nil
  local screen = tag.screen
  tag:delete()
  awful.tag.viewnone(screen)
  screen:emit_signal('tag::changed')
end

awetags.create_tag = function (name, screen)
  local tag = awful.tag.add(name, {
    screen = screen,
    layout = awful.layout.suit.tile
  })
  awetags.tags[name] = tag
  tag:view_only()
  screen:emit_signal('tag::changed')
  return tag
end

awetags.show_tag = function (tag, screen)
  local oldscreen = tag.screen
  if oldscreen ~= screen then
    if oldscreen.selected == tag then
      awful.tag.viewnone(oldscreen)
    end
    tag.screen = screen
  end
  tag:view_only()
  screen:emit_signal('tag::changed')
  oldscreen:emit_signal('tag::changed')
end

awetags.rename_tag = function (tag, new_name)
  awetags.tags[tag.name] = nil
  awetags.tags[new_name] = tag
  tag.name = new_name
  tag.screen:emit_signal('tag::changed')
end

local map = function(table, f)
  local out = {}
  for k, v in pairs(table) do
    local nk, nv = f(k, v)
    out[nk] = nv
  end
  return out
end

awetags.save = function ()
  local tag_data = map(awetags.tags, function (n, t)
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

awetags.restore = function ()
  if io.open(state_file, 'r') == nil then
    return false
  end

  local state = table.load(state_file)
  os.remove(state_file)

  for k, v in pairs(state.tag_data) do
    local new_tag = awetags.create_tag(k, awful.screen.focused())
    new_tag.master_width_factor = v.master_width_factor
    new_tag.master_fill_policy = v.master_fill_policy
    new_tag.master_count = v.master_count
    new_tag.column_count = v.column_count
  end

  client.connect_signal('manage', function (c)
    if state.client_data[c.window] then
      c:tags({awetags.tags[state.client_data[c.window].tag]})
    end
  end)
;
  return true
end

return awetags
