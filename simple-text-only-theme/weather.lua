local http = require("socket.http")

package.path = './external/json.lua/?.lua;' .. package.path
local json = require("json")

local WEATHER_REPORT_FILE = "/tmp/weather.json"
local API_KEY_FILE = "openweathermap-api-key"


local weather_report = nil


function trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end


function file_exists(path)
    local f = io.open(path, "r")
    if f ~= nil then
        io.close(f)
        return true
    end
    return false
end


function get_seconds_since_midnight()
    local date = os.date("*t")
    date["hour"], date["min"], date["sec"] = 0, 0, 0
    return os.difftime(os.time(), os.time(date))
end


function get_file_age(path)
    local command = "stat -c %Y " .. path
    local handle = io.popen(command)
    local file_timestamp = handle:read()
    io.close(handle)
    return os.difftime(os.time(), file_timestamp)
end


function get_api_key(path)
    local f = io.open(path, "r")
    local contents = f:read("*all")
    io.close(f)
    return trim(contents)
end


function get_location()
    local body, code = http.request("http://ip-api.com/json")
    local response = json.parse(body)
    return response["lat"], response["lon"]
end


function get_weather_report(lat, lon, api_key)
    local request = "http://api.openweathermap.org"   ..
                    "/data/2.5/onecall"               ..
                    "?appid=" .. api_key              ..
                    "&lat="   .. lat                  ..
                    "&lon="   .. lon                  ..
                    "&exclude=minutely,hourly,alerts" ..
                    "&units=metric"                   ..
                    "&lang=en"
    local body, code = http.request(request)
    return body
end


function need_to_update_report(path)
    if (not file_exists(path)) then
        return true
    end

    local file_age = get_file_age(path)
    if (file_age > 3600 * 6) then
        return true
    end

    daytime = get_seconds_since_midnight()
    if (file_age > daytime) then
        return true
    end

    return false
end


function update_weather_report(path, api_key_file)
    local api_key = get_api_key(api_key_file)
    local lat, lon = get_location()
    local report = get_weather_report(lat, lon, api_key)
    local f = io.open(path, "w")
    f:write(report)
    io.close(f)
    weather_report = json.parse(report)
end


function refresh_weather_data()
    if (need_to_update_report(WEATHER_REPORT_FILE)) then
        update_weather_report(WEATHER_REPORT_FILE, API_KEY_FILE)
    end
    if (weather_report == nil) then
        local f = io.open(WEATHER_REPORT_FILE, "r")
        weather_report = json.parse(f:read("*all"))
        io.close(f)
    end
end


function conky_weather(day, property, format)
    refresh_weather_data()

    local data = nil

    if (day == "current") then
        data = weather_report["current"]
    else
        day = tonumber(day)
        data = weather_report["daily"][day]
    end

    for p in property:gsub("%f[.]%.%f[^.]", "\0"):gmatch"%Z+" do
        local n = tonumber(p)
        if (n ~= nil) then
            p = n
        end
        data = data[p]
    end

    if (format == "temp") then
        data = math.floor(tonumber(data) + 0.5)
        return (data > 0) and ("+" .. data) or data
    end

    if (format == "date") then
        return os.date("%a, %d.%m", data)
    end

    return data
end





function conky_align(format, ...)
    local args = {}
    for k, v in ipairs({...}) do
        args[k] = conky_parse(v)
    end
    return string.format("%" .. format .. "s", table.concat(args, " "))
end
