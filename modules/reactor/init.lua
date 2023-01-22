print("Reactor loaded")

local function setup()
  require("modules/reactor/setup")
end

return {
  to_install = { { res = "setup.lua", path = "setup.lua" } },
  setup = setup
}
