#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "tfunc.h"
#include "plot.h"


int run_lua(const char* script) {
	lua_State* lua = luaL_newstate();
	luaL_openlibs(lua);
	luaopen_tfunc(lua);
	luaopen_plot(lua);

	// int res = 
	luaL_dostring(lua, script);

	size_t len = 0;
	const char* value = lua_tolstring(lua, lua_gettop(lua), &len);

	printf("%s\n", value);

	lua_close(lua);

	return 0;
}

/*
int main(void) {
	char buff[256];
	int error;
	lua_State* lua = luaL_newstate();
	luaL_openlibs(lua);
	luaopen_tfunc(lua);

	while (fgets(buff, sizeof(buff), stdin) != NULL) {
		error = luaL_loadstring(lua, buff) || lua_pcall(lua, 0, 0, 0);
		if (error) {
			fprintf(stderr, "%s\n", lua_tostring(lua, -1));
			lua_pop(lua, 1);
		}
	}

	lua_close(lua);

	return 0;
}*/

// print(tfunc.j0(4));
// print(tfunc.jn(2, 3.5));