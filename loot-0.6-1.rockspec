package = "loot"
version = "0.6-1"
source = {
	url = "git://github.com/lua4web/loot.git",
	tag = "v0.6"
}
description = {
	summary = "A simple object oriented general purpose template system",
	detailed = [[
loot is an object oriented template system. It provides tools to easily create, maintain and use complex systems of templates using OOP ideas. ]],
	homepage = "http://lua4web.github.io/loot/",
	license = "MIT/X11"
}
dependencies = {
	"lua >= 5.1, < 5.3"
}
build = {
	type = "builtin",
	modules = {
		loot = "loot.lua",
		build = "build.c"
	}
}

