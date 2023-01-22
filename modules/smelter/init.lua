--[[
    Tinkers Smelter
    by Konkito Man

    for: Lua Cobalt [https://github.com/SquidDev/Cobalt], CC-Tweaked, CC-ManOS [https://github.com/konkitoman/CC-ManOS]
    LICENSE: MIT
    Version: 0.0.1
]]

-- defining amounts in mb
local ingot = 144
local block = 1296

local logger = require("logger")
local event_loop = require("event_loop")
local reader = require("reader")
local commander = require("commander")

-- Setup logger
logger:setModuleName("Tinkers Smelter")
logger:setName("Init")

-- peripheral names
local t_tables = {}
local t_basins = {}
-- peripherals
local drain = nil
local casts = nil
local casts_name = nil
local chute = nil


-- Update all peripherals
local function update_peripherals()
  local peripherals = peripheral.getNames()
  for i = 1, #peripherals do
    local device = peripherals[i]
    if string.find(device, "tconstruct:table_") then
      table.insert(t_tables, { name = device, device = peripheral.wrap(device) })
    elseif string.find(device, "tconstruct:basin_") then
      table.insert(t_basins, { name = device, device = peripheral.wrap(device) })
    elseif string.find(device, "tconstruct:drain_") then
      drain = peripheral.wrap(device)
    elseif string.find(device, "tconstruct:modifier_chest_") then
      casts = peripheral.wrap(device)
      casts_name = device
    elseif string.find(device, "tconstruct:chute") then
      chute = peripheral.wrap(device)
    end
  end
end

local defalut_config = {
  input = "metalbarrels:gold_tile_0",
  output = "metalbarrels:gold_tile_1"
}

local config = nil

local function quit()
  event_loop.ended = true
end

local function collect()
  for i = 1, #t_tables do
    local _table = t_tables[i].device
    local items = _table.list()
    for a = 1, #items do
      local item = items[a]
      if string.find(item.name, "cast") then
        _table.pushItems(casts_name, a)
      else
        _table.pushItems(config.output, a)
      end
    end
  end
end

local function update(e_l, event)
  commander:update(event)
end

local function output(index, type, amount)
  if amount == -1 then

  end
  if type == "block" then
    return
  end

  local cast
  local cast_amount

  for i = 1, #casts.list() do
    local element = casts.list()[i]
    if string.find(element.name, type) then
      cast = element.name
      cast_amount = element.count
    end
  end

  if cast then

  else
    print("no cast")
  end
end

-- Commands

local function tank(index_str, type)
  local tanks = drain.tanks()
  local index = tonumber(index_str, 10)

  if index then
    if index <= 0 then print("#1 is smaler that 1") return end
    if index <= #tanks then
      print("name: " .. tanks[index].name)
      if type then
        if type == "ingot" then
          print("ingots: " .. tanks[index].amount / ingot)
        elseif type == "block" then
          print("blocks: " .. tanks[index].amount / block)
        end
        return
      end
      print("amount: " .. tanks[index].amount .. " mb")
    else
      print("#1 is bigger that last tank")
    end
    return
  end
  for i = 1, #tanks do
    print(i .. ": " .. tanks[i].name)
  end
end

local function out(index_str, type, amount)
  local tanks = drain.tanks()
  local index = tonumber(index_str, 10)

  if index then
    if index <= 0 then print("#1 is smaler that 1") return end
    if index <= #tanks then
      if type then
        if type == "ingot" then
          output(index, type, amount)
        elseif type == "block" then
          output(index, type, amount)
        end
        return
      end
    else
      print("#1 is bigger that last tank")
    end
    return
  end
end

local function setup(path)
  reader.write_file(path .. "config")
  config = reader.read_file(path .. "config")

  commander:add_command("quit", quit, true)

  commander:add_command("update", update_peripherals, false)
  commander:add_command("tank", tank, false)
  commander:add_command("out", out, false)
  commander:add_command("collect", collect, false)


  commander:setup()
  update_peripherals()
  event_loop:set_callback(update)
  event_loop:run()
end

local module = {
  to_install = {},
  setup = setup
}

return module
