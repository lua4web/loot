local loot = require "loot"

-- templates

-- main template
genericpage = loot.template[[
<html>
<head>
<title>%title%</title>
</head>
<body>
%body%
</body>
</html>]]

-- a template
userpanel = loot.template[[
<div>
Hello, %username%!
</div>]]

-- a template
loginpanel = loot.template[[
<form>
Login: <input>
Password: <input>
<input type="submit">
</form>]]

-- a template
body = loot.template[[
%panel%
<h1>%title%</h1>
<div>
%content%
</div>
<div>lua4web, 2013</div>]]

-- more concrete main template
page = loot.template(genericpage)
page.body = body -- static link to lower-level template

function page:panel() -- reference to marker of lower-level template
	return self.logged and userpanel or loginpanel -- dynamic link to lower-level template
end

-- even more concrete main template
homepage = loot.template(page)
homepage.title = "My homepage" -- static link
homepage.content = "Welcome to my page!" -- static link

-- usage

homepage1 = homepage{
	logged = true,
	username = "lua4web"
}

homepage2 = homepage{
	logged = false
}

print(homepage1()) --[[
<html>
<head>
<title>My homepage</title>
</head>
<body>
<div>
Hello, lua4web!
</div>
<h1>My homepage</h1>
<div>
Welcome to my page!
</div>
<div>lua4web, 2013</div>
</body>
</html>
]]

print(homepage2()) --[[
<html>
<head>
<title>My homepage</title>
</head>
<body>
<form>
Login: <input>
Password: <input>
<input type="submit">
</form>
<h1>My homepage</h1>
<div>
Welcome to my page!
</div>
<div>lua4web, 2013</div>
</body>
</html>
]]
