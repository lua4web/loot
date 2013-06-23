local build = require "build".build
local tostring = tostring
local sub = string.sub

local function construct(c, ...)
	local obj = {__parentclass = c}
	setmetatable(obj, {__index = c})
	c.__init(obj, ...)
	return obj
end

local function class(parent)
	local c = {__class = true}
	setmetatable(c, {
		__index = parent or {},
		__call = construct
	})
	return c
end

local base = {}

local function index(t, k)
	local res = t.__parentclass[k] or t.__markers[k]
	if type(k) == "string" and sub(k, 1, 2) ~= "__" then
		if type(res) == "function" then
			res = res(t, t.__markers[k])
		end
		if type(res) == "table" then
			if res.__parentclass then
				res = res()
			elseif res.__class then
				res = res(t)()
			end
		end
		t[k] = res
	end
	return res
end

local function concat(a, b)
	return tostring(a) .. tostring(b)
end

function base:__init(markers)
	self.__markers = markers or {}
	
	setmetatable(self, {
		__index = index,
		__call = build,
		__tostring = build,
		__concat = concat
	})
end

base.__build = build

local function template(parent)
	if type(parent) == "table" then
		return class(parent)
	else
		local c = class(base)
		c.__template = parent
		return c
	end
end

return {
	template = template
}
