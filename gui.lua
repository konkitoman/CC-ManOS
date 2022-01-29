local logger = require("logger")
logger.setModuleName("TheOS")
logger.setName("GUI")

local types = {panel = 1, box = 2, button = 3, label = 4}
local flags = {center_horizontal = 1, center_vertical = 2, left = 4, right = 8, top = 16, bottom = 32}

local function lshift_and(num, shift, an)
    return bit.band(bit.blshift(num, shift), an)
end

local function renderBox(box)
    if not box.type == types.box then
        return
    end
    local screenX, screenY = term.getSize()

    if box.size_x > screenX then
        box.size_x = screenX
    end
    if box.size_y > screenY then
        box.size_y = screenY
    end

    if box.flags then
        local center_horizontal = lshift_and(box.flags, 0, 1)
        local center_vertical = lshift_and(box.flags, 1, 1)
        local left = lshift_and(box.flags, 2, 1)
        local right = lshift_and(box.flags, 3, 1)
        local top = lshift_and(box.flags, 4, 1)
        local bottom = lshift_and(box.flags, 5, 1)

        if center_horizontal then
            box.x = (screenX / 2) - box.size_x
        end
        if center_vertical then
            box.y = (screenY / 2) - box.size_y
        end
        if left then
            box.x = 0
        end
        if right then
            box.x = screenX
        end
        if top then
            box.y = 0
        end
        if bottom then
            box.y = screenY
        end
    end
end

local module = {
    types = types,
    is_gui = true,
    elements = {},

    makePanel = function (enabled)
        return {
            type = 1,
            enabled = enabled,
            name = "panel",
            parent = nil,
            childs = {},
            on_update = nil,
            on_render = nil,
            add_child = function (self, child)
                table.insert(self.childs, child)
            end,

            render = function (self)
                if self.on_render then
                    self:on_render()
                end

            end,
            update = function (self, event)
                if self.on_update then
                    self:on_update(event)
                end
            end
        }
    end,

    makeBox = function(x, y, size_x, size_y, background_color)
        return {
            type = 2,
            x = x,
            y = y,
            size_x = size_x,
            size_y = size_y,
            name = "box",
            background_color = background_color,
            border_color = nil
        }
    end,

    makeButton = function(x, y, text, text_color, background_color, on_press)
        return {
            type = 3,
            x = x,
            y = y,
            parent = nil,
            name = "button",
            text = text,
            text_color = text_color,
            background_color = background_color,
            border_color = nil,
            on_press = on_press,
            flags = nil
        }
    end,

    makeLabal = function (x, y, text, text_color, background_color)
        return {
            type = 4,
            x = x,
            y = y,
            name = "label",
            text = text,
            text_color = text_color,
            background_color = background_color,
            flags = nil
        }
    end,

    add_panel = function (self, panel)
        if not self.is_gui then
            logger.log("self is not gui!")
            return
        end
        if not panel.type == 1 then
            logger.log("is not panel!")
            return
        end

        table.insert(self.elements, panel)
    end,

    update = function(self, event)
        if event.type == "render" then
            self:render()
            return
        end

        local length = #self.elements
        for i = 1, length do
            if self.elements.enabled then
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
                self.elements[i]:render()
            end
        end
    end
}

return module