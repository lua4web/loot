local class = require "oop"

local find = string.find
local sub = string.sub
local insert = table.insert
local concat = table.concat

local base = class()

function base:init(markers)
	for k, v in pairs(markers) do
		self[k] = v
	end
end

function base:getmarker(marker)
	if self[marker] then
		if type(self[marker]) == "table" then
			local subtemplate = self[marker](self)
			return subtemplate:build()
		else
			return self[marker]
		end
	else
		return "%"..marker.."%"
	end
end

function base:build()
	local res = {}
	local start, finish, marker
	local prev = 0
	
	repeat
		start, finish, marker = find(self.template, "%%(%a*)%%", prev+1)
		start = start or 0
		insert(res, sub(self.template, prev+1, start-1))
		if marker then
			if marker == "" then
				insert(res, "%")
			else
				insert(res, self:getmarker(marker))
			end
		end
		prev = finish
	until not marker
	
	return concat(res)
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
