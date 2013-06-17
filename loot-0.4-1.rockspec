package = "loot"
version = "0.4-1"
source = {
	url = "git://github.com/lua4web/loot.git",
	tag = "v0.4"
}
description = {
	summary = "A simple object oriented general purpose template system",
	detailed = [[
loot is template system for building structured systems of templates using OOP ideas. It is mainly written in Lua, with a bottleneck function written in C. 
]],
	homepage = "http://lua4web.github.io/loot",
	license = "MIT/X11"
}
dependencies = {
	"lua >= 5.1, < 5.3"
}
build = {
	type = "builtin",
	modules = {
		loot = "src/loot.lua",
		oop = "src/oop.lua",
		build = "src/build.c"
	}
}

