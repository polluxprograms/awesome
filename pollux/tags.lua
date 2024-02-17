local awful = require('awful')

local tagful = {
  tags = {}
}

tagful.close_tag = function (tag)
  tagful.tags[tag.name] = nil
  local screen = tag.screen
  tag:delete()
  awful.tag.viewnone(screen)
  screen:emit_signal('tag::changed')
end

tagful.create_tag = function (name, screen)
  local tag = awful.tag.add(name, {
    screen = screen,
    layout = awful.layout.suit.tile
  })
  tagful.tags[name] = tag
  tag:view_only()
  screen:emit_signal('tag::changed')
  return tag
end

tagful.show_tag = function (tag, screen)
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

tagful.rename_tag = function (tag, new_name)
  tagful.tags[tag.name] = nil
  tagful.tags[new_name] = tag
  tag.name = new_name
  tag.screen:emit_signal('tag::changed')
end

return tagful
