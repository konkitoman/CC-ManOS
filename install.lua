if not http then
    print("No http module!")
    return
end

local _url = "https://raw.githubusercontent.com/konkitoman/ManOS/master/"
--local _url = "http://localhost:8000/"

local toInstall = {
    {path = "red.lua", url = _url .. "red.lua"},
    {path = "wget.lua", url = _url .. "wget.lua"},
    {path = "reader.lua", url = _url .. "reader.lua"},
    {path = "logger.lua", url = _url .. "logger.lua"},
    {path = "event_loop.lua", url = _url .. "event_loop.lua"},
    {path = "gui.lua", url = _url .. "gui.lua"},
    {path = "startup", url = _url .. "startup"},
}

local wget = {
    get = function(url)
        local ok, err = http.checkURL(url)
        if not ok then
            print(err or "The file server cannot get file!")
            return
        end

        local response = http.get(url, nil, true)
        if not response then
            print("Failed to get data!")
            return
        end
        local sResponse = response.readAll()
        response.close()
        return sResponse
    end,
}

local installFile = function(path, url)
    if fs.exists(path) then
        fs.delete(path)
    end
    local res = wget.get(url)

    if not res then
        print("Cannot get data from url!")
        return
    end

    local file = fs.open(path, "wb")
    if not file then
        print("Cannot create file!")
        return
    end

    file.write(res)
    file.close()
    print("Downloaded: " .. path .. "!")
end

local installing = function()
    local length = #toInstall
    for i = 1,length do
        installFile(toInstall[i].path, toInstall[i].url)
        print("[" .. string.format("%.2f%%", ((i / length) * 100)) .. "] " .. "Finished " .. toInstall[i].path)
        sleep(0)
    end
end

print("Updating!")
installing()