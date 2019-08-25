
CC= emcc
CFLAGS= -Oz -Wall -g -Ilua-5.3.5/src -Icephes -Lcephes -Llua-5.3.5/src -lm -ldl
LLVMFLAGS=  -s EXPORT_NAME="_arianaWASM" -s ALLOW_MEMORY_GROWTH=1 -s ASSERTIONS=1 -s EXPORTED_FUNCTIONS="['_run_lua']" -s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' --js-library libs.js

all: output/main.js



output/main-raw.js: cephes lua main.c
	$(CC) $(CFLAGS) tfunc.c plot.c main.c -o output/main.js $(LLVMFLAGS) lua-5.3.5/src/liblua.a cephes/cephes.bc
	mv output/main.js output/main-raw.js

output/main.js: shell-pre.js output/main-raw.js shell-post.js
	cat $^ > $@
	rm -f output/main-raw.js


cephes:
	cd cephes && make all

lua:
	cd lua-5.3.5/src && make generic CC='emcc -s ONLY_MY_CODE -s ASSERTIONS=1'

clean:
	cd lua-5.3.5/src && make clean
	rm -f cephes/cephes.bc
	rm -f output/main.wasm
	rm -f output/main.wast
	rm -f output/main.wasm.map
	rm -f output/main.js

.PHONY: all clean cephes