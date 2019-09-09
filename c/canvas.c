#include <math.h>

#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"
#include <string.h>

extern void * malloc(size_t t);
extern void free(void *);

extern void set(int canvasID, const char *str, int len, const char *str1, int len1);
extern void call(int canvasID, const char *str, int len, const char *str1, int len1);


static int canvas_set (lua_State *L) {
  int canvasID = lua_tointeger(L, -3);
  const char *property = lua_tostring(L, -2);
  const char *value = lua_tostring(L, -1);
  set(canvasID, property, (int) strlen(property), value, (int) strlen(value));
	return 0;
}

static int canvas_call (lua_State *L) {
  int canvasID = lua_tointeger(L, -3);
  const char *name = lua_tostring(L, -2);
  const char *values = lua_tostring(L, -1);
  call(canvasID, name, (int) strlen(name), values, (int) strlen(values));
	return 0;
}


static const luaL_Reg canvas[] = {
  {"set", canvas_set},
  {"call", canvas_call},
  {NULL, NULL}
};

int luaopen_canvas (lua_State *L) {
  luaL_newlib(L, canvas);
  lua_setglobal(L, "canvas");
  return 1;
}
