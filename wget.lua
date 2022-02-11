local logger = require("logger")
logger:setName("ManOS")
logger:setModuleName("wget")

if not http then
    logger:log("No http module!")
    return
end

wget = {
    get = function(url)
        local ok, err = http.checkURL(url)
        if not ok then
            logger:log(ok or "Invalid url!")
            return
        end

        local response = http.get(url)
        if not response then
            logger:log("Server don't have that file!")
            return
        end
        local data = response.readAll()
        response.close()
        return data
    end,
    downloadFile = function(url, filename_and_path)
        local err = nil
        if not url then
            err = "No url!\n"
        end

        if not filename_and_path then
            err = err + "No filename\n"
        end

        if err then
            logger:log(err)
            return
        end

        local res = wget.get(url)
        if not res then return end
        local file = fs.open(filename_and_path, "wb")
        if not file then
            logger:log("Cannot create file!")
            return
        end

        file.write(res)
        file.close()
        return filename_and_path
    end,
    runUrl = function(url)
        local res = wget.get(url)
        if not res then
            return
        end
        local func = load(res, "__tmp__script__.lua")
        if not func then
            logger:log("Cannot create function!")
            return
        end
        local ok, err = pcall(func, nil)
        if not ok then
            logger:log("Cannot run!")
        end
    end
}