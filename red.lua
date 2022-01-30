local module = {
    none = 0,
    white = 1,
    orange = 2,
    magenta = 4,
    light_blue = 8,
    yellow = 16,
    lime = 32,
    pink = 64,
    gray = 128,
    light_gray = 256,
    cyan = 512,
    purple = 1024,
    blue = 2048,
    brown = 4096,
    green = 8192,
    red = 16384,
    black = 32768,
    from_str = function (self, str)
        if str == "none" then
            return 0
        elseif str == "white" then
            return self.white
        elseif str == "orange" then
            return self.orange
        elseif str == "magenta" then
            return self.magenta
        elseif str == "light_blue" then
            return self.light_blue
        elseif str == "yellow" then
            return self.yellow
        elseif str == "lime" then
            return self.lime
        elseif str == "pink" then
            return self.pink
        elseif str == "gray" then
            return self.gray
        elseif str == "light_gray" then
            return self.light_gray
        elseif str == "cyan" then
            return self.cyan
        elseif str == "purple" then
            return self.purple
        elseif str == "blue" then
            return self.blue
        elseif str == "brown" then
            return self.brown
        elseif str == "green" then
            return self.green
        elseif str == "red" then
            return self.red
        elseif str == "black" then
            return self.black
        end
        return 0
    end
}

return module