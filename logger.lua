local name = ""
local module_name = ""

local module = {
    setName = function(_name) name = _name end,
    setModuleName = function(_name) module_name = _name end,
    log = function (text, no_end_line)
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
            content = content .. "[" .. module_name .. "] " .. name .. " " .. text .. "\n"
        else
            content = content .. "[" .. module_name .. "] " .. name .. " " .. text
        end
        local _file = fs.open("log.txt", "w")
        if not _file then
            print("[TheOS] Logger: Cannot create file!")
        end
        _file.write(content)
    end
}

return module