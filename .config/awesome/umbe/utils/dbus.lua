require('awful.dbus')
local naughty = require('naughty')
assert(dbus)
local cjson = require('cjson')

local methods = {}

local invoke_method = function(method_name, payload)
    local m = methods[method_name]
    if m ~= nil then
        return m(payload)
    end
    return nil, "no method implemented"
end

assert(dbus.connect_signal("org.awesomewm.awful.umbe", function(data, payload)
    local result, err = invoke_method(data.member, cjson.decode(payload))
    if err then
        return "s", "{}", "s", err
    end
    return "s", cjson.encode(result)
end))

local _M = {}

function _M:register_remote_method(method_name, func)
    local m = methods[method_name]
    if m ~= nil then
        return false
    end
    methods[method_name] = func
    return true
end

function _M:deregister_remote_method(method_name)
    methods[method_name] = nil
end

return _M