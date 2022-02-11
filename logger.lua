--[[
    Logger
    
    for: Lua Cobalt [https://github.com/SquidDev/Cobalt], CC-Tweaked, CC-ManOS [https://github.com/konkitoman/CC-ManOS]
    LICENSE: MIT
    Version: 0.0.2
]]

local reader = require("row_reader")

local to_display = false
local default_config = {
    display = false
}

reader:write_file("log.config", default_config, true)

local config = reader:read_file("log.config")
local module = {
    name = "LOGGER no name",
    module_name = "no module name",
    display = config.display,
    setName = function(self, name) self.name = name end,
    setModuleName = function(self, name) self.module_name = name end,
    setDisplay = function (self, display)
        self.display = display
        if display == true then
            print("Logger is set to display on screen!")
        end
    end,
    log = function (self, text, no_end_line)
        local content = nil
        if fs.exists("log.txt") then
            local _file = fs.open("log.txt", "r")
            if not _file then
                print("[TheOS] Logger: Cannot open file!")
            end
            content = _file.readAll()
            _file.close()
        end
        if not content then
            content = ""
        end
        if not no_end_line then
            content = content .. "[" .. self.module_name .. "] " .. self.name .. " " .. text .. "\n"
        else
            content = content .. "[" .. self.module_name .. "] " .. self.name .. " " .. text
        end
        local _file = fs.open("log.txt", "w")
        if not _file then
            print("[TheOS] Logger: Cannot create file!")
        end
        _file.write(content)
        if self.display == true then
            term.write(content)
        end
    end
}

return module