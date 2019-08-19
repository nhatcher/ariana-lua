#include <math.h>

#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"
#include "cephes.h"

static int tfunc_j0 (lua_State *L) {
	double d = luaL_checknumber(L, 1);
	lua_pushnumber(L, cephes_j0(d));
	return 1;
}

static int tfunc_j1 (lua_State *L) {
	double d = luaL_checknumber(L, 1);
	lua_pushnumber(L, cephes_j1(d));
	return 1;
}

static int tfunc_jn (lua_State *L) {
  double n = luaL_checkinteger(L, 1);
	double x = luaL_checknumber(L, 2);
	lua_pushnumber(L, cephes_jn(n, x));
	return 1;
}

static const luaL_Reg tfunc[] = {
  {"j0",   tfunc_j0},
  {"j1",   tfunc_j1},
  {"jn",   tfunc_jn},
  {NULL, NULL}
};

int luaopen_tfunc (lua_State *L) {
  luaL_newlib(L, tfunc);
  lua_setglobal(L, "tfunc");
  return 1;
}