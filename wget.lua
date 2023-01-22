--[[
    Wget
    by Konkito Man
    
    for: Lua Cobalt [https://github.com/SquidDev/Cobalt], CC-Tweaked, CC-ManOS [https://github.com/konkitoman/CC-ManOS]
    LICENSE: MIT
    Version: 0.0.1
]]

local logger = require("logger")
logger:setModuleName("ManOS")
logger:setName("wget")

if not http then
  logger:log("No http module!")
  return
end

local module = {
  get = function(self, url)
    logger:log("Try Download data: " .. url)
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
  downloadFile = function(self, url, filename_and_path)
    logger:log("Try Download file: " .. filename_and_path .. ", from: " .. url)
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

    local res = self:get(url)
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
  runUrl = function(self, url)
    local res = self:get(url)
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

local args = { ... }
if args[1] then
  if args[1] ~= "wget" then
    logger:setDisplay(true)
    if args[1] == "run" then
      if args[2] then
        module:runUrl(args[2])
      else
        logger:log("no url!")
      end
    else
      if args[2] then
        module:downloadFile(args[1], args[2])
      else
        logger:log("no filename!")
      end
    end
  else
    print(args[1])
  end
end

return module
