--[[
    Row Reader
    
    for: Lua Cobalt [https://github.com/SquidDev/Cobalt], CC-Tweaked, CC-ManOS [https://github.com/konkitoman/CC-ManOS]
    LICENSE: MIT
    Version: 0.0.2
]]

local module = {
  log_callback = nil,
  log = function(self, text, no_nl)
    if self.log_callback then
      self.log_callback(text, no_nl)
    end
  end,

  read_file = function(self, path)
    if not fs.exists(path) then
      self:log("Path don't exist!")
      return
    end

    local file = fs.open(path, "r")

    if not file then
      self:log("cannot open file! " .. path)
      return
    end

    local content = file.readAll()
    file.close()

    if not content then
      self:log("this file is invalid! " .. path)
      return
    end

    local _table = textutils.unserialise(content)

    if not _table then
      self:log("cannot unpack! " .. path)
      return
    end

    return _table
  end,

  write_file = function(self, path, data, only_if_not_exists)
    if not path then
      self:log("path is null!")
      return
    end

    if not data then
      self:log("data is null")
      return
    end

    if fs.exists(path) and only_if_not_exists then
      return
    end

    local _str = textutils.serialise(data)

    local file = fs.open(path, "w")

    if not file then
      self:log("cannot open file! " .. path)
      return
    end

    file.write(_str)
    file.close()
    return true
  end,
}

return module

