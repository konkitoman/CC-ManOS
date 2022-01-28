local red = require("red")

local function setToggle(side, wire)
    redstone.setBundledOutput(side, wire)
    sleep(1)
    redstone.setBundledOutput(side, red.none)
end

local version = "0.0.1"

local module = {
    run = function (obj)
        print("Create_s_r: Commander: Version: " .. version)
        local ended = false
        while not ended do
            while true do
                local data = obj.getData()
                local input = read()
                local args = {}

                for i in string.gmatch(input, "%S+") do
                    table.insert(args, i)
                end

                if not #args then
                    break
                end

                if args[1] == "quit" then
                    ended = true
                    break
                elseif args[1] == "status" then
                    print("water: " .. tostring(data.water))
                    print("lava: " .. tostring(data.lava))
                elseif args[1] == "water" then
                    if data.water then
                        break
                    end
                    if data.lava then
                        setToggle(obj.config.wire_lava.side, obj.config.wire_lava.r)
                        data.lava = false
                        sleep(6)
                    end
                    setToggle(obj.config.wire_water.side, obj.config.wire_water.r)
                    data.water = true
                    print("Enabled water!")
                elseif args[1] == "lava" then
                    if data.lava then
                        break
                    end
                    if data.water then
                        setToggle(obj.config.wire_water.side, obj.config.wire_water.r)
                        data.water = false
                        sleep(4)
                    end
                    setToggle(obj.config.wire_lava.side, obj.config.wire_lava.r)
                    data.lava = true
                    print("Enabled lava!")
                elseif args[1] == "disable" then
                    if data.lava then
                        setToggle(obj.config.wire_lava.side, obj.config.wire_lava.r)
                        data.lava = false
                    end
                    if data.water then
                        setToggle(obj.config.wire_water.side, obj.config.wire_water.r)
                        data.water = false
                    end
                    print("Disabled all!")
                elseif args[1] == "help" then
                    print("status")
                    print("lava")
                    print("water")
                    print("disable")
                    print("quit")
                end

                obj.setData(data)
                break
            end
        end
    end
}

return module