--[[
    Create Smelter
    by Konkito Man

    for: Lua Cobalt [https://github.com/SquidDev/Cobalt], CC-Tweaked, CC-ManOS [https://github.com/konkitoman/CC-ManOS]
    LICENSE: MIT
    Version: 0.0.1
]]

local gui = require("gui")
local event_loop = require("event_loop")

local reader = require("reader")
local red = require("red")

local default_data = {
  lava = false,
  water = false,
  crusher = false,
  press = false,
  fire = false,
  red_output = 0
}

local default_config = {
  wire_lava = "orange",
  fire_enable = true,
  wire_water = "blue",
  wire_crusher = "magenta",
  wire_press = "white",
  wire_fire = "yellow",
  lava_enable = true,
  water_enable = true,
  crusher_enable = true,
  press_enable = true,
  red_side = "right",
  monitor = "top"
}

local createConfig = function(config)
  return {
    wire_lava = red.colors:from_str(config.wire_lava),
    wire_water = red.colors:from_str(config.wire_water),
    wire_crusher = red.colors:from_str(config.wire_crusher),
    wire_press = red.colors:from_str(config.wire_press),
    wire_fire = red.colors:from_str(config.wire_fire),
    lava_enable = config.lava_enable,
    fire_enable = config.fire_enable,
    water_enable = config.water_enable,
    crusher_enable = config.crusher_enable,
    press_enable = config.press_enable,
    red_side = config.red_side,
    monitor = peripheral.wrap(config.monitor)
  }
end

local config = nil

local _data_path = nil
local _config_path = nil

local press_delay = 1

local lava_button = nil
local water_button = nil
local disable_button = nil
local crusher_button = nil
local press_button = nil
local fire_button = nil

-- save/load data

local function getData()
  return reader.read_file(_data_path)
end

local function setData(data)
  data.red_output = red.red_output
  reader.write_file(_data_path, data)
end

local is_used_lava = false
local is_used_water = false
local is_used_crusher = false
local is_used_press = false
local is_used_fire = false

-- set all buttons text and color

local function set_text()
  local data = getData()

  disable_button.background_color = colors.green

  if is_used_lava then
    lava_button:setText("Working: lava")
    lava_button.background_color = colors.yellow
  else
    if data.lava == true then
      lava_button:setText("Disable: lava")
      lava_button.background_color = colors.orange
    else
      lava_button:setText("Enable: lava")
      lava_button.background_color = colors.green
    end
  end

  if is_used_water then
    water_button:setText("Working: water")
    water_button.background_color = colors.yellow
  else
    if data.water == true then
      water_button:setText("Disable: water")
      water_button.background_color = colors.orange
    else
      water_button:setText("Enable: water")
      water_button.background_color = colors.green
    end
  end


  if is_used_crusher then
    crusher_button:setText("Working: crusher")
    crusher_button.background_color = colors.yellow
  else
    if data.crusher == true then
      crusher_button:setText("Disable: crusher")
      crusher_button.background_color = colors.orange
    else
      crusher_button:setText("Enable: crusher")
      crusher_button.background_color = colors.green
    end
  end

  if is_used_press then
    press_button:setText("Working: press")
    press_button.background_color = colors.yellow
  else
    if data.press == true then
      press_button:setText("Disable: press")
      press_button.background_color = colors.orange
    else
      press_button:setText("Enable: press")
      press_button.background_color = colors.green
    end
  end

  if is_used_fire then
    fire_button:setText("Working: fire")
    fire_button.background_color = colors.yellow
  else
    if data.fire == true then

      fire_button:setText("Disable: fire")
      fire_button.background_color = colors.orange
    else
      fire_button:setText("Enable: fire")
      fire_button.background_color = colors.green
    end
  end

  gui.requestRender()
end

--Button actions

local data

-- Lava button actions!

local function on_lava(state)
  data = getData()
  if state then
    is_used_lava = false
    set_text()
    gui.requestRender()
    return
  end
  if data.fire then
    is_used_fire = true
  end
  if data.lava == true then
    red:toggle_red(config.wire_lava)
    data.lava = false

    setData(data)
    set_text()
    gui.requestRender()

    event_loop:add_coroutine("on_lava", on_lava, { 1 }, 8)
    return
  end
  if data.water == true then
    red:toggle_red(config.wire_water)
    data.water = false
    event_loop:add_coroutine("on_lava", on_lava, nil, 3)

    setData(data)
    set_text()
    gui.requestRender()
    return
  end
  red:toggle_red(config.wire_lava)
  data.lava = true
  data.fire = false

  is_used_lava = false
  is_used_fire = false

  setData(data)
  set_text()
  gui.requestRender()
end

local function on_released_lava()
  set_text()
  gui.requestRender()
end

local on_press_lava = function(button)
  lava_button.background_color = colors.red
  event_loop:add_coroutine("on_release_lava", on_released_lava, nil, press_delay)
  gui.requestRender()

  if is_used_lava or is_used_water or is_used_fire then
    return
  end
  is_used_lava = true
  event_loop:add_coroutine("on_lava", on_lava, nil, 0.2)
end

-- Water button actions!
local function on_water(state)
  if state then
    is_used_water = false
    set_text()
    gui.requestRender()
    return
  end
  data = getData()
  if data.fire then
    is_used_fire = true
  end
  if data.water == true then
    red:toggle_red(config.wire_water)
    data.water = false

    setData(data)
    set_text()
    gui.requestRender()

    event_loop:add_coroutine("on_water", on_water, { 1 }, 3)
    return
  end
  if data.lava == true then
    is_used_lava = true

    red:toggle_red(config.wire_lava)
    data.lava = false
    event_loop:add_coroutine("on_water", on_water, nil, 8)

    setData(data)
    set_text()
    gui.requestRender()
    return
  end
  red:toggle_red(config.wire_water)
  data.water = true
  data.fire = false

  is_used_water = false
  is_used_lava = false
  is_used_fire = false

  setData(data)
  set_text()
  gui.requestRender()
end

local function on_released_water()
  set_text()
  gui.requestRender()
end

local on_press_water = function(button)
  water_button.background_color = colors.red
  event_loop:add_coroutine("on_release_water", on_released_water, nil, press_delay)
  gui.requestRender()

  if is_used_water or is_used_lava or is_used_fire then
    return
  end
  is_used_water = true
  event_loop:add_coroutine("on_water", on_water, nil, 0.2)
end

-- Disable button actions!

local function on_disable(state)
  if state then
    red:toggle_red(config.wire_water)
    data.water = false
    data.fire = false
  end
  data = getData()
  if data.water == true then
    red:toggle_red(config.wire_water)
    data.water = false
  end
  if data.lava == true then
    red:toggle_red(config.wire_lava)
    data.lava = false
  end
  if data.crusher == true then
    red:sub_red(config.wire_crusher)
    data.crusher = false
  end
  if data.press == true then
    red:sub_red(config.wire_press)
    data.press = false
  end
  if data.fire == true then
    red:toggle_red(config.wire_water)
    data.water = true
    data.fire = false
    event_loop:add_coroutine("on_disable", on_disable, { 1 }, 2)
  end

  is_used_water = false
  is_used_lava = false
  is_used_press = false
  is_used_crusher = false
  is_used_fire = false

  setData(data)
  set_text()
  gui.requestRender()
end

local function on_released_disable()
  set_text()
  gui.requestRender()
end

local on_press_disable = function(button)
  disable_button.background_color = colors.red
  event_loop:add_coroutine("on_release_disable", on_released_disable, nil, press_delay)
  gui.requestRender()
  if is_used_water or is_used_lava or is_used_crusher or is_used_press then
    return
  end
  is_used_lava = true
  is_used_water = true
  is_used_crusher = true
  is_used_press = true
  is_used_fire = true

  event_loop:add_coroutine("on_disable", on_disable, nil, 0.2)
end

-- Crusher button action!

local function on_crusher()
  data = getData()
  if data.crusher == true then
    red:sub_red(config.wire_crusher)
    data.crusher = false
  else
    red:add_red(config.wire_crusher)
    data.crusher = true
  end

  is_used_crusher = false

  setData(data)
  set_text()
  gui.requestRender()
end

local function on_released_crusher()
  set_text()
  gui.requestRender()
end

local on_press_crusher = function(button)
  crusher_button.background_color = colors.red
  event_loop:add_coroutine("on_release_crusher", on_released_crusher, nil, press_delay)

  gui.requestRender()
  if is_used_crusher then
    return
  end
  is_used_crusher = true
  event_loop:add_coroutine("on_crusher", on_crusher, nil, 0.2)
end

--Press button actions!
local function on_press()
  data = getData()
  if data.press == true then
    red:sub_red(config.wire_press)
    data.press = false
  else
    red:add_red(config.wire_press)
    data.press = true
  end

  is_used_press = false

  setData(data)
  set_text()
  gui.requestRender()
end

local on_released_press = function()
  set_text()
  gui.requestRender()
end

local on_press_press = function(button)
  press_button.background_color = colors.red
  event_loop:add_coroutine("on_release_press", on_released_press, nil, press_delay)

  gui.requestRender()
  if is_used_press then
    return
  end

  is_used_press = true
  event_loop:add_coroutine("on_press", on_press, nil, 0.2)
end

--Fire button actions!

local fire_state = 0

local function on_fire(state)
  data = getData()
  if state then
    if state == 1 then
      is_used_water = false

      setData(data)
      set_text()
    end
    if state == 2 then
      is_used_lava = false

      setData(data)
      set_text()
    end
    fire_state = fire_state + state
    if fire_state == 3 then
      red:toggle_red(config.wire_fire)
      data.fire = true
      event_loop:add_coroutine("on_fire", on_fire, { 2 }, 4)

      setData(data)
      set_text()
    end
    if fire_state == 4 then
      red:toggle_red(config.wire_water)
      data.water = false
      event_loop:add_coroutine("on_fire", on_fire, { 5 }, 3)

      setData(data)
      set_text()
    end
    if fire_state == 5 then
      is_used_fire = false
      setData(data)

      set_text()
    end
    if fire_state == 9 then
      data.fire = false
      is_used_water = false
      is_used_fire = false
      setData(data)
      set_text()
    end
    return
  end

  fire_state = 0

  is_used_fire = true
  local lava_time = 0
  local water_time = 0

  if data.fire == true then
    is_used_water = true
    red:toggle_red(config.wire_water)
    data.water = true
    event_loop:add_coroutine("on_fire", on_fire, { 4 }, 2)

    setData(data)
    set_text()
    return
  end

  if data.water == true then
    is_used_water = true
    red:toggle_red(config.wire_water)
    data.water = false
    water_time = 3
  end
  if data.lava == true then
    is_used_lava = true
    red:toggle_red(config.wire_lava)
    data.lava = false
    lava_time = 7
  end

  setData(data)
  set_text()

  event_loop:add_coroutine("on_fire", on_fire, { 1 }, water_time)
  event_loop:add_coroutine("on_fire", on_fire, { 2 }, lava_time)
end

local on_released_fire = function()
  set_text()
  gui.requestRender()
end

local on_fire_press = function(button)
  fire_button.background_color = colors.red
  event_loop:add_coroutine("on_released_fire", on_released_fire, nil, press_delay)

  gui.requestRender()
  if is_used_fire or is_used_water or is_used_water then
    return
  end

  is_used_fire = true
  event_loop:add_coroutine("on_fire", on_fire, nil, 0.2)
end

--Main things!

local on_event_main_panel = function(panel, event)

end

local update = function(loop, event)
  if event.type == "setup_create_smelter" then
    local main_panel = gui.makePanel(true)
    main_panel:add_update_lisener(on_event_main_panel)

    --background
    local background = gui.makeBox(1, 1, 0, 0, colors.gray)
    background.flags = gui.flags.bottom + gui.flags.top + gui.flags.left + gui.flags.right

    --lava button
    lava_button = gui.makeButton(1, 1, "Enable: Lava", on_press_lava)
    lava_button.name = "lava_button"
    lava_button.flags = gui.flags.top + gui.flags.left

    --water button
    water_button = gui.makeButton(1, 1, "Enable: Water", on_press_water)
    water_button.name = "water_button"
    water_button.flags = gui.flags.top + gui.flags.right

    --disable button
    disable_button = gui.makeButton(-1, -1, "Disable All", on_press_disable)
    disable_button.name = "disable_button"
    disable_button.flags = gui.flags.center_horizontal + gui.flags.center_vertical

    --crusher button
    crusher_button = gui.makeButton(1, 1, "Enable: Crusher", on_press_crusher)
    crusher_button.name = "crusher_button"
    crusher_button.flags = gui.flags.bottom + gui.flags.left

    --press button
    press_button = gui.makeButton(1, 1, "Enable: Press", on_press_press)
    press_button.name = "press_button"
    press_button.flags = gui.flags.bottom + gui.flags.right

    --fire button
    fire_button = gui.makeButton(0, 1, "Enable: Fire", on_fire_press)
    fire_button.name = "fire_button"
    fire_button.flags = gui.flags.center_horizontal + gui.flags.top

    --Set text for all buttons and drow first frame

    set_text()

    --main penal add all elements
    main_panel:add_child(background)
    if config.lava_enable then
      main_panel:add_child(lava_button)
    end
    if config.fire_enable then
      main_panel:add_child(fire_button)
    end
    if config.water_enable then
      main_panel:add_child(water_button)
    end
    if config.crusher_enable then
      main_panel:add_child(crusher_button)
    end
    if config.press_enable then
      main_panel:add_child(press_button)
    end
    main_panel:add_child(disable_button)
    --adding main panel to gui

    gui:add_panel(main_panel)
    gui.monitor = config.monitor
    return
  end
  gui:update(event)
end

local function setup(path)
  _data_path = path .. "data"
  _config_path = path .. "config"

  reader.write_file(_data_path, default_data, true)
  reader.write_file(_config_path, default_config, true)

  local config_data = reader.read_file(_config_path)
  config = createConfig(config_data)

  local data = getData()
  red:setOutput(data.red_output)
  red:setSide(config.red_side)

  event_loop:set_callback(update)
  os.queueEvent("setup_create_smelter")
  event_loop:run()
end

local module = {
  to_install = {},
  setup = setup
}

return module
