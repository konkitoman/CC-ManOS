# Create Smelter (WIP)

## to install to computer:

``` bash
edit init
```

### end add:

``` lua
local module = {
    name = "create_smelter"
}

return module 
```

## require

monitor, boundled cable

## config

wire colors = white, orange, magenta, light_blue, yellow, lime, pink, gray, light_gray, cyan, purple, blue, brown, green, red, black

`edit /states/create_smelter/config`

``` lua
monitor = right, left, top, bottom

wire_lava = wire colors
wire_fire = wire colors
wire_water = wire colors
wire_crusher = wire colors
wire_press = wire_colors
side = right, left, top, bottom (bundled cable side)

(WIP)

lava_enable = true, false
fire_enable = true, false
water_enable = true, false
crusher_enable = true, false
press_enable = true, false

```