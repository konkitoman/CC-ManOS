local module = {
    callback = nil,
    ended = false,
    tick = nil,
    idle_time = 0.1,
    run = function (self)
        self.tick = os.startTimer(self.idle_time)
        while not self.ended do
            while true do
                local type, o1, o2, o3, o4 = os.pullEvent()
                if type == "timer" then
                    if o1 == self.tick then
                        self.tick = os.startTimer(self.idle_time)
                        type = "update"
                        o1 = nil
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
    end
}

return module