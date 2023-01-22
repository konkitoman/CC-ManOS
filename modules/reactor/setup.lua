local event_loop = require("event_loop")
local logger     = require("logger")
local gui        = require("gui")

logger:setModuleName("Reactor")
logger:setName("setup")

local function get_devices()
  for _, device in pairs(peripheral.getNames()) do
    print(device)
  end
end

event_loop:add_coroutine("get_devices", get_devices, {}, 0)

local function main_window_callback()
  print("Main Window Callback")
end

local main_window = gui.makePanel(true)

local background = gui.makeBox(0, 0, 0, 0, colors.red)
background.flags = gui.flags.bottom + gui.flags.top + gui.flags.left + gui.flags.right
main_window:add_child(background)
main_window:add_update_lisener()
gui.monitor = peripheral.wrap("right")

gui:add_panel(main_window)
gui:requestRender()

local function update_gui()
end

---@param event Event
local function on_event(loop, event)
  local string = "Event: " .. event.type
  string = string .. " Args: "
  for _, arg in pairs(event.args) do
    string = string .. arg .. ", "
  end
  logger:log(string)
  gui:update(event)
end

event_loop:set_callback(on_event)
event_loop:run()
