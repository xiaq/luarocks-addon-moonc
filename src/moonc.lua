local moonc = {}

local api = require("luarocks.api")
local to_lua = require("moonscript.base").to_lua

local function compile(from, to)
    local ffrom = io.open(from, "rb")
    local moon = ffrom:read("*all")
    ffrom:close()
    local lua = to_lua(moon)
    local fto = io.open(to, "wb")
    fto:write(lua)
    fto:close()
end

local function compile_modules(rockspec)
    local modules = rockspec.build.modules
    for modname, filename in pairs(modules) do
        if not api.exists(filename) and filename:match("%.lua") then
            local moon_filename = filename:sub(1, -5)..".moon"
            if api.exists(moon_filename) then
                compile(moon_filename, filename)
                print("moonc: "..moon_filename.." -> "..filename)
            end
        end
    end
end

function moonc.load()
    api.register_hook("build.before", compile_modules)
end

function moonc.run(filename)
    local rockspec, err, errcode = api.load_rockspec(filename)
    if err then
        return nil, err, errcode
    end
    compile_modules(rockspec)
    return true
end

return moonc
