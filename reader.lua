local logger = require("logger")
logger.setModuleName("TheOS")
logger.setName("Reader")

local module = {
    read_file = function (path)
        if not fs.exists(path) then
            logger.log("Path don't exist!")
            return
        end

        local file = fs.open(path, "r")

        if not file then
            logger.log("cannot open file! " .. path)
            return
        end

        local content = file.readAll()
        file.close()

        if not content then
            logger.log("this file is invalid! " .. path)
            return
        end

        local _table = table.unpack(content)

        if not _table then
            logger.log("cannot unpack! " .. path)
            return
        end

        return _table
    end,

    write_file = function (path, data, only_if_not_exists)
        if not path then
            logger.log("path is null!")
            return
        end

        if not data then
            logger.log("data is null")
            return
        end

        if fs.exists(path) and only_if_not_exists then
            return
        end

        local _str = table.pack(data)

        local file = fs.open(path, "w")

        if not file then
            logger.log("cannot open file! " .. path)
            return
        end

        file.write(_str)
        file.close()
        return true
    end,
}

return module