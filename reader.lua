local module = {
    read_file = function (path)
        if not fs.exists(path) then
            --Todo: logger: path don't exist!
            return
        end

        local file = fs.open(path, "r")

        if not file then
            --Todo: logger: cannot open file!
            return
        end

        local content = file.readAll()
        file.close()

        if not content then
            --Todo: logger: the file is empty!
            return
        end

        local _table = table.unpack(content)

        if not _table then
            --Todo: logger: cannot un pack!
            return
        end

        return _table
    end,

    write_file = function (path, data, only_if_not_exists)
        if not path then
            --Todo: logger: file is null!
            return
        end

        if not data then
            --Todo: logger: data is null!
            return
        end

        if fs.exists(path) and only_if_not_exists then
            return
        end

        local _str = table.pack(data)

        local file = fs.open(path, "w")

        if not file then
            --Todo: logger: cannot open file
            return
        end

        file.write(_str)
        file.close()
        return true
    end,
}

return module