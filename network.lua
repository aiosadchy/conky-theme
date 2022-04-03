local utility = require("utility")

local interface = utility.getenv("NETWORK_INTERFACE")
local display_public_ip = utility.getenv("NETWORK_DISPLAY_PUBLIC_IP")
local public_ip_lookup_url = utility.getenv("NETWORK_PUBLIC_IP_LOOKUP_URL")


function conky_local_ip()
    return conky_parse("${addr " .. interface .. "}")
end


function conky_public_ip()
    if utility.to_boolean(display_public_ip) then
        -- do a lookup every 120 seconds
        return utility.curl_update(public_ip_lookup_url, 120)
    end
    return "___.___.___.___"
end


function conky_upspeed()
    return conky_parse("${upspeed " .. interface .. "}")
end


function conky_downspeed()
    return conky_parse("${downspeed " .. interface .. "}")
end


function conky_upspeedgraph()
    local expression = "${upspeedf " .. interface .. " }"
    return conky_parse(expression)
end


function conky_downspeedgraph()
    local expression = "${downspeedf " .. interface .. " }"
    return conky_parse(expression)
end
