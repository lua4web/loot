#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

// First argument: template string. 
// Second argument: a function which accepts marker and returns its value. 

// markers' names and strings between them find themselves on top of the stack. 
// markers are replaced with value using provided function. It's popped during that, so it must be copied beforehand. 
// So the result to be pushed to buffer is always on top of the stack. 
static int build(lua_State *L) {
	luaL_Buffer B;
	luaL_buffinit(L, &B);

	size_t len;
	const char *s = luaL_checklstring(L, 1, &len);

	size_t i = 0;
	char inside = 0;

	int funcref = luaL_ref(L, LUA_REGISTRYINDEX); // save the function
	
	while(i < len) {
		if(s[i] == '%') {
			if(inside) {
				lua_rawgeti(L, LUA_REGISTRYINDEX, funcref); // push function
			}
			lua_pushlstring(L, s, i);
			if(inside) {
				lua_call(L, 1, 1);
			}
			// now the thing on top of the stack is what is wanted to be added to buffer. 
			luaL_addvalue(&B);
			inside = !inside;
			s += i+1;
			len -= i+1;
			i = 0;
		}
		else {
			i++;
		}
	}

	lua_pushlstring(L, s, len); // push the string after the last marker
	luaL_addvalue(&B);

	luaL_unref(L, LUA_REGISTRYINDEX, funcref);

	luaL_pushresult(&B);

	return 1;
}

static const struct luaL_reg buildlib[] = {
	{"build", build},
	{NULL, NULL}
};

int luaopen_build (lua_State *L) {
	luaL_register(L, "build", buildlib);
return 1;
}

