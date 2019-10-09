Sensor = {} -- the table representing the class, which will double as the metatable for the instances

function Sensor:new (pin)
   o = o or {}
   o.onEvent = nil
   o.pin = pin
   o.level = 0
   setmetatable(o, self)
   self.__index = self
   return o
end


function Sensor:listen()
    
    local _self = self
    
    function trigEventCallback(level)
        if level ~= _self.level then
            _self.level = level
            if _self.onEvent ~= nil then
                _self.onEvent(level)
            end
        end
    end

    
    if self.pin ~= nil then
        gpio.mode(self.pin, gpio.INT)
        gpio.trig(self.pin , "both", trigEventCallback)
    end
end
