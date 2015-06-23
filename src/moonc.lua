local moonc = {}

local lfs = require("lfs")
local api = require("luarocks.api")
local to_lua = require("moonscript.base").to_lua

local modules_from_rockspec

local function compile(from, to)
    local ffrom = io.open(from, "rb")
    local moon = ffrom:read("*all")
    ffrom:close()
    local lua = to_lua(moon)
    local fto = io.open(to, "wb")
    fto:write(lua)
    fto:close()
end

local function exists(filename)
    local attr = lfs.attributes(filename)
    print(filename, attr)
    return attr and true or false
end

local function compile_modules(modules)
    if not modules then
        modules = modules_from_rockspec
    end
    if not modules then
        error("Field 'moonc' missing from rockspec")
    end
    for modname, filename in pairs(modules) do
        if not exists(filename) and filename:match("%.lua") then
            local moon_filename = filename:sub(1, -5)..".moon"
            if exists(moon_filename) then
                compile(moon_filename, filename)
                print("moonc: "..moon_filename.." -> "..filename)
            end
        end
    end
end

function moonc.load()
    api.register_rockspec_field("moonc", { _more = true },
        function(m) modules_from_rockspec = m end)
    api.register_hook("build.before", compile_modules)
end

function moonc.run(filename)
    local rockspec, err, errcode = api.load_rockspec(filename)
    if err then
        return nil, err, errcode
    end
    compile_modules(rockspec.moonc)
    return true
end

return moonc
