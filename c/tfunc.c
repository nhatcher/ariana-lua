#include <math.h>

#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"
#include "cephes.h"

// Bessel functions of the first kind

static int tfunc_BesselJ (lua_State *L) {
  double v = luaL_checknumber(L, 1);
	double x = luaL_checknumber(L, 2);
	// printf("BesselJ(%f, %f)", v, x);
  lua_pushnumber(L, cephes_jv(v, x));
	return 1;
}

// Bessel functions of the second kind

static int tfunc_BesselY (lua_State *L) {
  double v = luaL_checknumber(L, 1);
	double x = luaL_checknumber(L, 2);
	lua_pushnumber(L, cephes_yv(v, x));
	return 1;
}

// Modified Bessel functions of the first kind

static int tfunc_BesselI (lua_State *L) {
  double v = luaL_checknumber(L, 1);
	double x = luaL_checknumber(L, 2);
	lua_pushnumber(L, cephes_iv(v, x));
	return 1;
}

// Modified Bessel functions of the second kind

static int tfunc_BesselK (lua_State *L) {
  double n = luaL_checkinteger(L, 1);
	double x = luaL_checknumber(L, 2);
	lua_pushnumber(L, cephes_kn(n, x));
	return 1;
}

static int tfunc_Gamma (lua_State *L) {
	double x = luaL_checknumber(L, 1);
	lua_pushnumber(L, cephes_gamma(x));
	return 1;
}

static int tfunc_Zeta (lua_State *L) {
	double x = luaL_checknumber(L, 1);
	lua_pushnumber(L, cephes_zetac(x));
	return 1;
}
// /* cephes/i0.c */
// double cephes_i0(double x);
// double cephes_i0e(double x);
// /* cephes/i1.c */
// double cephes_i1(double x);
// double cephes_i1e(double x);
// double cephes_iv(double v, double x);
// /* cephes/j0.c */
// double cephes_j0(double x);
// double cephes_y0(double x);
// /* cephes/j1.c */
// double cephes_j1(double x);
// double cephes_y1(double x);
// /* cephes/jn.c */
// double cephes_jn(int n, double x);
// /* cephes/jv.c */
// double cephes_jv(double n, double x);
// /* cephes/k0.c */
// double cephes_k0(double x);
// double cephes_k0e(double x);
// /* cephes/k1.c */
// double cephes_k1(double x);
// double cephes_k1e(double x);
// /* cephes/kn.c */
// double cephes_kn(int nn, double x);
// double cephes_yn(int n, double x);




static const luaL_Reg tfunc[] = {
  // {"j0",   tfunc_j0},
  // {"j1",   tfunc_j1},
  // {"jn",   tfunc_jn},
	// {"jv",   tfunc_jv},
  {NULL, NULL}
};

int luaopen_tfunc (lua_State *L) {
  luaL_newlib(L, tfunc);
  lua_setglobal(L, "tfunc");
	lua_pushcfunction(L, tfunc_BesselJ);
	lua_setglobal(L, "BesselJ");
	lua_pushcfunction(L, tfunc_BesselY);
	lua_setglobal(L, "BesselY");
	lua_pushcfunction(L, tfunc_BesselI);
	lua_setglobal(L, "BesselI");
	lua_pushcfunction(L, tfunc_BesselK);
	lua_setglobal(L, "BesselK");
	lua_pushcfunction(L, tfunc_Gamma);
	lua_setglobal(L, "Gamma");
	lua_pushcfunction(L, tfunc_Zeta);
	lua_setglobal(L, "Zeta");
  return 1;
}