--[[
    Red
    by Konkito Man

    for: Lua Cobalt [https://github.com/SquidDev/Cobalt], CC-Tweaked, CC-ManOS [https://github.com/konkitoman/CC-ManOS]
    LICENSE: MIT
    Version: 0.0.1
]]
local colors = {
  none = 0,
  white = 1,
  orange = 2,
  magenta = 4,
  light_blue = 8,
  yellow = 16,
  lime = 32,
  pink = 64,
  gray = 128,
  light_gray = 256,
  cyan = 512,
  purple = 1024,
  blue = 2048,
  brown = 4096,
  green = 8192,
  red = 16384,
  black = 32768,

  from_str = function(self, str)
    if str == "none" then
      return 0
    elseif str == "white" then
      return self.white
    elseif str == "orange" then
      return self.orange
    elseif str == "magenta" then
      return self.magenta
    elseif str == "light_blue" then
      return self.light_blue
    elseif str == "yellow" then
      return self.yellow
    elseif str == "lime" then
      return self.lime
    elseif str == "pink" then
      return self.pink
    elseif str == "gray" then
      return self.gray
    elseif str == "light_gray" then
      return self.light_gray
    elseif str == "cyan" then
      return self.cyan
    elseif str == "purple" then
      return self.purple
    elseif str == "blue" then
      return self.blue
    elseif str == "brown" then
      return self.brown
    elseif str == "green" then
      return self.green
    elseif str == "red" then
      return self.red
    elseif str == "black" then
      return self.black
    end
    return 0
  end
}
local module = {
  colors = colors,
  red_output = 0,
  side = "left",

  updateRed = function(self)
    redstone.setBundledOutput(self.side, self.red_output)
  end,

  setOutput = function(self, output)
    self.red_output = output
    self:updateRed()
  end,

  setSide = function(self, side)
    self.side = side
    self:updateRed()
  end,

  add_red = function(self, wire)
    self.red_output = self.red_output + wire
    self:updateRed()
  end,

  sub_red = function(self, wire)
    self.red_output = self.red_output - wire
    self:updateRed()
  end,

  toggle_red = function(self, wire)
    self:add_red(wire)
    sleep()
    self:sub_red(wire)
  end
}

return module

