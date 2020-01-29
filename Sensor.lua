Sensor = {} -- the table representing the class, which will double as the metatable for the instances

function Sensor:new ()
   local o = {}
   o.onEvent = nil
   o.pin = nil
   o.debug = false
   o.level = 0
   setmetatable(o, self)
   self.__index = self
   return o
end

function Sensor:log(str,obj)
    if self.debug == true then
        print(str,obj)
    end
end

function Sensor:listen()

    self:log("Sensor listen")
    
    local _self = self
    self:log("Sensor level init : " .. _self.level)
    
    function trigEventCallback(level)
        if level ~= _self.level then
            self:log("Sensor level new :" .. level)
            _self.level = level
            if _self.onEvent ~= nil then
                _self.onEvent(level)
            end
        end
    end

    
    if self.pin ~= nil then
        gpio.mode(self.pin, gpio.INT, gpio.PULLUP)
        gpio.trig(self.pin , "both", trigEventCallback)
    end
end
