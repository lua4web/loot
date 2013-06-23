#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

static int build(lua_State *L) {
	// 1 - self

	int self = luaL_ref(L, LUA_REGISTRYINDEX);
	lua_rawgeti(L, LUA_REGISTRYINDEX, self); // might need this

	lua_getfield(L, 1, "__prepare");
	// 1 - self
	// 2 - __prepare

	if(lua_isfunction(L, 2)) {
		lua_rawgeti(L, LUA_REGISTRYINDEX, self);
		// 1 - self
		// 2 - __prepare
		// 3 - self

		lua_call(L, 1, 0);
	}
	else {
		lua_pop(L, 1);
	}

	luaL_unref(L, LUA_REGISTRYINDEX, self); 

	// 1 - self

	lua_getfield(L, 1, "__template");
	// 1 - self
	// 2 - template
	
	size_t len;
	const char *s = lua_tolstring(L, 2, &len);
	if(s == NULL) {
		s = "";
		len = 0;
	}
	
	lua_pop(L, 1);

	// 1 - self

	luaL_Buffer B;
	luaL_buffinit(L, &B);

	size_t i = 0;
	char inside = 0;
	
	while(i < len) {
		if(s[i] == '%') {
			if(inside) {
				if(i) { // marker is not empty?
					lua_pushlstring(L, s, i);
					// 1 - self
					// 2 - marker

					lua_gettable(L, 1); // pops the string!
					// 1 - self
					// 2 - marker's value

					if(lua_isnil(L, 2)) { // could not find marker
						lua_pop(L, 1); // remove nil
						luaL_addstring(&B, "%");
						luaL_addlstring(&B, s, i); // add "%"..marker.."%"
						luaL_addstring(&B, "%");
					}
					else {
						luaL_addvalue(&B); // add marker's value
					}
				}
				else { // marker is empty?
					luaL_addstring(&B, "%");
				}
			}
			else {
				luaL_addlstring(&B, s, i);
			}
			inside = !inside;
			s += i+1;
			len -= i+1;
			i = 0;
		}
		else {
			i++;
		}
	}

	if(inside) { // this means that template was incorrect, let's get that last unpaired %
		s--;
		len++;
	}
	lua_pushlstring(L, s, len); // push the string after the last marker
	luaL_addvalue(&B);

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

