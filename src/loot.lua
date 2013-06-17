local class = require "oop"
local build = require "build".build
local tostring = tostring
local find = string.find
local sub = string.sub
local len = string.len
local insert = table.insert
local concat = table.concat

local base = {}

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

	function mt.__tostring(t)
		return self:__build()
	end

	function mt.__concat(t, arg)
		return t:__build()..tostring(arg)
	end
	
	setmetatable(self, mt)
end

function base:__getmarker(marker)
	return marker == "" and "%" or self[marker] or "%"..marker.."%"
end

function base:__build()
	if self.__prepare then
		self:__prepare()
	end

	local function helper(marker)
		return self:__getmarker(marker)
	end

	return build(self.__template, helper)
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
