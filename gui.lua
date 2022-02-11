--[[
    Gui
    by Konkito Man

    for: Lua Cobalt [https://github.com/SquidDev/Cobalt], CC-Tweaked, CC-ManOS [https://github.com/konkitoman/CC-ManOS]
    LICENSE: MIT
    Version: 0.0.1
]]

local logger = require("logger")
logger:setModuleName("TheOS")
logger:setName("GUI")
logger:setDisplay(false)

local types = {panel = 1, box = 2, button = 3, label = 4}
local flags = {center_horizontal = 1, center_vertical = 2, left = 4, right = 8, top = 16, bottom = 32}

local function rshift_and(num, shift, an)
    return bit.band(bit.brshift(num, shift), an)
end

local function renderBox(box, screen)
    local screenX, screenY = screen.getSize()

    if box.size_x > screenX then
        box.size_x = screenX
    end
    if box.size_y > screenY then
        box.size_y = screenY
    end

    box._x = box.x
    box._y = box.y
    box._size_x = box.size_x
    box._size_y = box.size_y

    if box.flags then
        local center_horizontal = rshift_and(box.flags, 0, 1)
        local center_vertical = rshift_and(box.flags, 1, 1)
        local left = rshift_and(box.flags, 2, 1)
        local right = rshift_and(box.flags, 3, 1)
        local top = rshift_and(box.flags, 4, 1)
        local bottom = rshift_and(box.flags, 5, 1)

        if center_horizontal == 1 then
            box._x = (((screenX / 2) + 2) - box.size_x / 2) + box.x
        end
        if center_vertical == 1 then
            box._y = (((screenY / 2) + 2) - box.size_y / 2) + box.y
        end
        if left == 1 then
            box._x = box.x
        end
        if right == 1 then
            if left == 1 then
                box._size_x = screenX
            else
                box._x = screenX - box.size_x + box.x
            end
        end
        if top == 1 then
            box._y = box.y
        end
        if bottom == 1 then
            if top == 1 then
                box._size_y = screenY
            else
                box._y = screenY - box.size_y + box.y
            end
        end
    end

    if not box.background_color then
        box.background_color = colors.black
    end

    if box.border_color then
        for x = box._x, box._x + box._size_x - 1 do
            for y = box._y, box._y + box._size_y - 1 do
                screen.setCursorPos(x, y)
                screen.setBackgroundColor(box.border_color)
                screen.write(" ")
            end
        end

        for x = box._x+1, box._x + box._size_x - 2 do
            for y = box._y+1, box._y + box._size_y - 2 do
                screen.setCursorPos(x, y)
                screen.setBackgroundColor(box.background_color)
                screen.write(" ")
            end
        end
    else
        for x = box._x, box._x + box._size_x - 1 do
            for y = box._y, box._y + box._size_y - 1 do
                screen.setCursorPos(x, y)
                screen.setBackgroundColor(box.background_color)
                screen.write(" ")
            end
        end
    end
end

local function renderButton(button, screen)
    local box = {
        x = button.x,
        y = button.y,
        size_x =  button.size_x,
        size_y = button.size_y,
        background_color = button.background_color,
        border_color = button.border_color,
        flags = button.flags
    }
    renderBox(box, screen)
    button._x = box._x
    button._y = box._y
    button._size_x = box._size_x
    button._size_y = box._size_y


    local screenX, screenY = screen.getSize()
    local text_length = #button.text
    local size = (button._size_x + button._x) / 2
    local to_ocupate = size - text_length
    local Xto_ocupate = to_ocupate
    local Yto_ocupate = (button._size_y + button._y) - 2
    local count = 0
    for x = button._x, button._x + Xto_ocupate + button._size_x - Xto_ocupate do
        screen.setCursorPos(x, Yto_ocupate)
        screen.setBackgroundColor(button.background_color)
        screen.setTextColor(button.text_color)
        screen.write(string.sub(button.text, count, count))
        if x > ((button._size_x + button._x) / 2) - text_length + 2 then
            count = count + 1
        end
    end
end

local function renderLabel(label, screen)
    local screenX, screenY = screen.getSize()

    label._x = label.x
    label._y = label.y
    label._size_x = label.size_x
    label._size_y = label.size_y

    if label.flags then
        local center_horizontal = rshift_and(label.flags, 0, 1)
        local center_vertical = rshift_and(label.flags, 1, 1)
        local left = rshift_and(label.flags, 2, 1)
        local right = rshift_and(label.flags, 3, 1)
        local top = rshift_and(label.flags, 4, 1)
        local bottom = rshift_and(label.flags, 5, 1)

        if center_horizontal == 1 then
            label._x = (((screenX / 2) + 2) - label.size_x / 2) + label.x
        end
        if center_vertical == 1 then
            label._y = (((screenY / 2) + 2) - label.size_y / 2) + label.y
        end
        if left == 1 then
            label._x = label.x
        end
        if right == 1 then
            if left == 1 then
                label._size_x = screenX
            else
                label._x = screenX - label.size_x + label.x
            end
        end
        if top == 1 then
            label._y = label.y
        end
        if bottom == 1 then
            if top == 1 then
                label._size_y = screenY / 2
            else
                label._y = screenY - label.size_y + label.y
            end
        end
    end

    local count = 1
    local y = (label._size_y + label._y) - 1

    for x = label._x, label._x + label._size_x do
        if x > ((label._size_x + label._x) / 2) - #label.text + 2 then
            screen.setCursorPos(x, y)
            screen.setBackgroundColor(label.background_color)
            screen.setTextColor(label.text_color)
            screen.write(string.sub(label.text, count, count))
            count = count + 1
        end
    end
end

local module = {
    types = types,
    flags = flags,
    is_gui = true,
    elements = {},
    monitor = term,

    makePanel = function (enabled)
        return {
            type = 1,
            enabled = enabled,
            name = "panel",
            parent = nil,
            childs = {},
            on_update = nil,
            on_render = nil,
            add_update_lisener = function (self, callback)
                self.on_update = callback
            end,
            add_render_lisener = function (self, callback)
                self.on_render = callback
            end,
            add_child = function (self, child)
                table.insert(self.childs, child)
            end,

            render = function (self, screen)
                if self.on_render then
                    self:on_render()
                end
                for i = 1, #self.childs do
                    if self.childs[i].type == 1 and not self.childs[i].enabled then
                        return
                    end
                    self.childs[i].parent = self
                    self.childs[i]:render(screen)
                end
            end,
            update = function (self, event)
                if self.on_update then
                    self:on_update(event)
                end
                for i = 1, #self.childs do
                    if self.childs[i].type == 1 and not self.childs[i].enabled then
                        return
                    end
                    self.childs[i].parent = self
                    self.childs[i]:update(event)
                end
            end
        }
    end,

    makeBox = function(x, y, size_x, size_y, background_color)
        return {
            type = 2,
            _x = nil,
            _y = nil,
            x = x,
            y = y,
            _size_x = nil,
            _size_y = nil,
            size_x = size_x,
            size_y = size_y,
            name = "box",
            parent = nil,
            background_color = background_color,
            border_color = nil,
            render = function (self, screen)
                renderBox(self, screen)
            end,
            update = function (self, event)
                
            end
        }
    end,

    makeButton = function(x, y, text, on_press)
        local size_x = #text + 2
        local size_y = 3

        return {
            type = 3,
            _x = nil,
            _y = nil,
            x = x,
            y = y,
            _size_x = nil,
            _size_y = nil,
            size_x = size_x,
            size_y = size_y,
            parent = nil,
            name = "button",
            text = text,
            text_color = colors.white,
            background_color = colors.green,
            border_color = nil,
            flags = nil,

            on_press = on_press,
            on_update = nil,
            render = function (self, screen)
                renderButton(self, screen)
            end,
            update = function (self, event)
                if self.on_update then
                    self:on_update(event)
                end
                if event.consumed == false then
                    if event.type == "monitor_touch" then
                        local _x = event.args[2]
                        local _y = event.args[3]
                        if _x >= self._x -1 and _x <= self._x + self._size_x - 1 and _y >= self._y - 1 and _y <= self._y + self._size_y - 1 then
                            self:on_press()
                            event.consumed = true
                        end
                    end
                end
            end,
            setText = function(self, text)
                local length = #text + 2
                self.text = text
                self.size_x = length
            end
        }
    end,

    makeLabel = function (x, y, text)
        local size_x = #text
        return {
            type = 4,
            _x = nil,
            _y = nil,
            x = x,
            y = y,
            _size_x = nil,
            _size_y = nil,
            size_x = size_x,
            size_y = 1,
            parent = nil,
            name = "label",
            text = text,
            text_color = colors.white,
            background_color = colors.black,
            flags = nil,
            render = function(self, screen)
                renderLabel(self, screen)
            end,
            update = function (self, event)
                
            end
        }
    end,

    add_panel = function (self, panel)
        if not self.is_gui then
            logger:log("self is not gui!")
            return
        end
        if not panel.type == 1 then
            logger:log("is not panel!")
            return
        end

        table.insert(self.elements, panel)
    end,

    update = function(self, event)
        if event.type == "render" then
            self:render()
            return
        end

        for i = 1, #self.elements do
            if self.elements[i].enabled then
                self.elements[i].parent = self
                self.elements[i]:update(event)
            end
        end
    end,

    render = function(self)
        local length = #self.elements
        for i = 1, length do
            if self.elements[i].enabled then
                self.elements[i].parent = self
                self.elements[i]:render(self.monitor)
            end
        end
    end,

    requestRender = function()
        os.queueEvent("render")
    end
}

return module