package = 'luarocks-addon-moonc'
version = 'scm-1'
source = {
    url = 'git://github.com/xiaq/luarocks-addon-moonc.git',
}
description = {
    summary = 'A MoonScript compiling addon for LuaRocks.',
    license = 'BSD',
}
dependencies = {
    'lua >= 5.1'
}
build = {
    type = 'builtin',
    modules = {
        ["luarocks.addon.moonc"] = 'src/moonc.lua'
    },
}
