local utility = {}


function utility.trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end


function utility.file_exists(path)
    local f = io.open(path, "r")
    if f == nil then
        return false
    end
    io.close(f)
    return true
end


function utility.get_file_age(path)
    -- TODO: do this in more portable way
    local command = "stat -c %Y " .. path
    local handle = io.popen(command)
    local file_timestamp = handle:read()
    io.close(handle)
    return os.difftime(os.time(), file_timestamp)
end


function utility.read_all(path)
    local f = io.open(path, "r")
    if f == nil then
        return nil
    end
    local content = f:read("*all")
    f:close()
    return content
end


function utility.getenv(name, default)
    default = default or ""
    return os.getenv(name) or default
end


function utility.to_boolean(str)
    str = string.lower(utility.trim(str))
    if str == "true"    or
       str == "yes"     or
       str == "on"      or
       str == "1"       then
        return true
    end
    return false
end


function utility.hash(str)
    local seed = 0
    for i = 1, string.len(str) do
        local b = string.byte(str, i, i)
        seed = ((seed + b) * 69069 + 1) % (2 ^ 32);
    end
    return seed
end


function utility.curl(url)
    local tmp_directory = utility.getenv("TMP_DIRECTORY", "/tmp/")
    local tmp_filename = url
    -- remove special characters from url to use it as a file name
    tmp_filename = string.gsub(tmp_filename, "[^%w]+", "-")
    -- add prefix and cut end to keep file name relatively short
    tmp_filename = "lua-request-" .. string.sub(tmp_filename, 1, 32)
    -- append full url hash to distinguish between different urls
    tmp_filename = tmp_filename .. "-" .. string.format("%08x", utility.hash(url))
    -- put it into temporary directory and attach an extension
    tmp_filename = tmp_directory .. "/" .. tmp_filename .. ".txt"

    os.execute("curl --silent \"" .. url .. "\" -o \"" .. tmp_filename .. "\"")
    return utility.read_all(tmp_filename), tmp_filename
end


local curl_request_history = {}

function utility.curl_update(url, expiration_time)
    local timestamp = os.time()
    local last_result = curl_request_history[url]
    local update_result =
            last_result == nil                      or
            last_result[1] == nil                   or
            not utility.file_exists(last_result[2]) or
            os.difftime(timestamp, last_result[3]) > expiration_time
    if update_result then
        local result, filename = utility.curl(url)
        curl_request_history[url] = {result, filename, timestamp}
    end
    return table.unpack(curl_request_history[url])
end


return utility
