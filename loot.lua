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
		local f, l, marker = find(s, "%%([%a%d]*)%%", start+1)
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
	self.__object = true
	
	local mt = getmetatable(self)
	local old_index = mt.__index or {}
	
	function mt.__index(t, k)
		local res = old_index[k] or markers[k]
		if type(k) == "string" and sub(k, 1, 2) ~= "__" then
			if type(res) == "function" then
				res = res(t)
			end
			if type(res) == "table" then
				if res.__object then
					res = res()
				else
					res = res(t)()
				end
			end
			t[k] = res
		end
		return res
	end

	function mt.__call(t, ...)
		return self:__build(...)
	end
	
	setmetatable(self, mt)
end

function base:__getmarker(marker)
	return self[marker] or "%"..marker.."%"
end

function base:__build()
	if self.__prepare then
		self:__prepare()
	end

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
