
CC= emcc
CFLAGS= -Oz -Wall -g -Ilua-5.3.5/src -Icephes -Lcephes -Llua-5.3.5/src -lm -ldl
LLVMFLAGS= -s EXPORTED_FUNCTIONS="['_run_lua']" -s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' --js-library libs.js

all: main

main: cephes lua main.c
	$(CC) $(CFLAGS) tfunc.c plot.c main.c -o main.html $(LLVMFLAGS) lua-5.3.5/src/liblua.a cephes/cephes.bc

cephes:
	cd cephes && make all

lua:
	cd lua-5.3.5/src && make generic CC='emcc'

clean:
	cd lua-5.3.5/src && make clean
	rm -f cephes/cephes.bc
	rm -f main.wasm
	rm -f main.wast
	rm -f main.wasm.map

.PHONY: all clean cephes