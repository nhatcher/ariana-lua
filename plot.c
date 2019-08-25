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
  // printf("size: %zu\n\n", lua_rawlen(L, -1));
  double *p = (double *) malloc(sizeof(double) * lua_rawlen(L, -1));
  lua_pushnil(L);
  int i = 0;
  while (lua_next(L, -2) != 0) {
    if (lua_type(L, -1) == LUA_TNUMBER) {
      double t = lua_tonumber(L, -1);
      p[i] = t;
      if (lua_type(L, -2) == LUA_TNUMBER) {
        double t2 = lua_tonumber(L, -2);
        p[i] = t;
      }
    } else {
      printf("oops\n");
    }
    lua_pop(L, 1);
    i++;
  }
  // printf("%d Read terms\n", i);
  return p;
}



void readPlotData(lua_State *L) {
  lua_pushnil(L);
  int i = 0;
  double *datax;
  int lenx, leny;
  double *datay;
  double ymax, ymin;
  while (lua_next(L, -2) != 0) {
    if (lua_type(L, -1) == LUA_TNUMBER) {
      double t = lua_tonumber(L, -1);
      if (lua_type(L, -2) == LUA_TSTRING) {
        const char *s2 = lua_tostring(L, -2);
        if (strcmp(s2, "ymax")) {
          ymax = t;
        } else if (strcmp(s2, "ymin")) {
          ymin = t;
        }
        printf("%s=%f\n", s2, t);
      } else {
        printf("oops\n\n");
      }
    } else if (lua_type(L, -1) == LUA_TTABLE) {
      // printf("Table: %zu\n", lua_rawlen(L, -1));
      const char *s2 = lua_tostring(L, -2);
      if (strcmp(s2, "datax")) {
        lenx = lua_rawlen(L, -1);
        datax = readNumberArray(L);
      } else if (strcmp(s2, "datay")) {
        leny = lua_rawlen(L, -1);
        datay = readNumberArray(L);
      }
      // printf("%s[4] = %f\n", s2, p[4]);
    } else {
      printf("oops\n");
    }
    lua_pop(L, 1);
    i++;
  }
  printf("datax[0]=%f, datay[0]=%f", datax[0], datay[0]);
  draw_function(datax, datay, lenx, ymax, ymin);
  free(datax);
  free(datay);
  // printf("%d, %d, %d terms\n", i, iN, iS);
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
