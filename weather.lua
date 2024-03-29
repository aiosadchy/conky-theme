local utility = require("utility")

local json = require("third-party/json")

local tmp_directory = utility.getenv("TMP_DIRECTORY", "/tmp/")
local openweathermap_api_key = utility.getenv("WEATHER_OPENWEATHERMAP_API_KEY")
local weather_report_file = tmp_directory .. "/" .. utility.getenv("USER", "") .. "-weather.json"
local weather_report = nil


function get_seconds_since_midnight()
    local date = os.date("*t")
    date["hour"], date["min"], date["sec"] = 0, 0, 0
    return os.difftime(os.time(), os.time(date))
end


function get_api_key()
    return openweathermap_api_key
end


function get_location()
    -- TODO: support for custom location provider
    local result = utility.curl("http://ip-api.com/json")
    local response = json.parse(result)
    return response["lat"] or "", response["lon"] or ""
end


function get_weather_report(lat, lon)
    local request = "http://api.openweathermap.org"   ..
                    "/data/2.5/onecall"               ..
                    "?appid=" .. get_api_key()        ..
                    "&lat="   .. lat                  ..
                    "&lon="   .. lon                  ..
                    "&exclude=minutely,hourly,alerts" ..
                    "&units=metric"                   ..
                    "&lang=en"
    local report = utility.curl_update(request, 60 * 15)
    return report
end


function is_report_incomplete()
    return (weather_report == nil) or
           (weather_report["current"] == nil)
end


function need_to_update_report(path)
    if (weather_report == nil) then
        return true
    end

    if (not utility.file_exists(path)) then
        return true
    end

    local file_age = utility.get_file_age(path)
    if (file_age > 3600 * 6) then
        return true
    end

    if (is_report_incomplete() and file_age > 120) then
        return true
    end

    local daytime = get_seconds_since_midnight()
    if (file_age > daytime) then
        return true
    end

    return false
end


function update_weather_report(path)
    local lat, lon = get_location()
    local report = get_weather_report(lat, lon)
    local f = io.open(path, "w")
    if (f == nil) then
        return
    end
    f:write(report)
    io.close(f)
    weather_report = json.parse(report)
end


function refresh_weather_data()
    if (need_to_update_report(weather_report_file)) then
        update_weather_report(weather_report_file)
    end
    if (not is_report_incomplete()) then
        return
    end
    local f = io.open(weather_report_file, "r")
    if (f == nil) then
        return
    end
    weather_report = json.parse(f:read("*all"))
    io.close(f)
end


function conky_is_weather_ready()
    refresh_weather_data()
    if is_report_incomplete() then
        return 0
    end
    return 1
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
