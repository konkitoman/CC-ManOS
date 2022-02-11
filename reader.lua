--[[
    Reader
    
    for: Lua Cobalt [https://github.com/SquidDev/Cobalt], CC-Tweaked, CC-ManOS [https://github.com/konkitoman/CC-ManOS]
    LICENSE: MIT
    Version: 0.0.2
]]

local logger = require("logger")
logger:setModuleName("TheOS")
logger:setName("Reader")

local row_reader = require("row_reader")

row_reader.log_callback = function (text, no_nl)
    logger:log(text, no_nl)
end

local module = {
    read_file = function (path)
        return row_reader:read_file(path)
    end,

    write_file = function (path, data, if_not_exist)
        return row_reader:write_file(path, data, if_not_exist)
    end,
}

return module