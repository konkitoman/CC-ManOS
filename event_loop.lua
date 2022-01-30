local module = {
    callback = nil,
    ended = false,
    tick = nil,
    idle_time = 0.1,
    coroutines = {},
    run = function (self)
        self.tick = os.startTimer(self.idle_time)
        while not self.ended do
            while true do
                local type, o1, o2, o3, o4, o5, o6, o7, o8, o9 = os.pullEvent()
                if type == "timer" then
                    if o1 == self.tick then
                        self.tick = os.startTimer(self.idle_time)
                        type = "update"
                        o1 = nil
                    else
                        for i = 1, #self.coroutines do
                            local coroutine = self.coroutines[i]
                            local to_remove = false
                            local index = 0
                                if coroutine then
                                if coroutine.timer == o1 then
                                    index = i
                                    to_remove = true
                                    if coroutine.callback then
                                        if coroutine.args then
                                            coroutine.callback(unpack(coroutine.args))
                                        else
                                            coroutine.callback()
                                        end
                                        else
                                        type = "coroutine"
                                        o1 = coroutine
                                    end
                                end
                                if to_remove then
                                    table.remove(self.coroutines, index)
                                end
                            end
                        end
                    end
                end
                local args = {}
                if o1 then
                    table.insert(args, o1)
                end
                if o2 then
                    table.insert(args, o2)
                end
                if o3 then
                    table.insert(args, o3)
                end
                if o4 then
                    table.insert(args, o4)
                end
                if o5 then
                    table.insert(args, o5)
                end
                if o6 then
                    table.insert(args, o6)
                end
                if o7 then
                    table.insert(args, o7)
                end
                if o8 then
                    table.insert(args, o8)
                end
                if o9 then
                    table.insert(args, o9)
                end
                local event = {
                    type = type,
                    args = args
                }
                self.callback(self, event)
                break
            end
        end
    end,
    set_callback = function(self, callback)
        self.callback = callback
    end,
    add_coroutine = function (self, name, callback, args, time)
        if not time then
            time = 0
        end
        local timer = os.startTimer(time)
        table.insert(self.coroutines, {timer = timer, name = name, callback = callback, args = args})
    end
}

return module