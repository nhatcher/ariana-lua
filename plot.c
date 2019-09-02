#include <math.h>

#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"
#include <string.h>

extern void set_point(double x, double y);
extern void * malloc(size_t t);
extern void free(void *);
extern void draw_function(double *, double *, int len, double miny, double maxy);

// LUA_TNIL		0
// LUA_TBOOLEAN		1
// LUA_TLIGHTUSERDATA	2
// LUA_TNUMBER		3
// LUA_TSTRING		4
// LUA_TTABLE		5
// LUA_TFUNCTION		6
// LUA_TUSERDATA		7
// LUA_TTHREAD		8

double *readNumberArray(lua_State *L) {
  double *p = (double *) malloc(sizeof(double) * lua_rawlen(L, -1));
  int i = 0;
  lua_pushnil(L);
  while (lua_next(L, -2) != 0) {
    double t = lua_tonumber(L, -1);
    // TODO assert: 
    // lua_type(L, -1) == LUA_TNUMBER
    // lua_type(L, -2) == LUA_TNUMBER
    // lua_tonumber(L, -2) == i+1
    p[i] = t;
    lua_pop(L, 1);
    i++;
  }
  return p;
}


void readPlotData(lua_State *L) {
  double *datax, *datay;
  int lenx, leny;
  double ymax, ymin;
  lua_pushnil(L);
  while (lua_next(L, -2) != 0) {
    const char *key = lua_tostring(L, -2);
    // printf("Computing key %s\n", key);
    // ASSERT lua_type(L, -2) == LUA_TSTRING
    // printf("%s[%s]\n",
    //   lua_typename(L, lua_type(L, -2)),
    //   lua_typename(L, lua_type(L, -1))
    // );
    if (strcmp(key, "ymax") == 0) {
      double t = lua_tonumber(L, -1);
      ymax = t;
    } else if (strcmp(key, "ymin") == 0) {
      double t = lua_tonumber(L, -1);
      ymin = t;
    } else if (strcmp(key, "datax") == 0) {
      lenx = lua_rawlen(L, -1);
      datax = readNumberArray(L);
    } else if (strcmp(key, "datay") == 0) {
      leny = lua_rawlen(L, -1);
      datay = readNumberArray(L);
    } else {
      printf("oops\n\n");
    }
    lua_pop(L, 1);
  }
  draw_function(datax, datay, lenx, ymax, ymin);
  free(datax);
  free(datay);
}

static int plot_set_point (lua_State *L) {
  double x = luaL_checknumber(L, 1);
	double y = luaL_checknumber(L, 2);
	set_point(x, y);
	return 0;
}

static int plot_set_function (lua_State *L) {
  // void *p = lua_touserdata(L, 1);
  readPlotData(L);
	return 0;
}


static const luaL_Reg plot[] = {
  {"set_point", plot_set_point},
  {"set_function", plot_set_function},
  {NULL, NULL}
};

int luaopen_plot (lua_State *L) {
  luaL_newlib(L, plot);
  lua_setglobal(L, "plot");
  return 1;
}
