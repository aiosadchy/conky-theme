local utility = {}


function utility.trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end


function utility.file_exists(path)
    local f = io.open(path, "r")
    if f ~= nil then
        io.close(f)
        return true
    end
    return false
end


function utility.read_parameters(file)
    if not file_exists(file) then return {} end
    local result = {}
    for line in io.lines(file) do
        for variable, value in string.gmatch(line, "([%w_]+)%s*=%s*(.+)$") do
            result[trim(variable)] = trim(value)
        end
    end
    return result
end


function utility.substitute(variables, str, max_depth)
    result = str
    max_depth = max_depth or 64
    depth = 0
    repeat
        replaced = 0
        for variable, value in pairs(variables) do
            result, matches = string.gsub(result, "%[" .. variable .. "%]", value)
            replaced = replaced + matches
        end
        depth = depth + 1
    until replaced == 0 or depth > max_depth
    return result
end


return utility
