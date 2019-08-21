#include <math.h>

#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"

extern void set_point(double x, double y);

static int plot_set_point (lua_State *L) {
  double x = luaL_checknumber(L, 1);
	double y = luaL_checknumber(L, 2);
	set_point(x, y);
	return 0;
}

static const luaL_Reg plot[] = {
  {"set_point", plot_set_point},
  {NULL, NULL}
};

int luaopen_plot (lua_State *L) {
  luaL_newlib(L, plot);
  lua_setglobal(L, "plot");
  return 1;
}
