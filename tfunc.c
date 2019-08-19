#include <math.h>

#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"

static int tfunc_sin (lua_State *L) {
	double d = luaL_checknumber(L, 1);
	lua_pushnumber(L, sin(d));
	return 1;
}

static const luaL_Reg tfunc[] = {
  {"sin",   tfunc_sin},
  {NULL, NULL}
};

int luaopen_tfunc (lua_State *L) {
  luaL_newlib(L, tfunc);
  lua_setglobal(L, "tfunc");
  return 1;
}