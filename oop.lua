-- Simple OOP implementation using metamethods.
-- Class refers to its parent, object refers to its class.
-- Methods use colon syntax.
-- __init() method is called upon initialization of objects.

local function class(parent)
	
	-- resulting class
	local c = {}
	
	-- default parent is an empty class
	local parent = parent or {}
	
	-- metatable
	local mt = {}
	
	-- inheritance
	mt.__index = parent
	
	-- constructor
	function mt.__call(t, ...)
		
		-- resulting object
		local obj = {}
		
		-- adding references to class members
		setmetatable(obj, {__index = c})
			
		-- initialization
		if c.__init then
			c.__init(obj, ...)
		end
		return obj
	end
	
	setmetatable(c, mt)
	return c
end

return class
