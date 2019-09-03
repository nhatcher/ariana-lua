#ifndef plot_h
#define plot_h

#include "lua.h"

// #define LUA_TFUNCLIBNAME	"tfunc"
int luaopen_plot(lua_State *L);

#endif

// local tfunc = require "tfunc";