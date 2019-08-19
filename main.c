#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "tfunc.h"

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
}

// print(tfunc.j0(4));