# nodecmu
nodecmu

Utils classes to use digital sensor (like ipsensor) or led

# Using Sensor.lua example :

dofile("Sensor.lua")
--[[instanciate sensor]]--
local mySensor = Sensor:new()
--[[add event callback function]]--
mySensor.onEvent = function(level)
    print("sensor level : " .. level)
	if level == 1 then
		start()    
	else
		stop()
	end
end
--[[set use pin for sensor]]--
mySensor.pin = 2
--[[start listener]]--
mySensor:listen()

# Using Led.lua example :

dofile("Led.lua")
--[[instanciate led with specified pin (5)]]--
local led = Led:new(5)
--[[
add event callback function
type="on" or "off"
]]--
led.onEvent = function(evt)
    print("type = " .. evt.type)
end
--[[swith on the led]]--
led.on()
--[[sitch off the led]]--
led.off()
--[[blink the led with period 200ms during 5000ms]]--
led:blink(200, 5000 , function()
	--[[blink the led with period 50ms during 3000ms]]--
    led:blink(50,3000)
end)
 
