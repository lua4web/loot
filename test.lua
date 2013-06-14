local loot = require "loot"

local class, base, template = loot.class, loot.base, loot.template

genericpage = template[[
<html>
<head>
<title>%title%</title>
</head>
<body>
%body%
</body>
</html>]]

userpanel = template[[
<div>
Hello, %username%!
</div>]]

loginpanel = template[[
<form>
Login: <input>
Password: <input>
<input type="submit">
</form>]]


body = template[[
%panel%
<h1>%title%</h1>
<div>
%content%
</div>
<div>lua4web, 2013</div>]]

page = template(genericpage)
page.body = body

function page:build()
	if self.logged then
		self.panel = userpanel
	else
		self.panel = loginpanel
	end
	return base.build(self)
end

homepage = template(page)
homepage.title = "My homepage"
homepage.content = "Welcome to my page!"

homepage1 = homepage{
	logged = true,
	username = "lua4web"
}

homepage2 = homepage{
	logged = false
}

print(homepage1:build())
print()
print(homepage2:build())
