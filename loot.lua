local class = require "oop"

local find = string.find
local sub = string.sub
local len = string.len
local insert = table.insert
local concat = table.concat

-- this function must search for the next marker in "s" after the "start" symbol and return up to three values:
-- last symbol of the found marker or false if it's not found;
-- substring of "s" between the "start" symbol and start of the found marker;
-- found marker or nil if it's not found. 
-- if not start then nothing is returned. 

local function markers_iter(s, start)
	if start then
		local f, l, marker = find(s, "%%(%a*)%%", start+1)
		return l or false, sub(s, start+1, (f or 0)-1), marker
	end
end

local function markers(s)
	return markers_iter, s, 0
end

local base = class()

function base:__init(markers)
	local markers = markers or {}
	self.__markers = markers
	
	local mt = getmetatable(self)
	local old_index = mt.__index or {}
	
	function mt.__index(t, k)
		return old_index[k] or markers[k]
	end

	function mt.__call(t, ...)
		return self:__build(...)
	end
	
	setmetatable(self, mt)
end

function base:__getmarker(marker)
	local val = self[marker]
	if val then
		if type(val) == "function" then
			val = val(self)
		end
		if type(val) == "table" then
			val = val(self)()
		end
		self[marker] = val
		return val
	else
		return "%"..marker.."%"
	end
end

function base:__build()
	local res = {}
	
	for i, before, marker in markers(self.__template) do
		insert(res, before)
		if marker then
			if marker == "" then
				insert(res, "%")
			else
				insert(res, self:__getmarker(marker))
			end
		end
	end
	
	return concat(res)
end

local function template(parent)
	if type(parent) == "table" then
		return class(parent)
	else
		local c = class(base)
		c.__template = parent
		return c
	end
end

return {template = template, base = base}
