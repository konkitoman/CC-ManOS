--[[
    Setup

    for: Lua Cobalt [https://github.com/SquidDev/Cobalt], CC-Tweaked, CC-ManOS [https://github.com/konkitoman/CC-ManOS]
    LICENSE: MIT
    Version: 0.0.2
]]

local wget = require("wget")

--local _url = "https://raw.githubusercontent.com/konkitoman/CC-ManOS/master/"
local _url = "http://w.konkito.com:8000/"

term.setCursorBlink(false)
term.clear()
term.setCursorPos(1, 1)
term.write("Starting up")
term.write(".")
term.write(".")
term.write(".")
term.setCursorPos(1, 2)
wget:runUrl(_url .. "install.lua")
term.clear()
term.setCursorPos(1, 1)
term.write("Welcome to ManOS")
term.setCursorPos(1, 2)
term.setCursorBlink(true)

local is_exist_lua = function(file)
  local have = fs.exists(file)
  if not have then
    have = fs.exists(file .. ".lua")
  end

  return have
end

--Modules setup
local have_init = is_exist_lua("/init")

if not have_init then
  print("Booted normaly!")
  return
end

local init = require("init")

local validate_to_install = function(to_install)
  local length = #to_install

  for i = 1, length do
    local element = to_install[i]
    if not element then
      print("[TheOS] ToInstall: is not array!")
    end
    if not element.path then
      print("[TheOS] ToInstall: no name!")
      return
    end
    if not element.res then
      print("[TheOS] ToInstall: no res!")
      return
    end

  end
  return 1
end

local run_module = nil

if init.name then
  if not fs.exists("/modules") then
    fs.makeDir("/modules")
  end

  if not fs.exists("/modules/" .. init.name) then
    fs.makeDir("/modules/" .. init.name)
  end

  local url = _url .. "modules/" .. init.name
  local path = "/modules/" .. init.name .. "/init"

  if not wget:downloadFile(url .. "/init", path) then
    if not wget:downloadFile(url .. "/init.lua", path) then
      print("[TheOS] Module Invalid name!")
      return
    end
  end
  run_module = true
end

if init.to_install then
  if validate_to_install(init.to_install) then
    local length = #init.to_install
    for i = 1, length do
      local element = init.to_install[i]
      if not wget:downloadFile(_url .. element.res, element.path) then
        print("[TheOS] Failed to install: " .. element.path)
      end
    end
  end
end

if init.setup then
  init.setup()
end

if run_module then
  local have_state_init = is_exist_lua("/modules/" .. init.name .. "/init")
  if not have_state_init then
    return
  end
  local state_init = require("/modules/" .. init.name .. "/init")

  local path = "modules/" .. init.name .. "/"

  if state_init.to_install then
    if validate_to_install(state_init.to_install) then
      local length = #state_init.to_install
      for i = 1, length do
        local element = state_init.to_install[i]
        if not wget:downloadFile(_url .. "modules/" .. init.name .. "/" .. element.res, path .. element.path) then
          print("[TheOS] Module Failed to install: " .. element.path)
        end
      end
    end
  end

  if state_init.setup then
    state_init.setup(path)
  end
end
