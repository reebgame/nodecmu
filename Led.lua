Led = {} -- the table representing the class, which will double as the metatable for the instances

function Led:new(pin, label)

   local o = {}
   o.onEvent = nil
   o.pin = pin
   o.debug = false
   o.label = ""
   if label ~= nil then
    o.label = label
   end
   o.blinkTimer = nil
   o.timeTimer = nil
   o.isOn = false
   gpio.mode(o.pin,gpio.OUTPUT)
   setmetatable(o, self)
   self.__index = self
   return o
end

function Led:log(str,obj)
    if self.debug == true then
        print(str,obj)
    end
end

function Led:on()
    self:stopBlinkTimer()
    self:_on()
end
function Led:_on(time, endCallback)
    self:log("Led on : " .. self.label)
    
    if self.pin ~= nil then
        if self.isOn == true then
            self:_off()
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
                self:_off()
                if endCallback ~= nil then
                    endCallback()
                end
            end)
            self.timeTimer:start()      
        end
    end
end

function Led:off()
    self:stopBlinkTimer()
    self:_off()
end
function Led:_off()
    self:log("Led _off : " .. self.label) 
    
    
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

function Led:stopBlinkTimer()
    self:log("Led stopBlinkTimer")
    
    if self.blinkTimer ~= nil then
        self.blinkTimer:unregister()
        self.blinkTimer = nil
    end
    if self.timeTimer ~= nil then
        self.timeTimer:unregister()
        self.timeTimer = nil
    end   
end

function Led:blink(delay, time, endCallback)
    self:log("Led blink : " .. self.label);
    if self.blinkTimer ~= nil then
        self.blinkTimer:unregister()
        self.blinkTimer = nil
    end
    --self:off()
    self:log("Led create blinkTimer")
    self.blinkTimer = tmr.create()
    self.blinkTimer:register(delay, tmr.ALARM_AUTO , 
        function()
            self:log("Led timer blink")
            if self.isOn == true then
                self:_off()
            else
                self:_on()
            end
        end
    )
    self:log("Led start blink timer")
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
