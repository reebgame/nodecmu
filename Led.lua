Led = {} -- the table representing the class, which will double as the metatable for the instances

function Led:new(pin)

   o = o or {}
   o.onEvent = nil
   o.pin = pin
   o.blinkTimer = nil
   o.timeTimer = nil
   o.isOn = false
   setmetatable(o, self)
   self.__index = self
   gpio.mode(o.pin,gpio.OUTPUT)
   return o
end

function Led:on(time, endCallback)
    if self.pin ~= nil then
        if self.isOn == true then
			self:off()
		end
		gpio.write(self.pin,gpio.HIGH)
        self.isOn = true
        if self.onEvent ~= nil then
            evt = {}
            evt.type = "on"
            self.onEvent(evt)
        end
		if time ~= nil then
			self.timeTimer = tmr.create()
			self.timeTimer:register(time, tmr.ALARM_SINGLE,
            function()
                self.timeTimer = nil
                self:off()
                if endCallback ~= nil then
                    endCallback()
                end
            end)
			self.timeTimer:start()		
		end
    end
end

function Led:off()    
    if self.pin ~= nil then
        gpio.write(self.pin,gpio.LOW)
        self.isOn = false
        if self.onEvent ~= nil then
            evt = {}
            evt.type = "off"
            self.onEvent(evt)
        end
    end
end

function Led:blink(delay, time, endCallback)

    if self.blinkTimer ~= nil then
        self.blinkTimer:unregister()
        self.blinkTimer = nil
    end
       
    self:off()
    
    self.blinkTimer = tmr.create()
    self.blinkTimer:register(delay, tmr.ALARM_AUTO , 
        function()
            if self.isOn == true then
                self:off()
            else
                self:on()
            end
        end
    )
    self.blinkTimer:start()

    if time ~= nil then
        self.timeTimer = tmr.create()
        self.timeTimer:register(time, tmr.ALARM_SINGLE,
            function()
                self.blinkTimer:unregister()
                self.blinkTimer = nil
                self.timeTimer = nil
                if endCallback ~= nil then
                    endCallback()
                end
            end
        )
        self.timeTimer:start()
    end


end
