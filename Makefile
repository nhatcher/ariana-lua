
CC= emcc
CFLAGS= -O2 -Wall -Wextra


all: main

main: cephes lua main.c
	$(CC) $(CFLAGS)  tfunc.c main.c  -s WASM=1 -O1 -g -o main.js -s EXPORTED_FUNCTIONS="['_run_lua']" lua-5.3.5/src/liblua.a cephes/cephes.bc -Ilua-5.3.5/src -Icephes -Lcephes -Llua-5.3.5/src -lm -ldl

cephes:
	cd cephes && make all

lua:
	cd lua-5.3.5/src && make generic CC='emcc -s WASM=1'

clean:
	cd lua-5.3.5/src && make clean
	rm cephes/cephes.bc

.PHONY: all clean cephes