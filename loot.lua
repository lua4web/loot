local class = require "oop"

local find = string.find
local sub = string.sub

local base = class()

function base:init(markers)
	for k, v in pairs(markers) do
		self[k] = v
	end
end

function base:build()
	self.template = self.template or ""
	local res = ""
	local start, finish, marker
	local prev = 0
	
	repeat
		start, finish, marker = find(self.template, "%%(%a*)%%", prev+1)
		if marker then
			res = res..sub(self.template, prev+1, start-1)
			if marker == "" then
				res = res.."%"
			else
				res = res..(self[marker] or ("%"..marker.."%"))
			end
		else
			res = res..sub(self.template, prev+1)
		end
		prev = finish
	until not marker
	
	return res
end

local function template(parent)
	if type(parent) == "table" then
		return class(parent)
	else
		local c = class(base)
		c.template = parent
		return c
	end
end

return {class = class, template = template, base = base}
