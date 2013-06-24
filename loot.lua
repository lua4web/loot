local type = type
local tostring = tostring
local sub = string.sub

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

local build = require "build".build

local function concat(a, b)
	return tostring(a) .. tostring(b)
end

local function construct(c, markers) -- constructs an object of class c using markers
	local obj = {
		__parentclass = c,
		__markers = markers or {}
	}
	setmetatable(obj, {
		__index = index,
		__call = build,
		__tostring = build,
		__concat = concat
	})
	return obj
end

local function class(parent) -- constructs a class inherited from parent
	local c = {
		__class = true
	}
	setmetatable(c, {
		__index = parent,
		__call = construct
	})
	return c
end

local function template(parent)
	if type(parent) == "table" then
		return class(parent)
	else
		local c = class{}
		c.__template = parent
		return c
	end
end

return {
	template = template
}
