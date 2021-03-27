local awful = require('awful')
local umbe_rpc = require('umbe.utils.dbus')
local c_api = { client = client}

local init = function()
    umbe_rpc:register_remote_method("client_list", function(payload)
        local tag = awful.screen.focused().selected_tag
        local t = { }
        table.insert(t, {
            name = tag.name
        })
        local clients = tag:clients()
        local result = {}
        for _, c in ipairs(clients) do
            if not c.skip_taskbar then
                table.insert(result, {
                    name = c.name,
                    wid = c.window,
                    class = c.class,
                    instance = c.instance,
                    tags = t,
                    screen = c.screen.index
                })
            end
        end
        return result
    end)

    umbe_rpc:register_remote_method("client_list_all", function(payload)
        local clients = c_api.client.get()
        local result = {}
        for _, c in ipairs(clients) do
            if not c.skip_taskbar then
                local tags = {}
                for _, tag in ipairs(c:tags()) do
                    table.insert(tags, {
                        name = tag.name
                    })
                end
                table.insert(result, {
                    name = c.name,
                    wid = c.window,
                    class = c.class,
                    instance = c.instance,
                    tags = tags,
                    screen = c.screen.index
                })
            end
        end
        return result
    end)

    umbe_rpc:register_remote_method("activate_client", function(clt)
        -- local tag = awful.screen.focused().selected_tag
        -- local clients = tag:clients()
        local clients = c_api.client.get()
        for _, c in ipairs(clients) do
            if c.window == clt.wid then
                awful.screen.focus(c.screen)
                c:tags()[1]:view_only()
                c_api.client.focus = c
                c:raise()
                return {
                    status = 200
                }
            end
        end
        return {
            status = 404
        }
    end)
end

return {
    init = init
}