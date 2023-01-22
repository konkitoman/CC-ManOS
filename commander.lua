--[[
    Commander
    by Konkito Man

    for: Lua Cobalt [https://github.com/SquidDev/Cobalt], CC-Tweaked, CC-ManOS [https://github.com/konkitoman/CC-ManOS]
    LICENSE: MIT
    Version: 0.0.1
]]

local logger = require("logger")
logger:setModuleName("TheOS")
logger:setName("Commander")

local module = {
  commands = {},
  command = "",

  add_command = function(self, command_name, callback, capture_coursur)
    local command = {
      name = command_name,
      callback = callback,
      capture_coursur = capture_coursur,
      args_complition = { {} }
    }
    table.insert(self.commands, command)
  end,
  command_args = function(self, command_name, depth, complition, last_arg)
    for i = 1, #self.commands do
      local command = self.commands[i]
      if command.name == command_name then
        local command_complition = {
          complition = complition,
          for_last_arg = arg
        }
        table.insert(command.args_complition[depth], command_complition)
        return 0
      end
    end
    logger:log("Cannot add args to command '" .. command_name .. "' Because it dosen't exist!")
    return 1
  end,
  command_remove = function(self, command_name)
    local index = nil
    local finded = false

    for i = 1, #self.commands do
      if self.commands[i] == command_name then
        index = i
        finded = true
      end
    end

    if finded == true then
      table.remove(self.commands, index)
    end
  end,

  calculate_complition = function(self)
    local separated = {}

    for w in string.gmatch(self.command, "%S+") do
      table.insert(separated, w)
    end

    local x, y = term.getCursorPos()

    local finded = false

    for i = 1, #self.commands do
      local com = self.commands[i]
      if com.name == separated[1] then
        if #separated < 2 then break end
        for b = 1, #com.args_complition[#separated - 1] do
          finded = true
          term.setTextColor(colors.gray)
          term.setCursorPos(x + 1, y)
          write(string.sub(com.args_complition[#separated - 1][b].complition, (#self.command - #com.name + 1),
            #com.args_complition[1][1].complition))
          write("            ")
          term.setCursorPos(x, y)
          term.setTextColor(colors.white)
          break
        end
      end
    end

    if finded == false then
      for i = 1, #self.commands do
        local com = self.commands[i]
        term.setTextColor(colors.gray)
        write(string.sub(com.name, #self.command + 1, #com.name))
        write("             ")
        term.setCursorPos(x, y)
        term.setTextColor(colors.white)
      end
    end
  end,

  execute = function(self)
    write("\n")
    local separated = {}

    for w in string.gmatch(self.command, "%S+") do
      table.insert(separated, w)
    end

    local finded = false

    for i = 1, #self.commands do
      local com = self.commands[i]
      if com.name == separated[1] then
        table.remove(separated, 1)
        com.callback(unpack(separated))
        finded = true
        if com.capture_coursur == false then
          write(">")
        end
      end
    end

    if finded == false then
      write("Command not found!\n")
      write(">")
    end
    self.command = ""
  end,

  update = function(self, event)
    if event.type == "char" then
      self.command = self.command .. event.args[1]
      event.consumed = true
      write(event.args[1])
      --self:calculate_complition()
    elseif event.type == "key" then
      if event.args[1] == 259 then
        self.command = string.sub(self.command, 1, #self.command - 1)
        event.consumed = true
        local x, y = term.getCursorPos()
        x = x - 1
        if x > 1 then
          term.setCursorPos(x, y)
          write(" ")
          term.setCursorPos(x, y)
        end
        --self:calculate_complition()
      elseif event.args[1] == 257 then
        self:execute()
      end
    end
  end,

  setup = function(self)
    write(">")
  end
}

return module

