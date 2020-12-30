
CC= emcc
CFLAGS= -Oz -Wall -Ilua-5.4.2/src -Icephes -Lcephes -Llua-5.4.2/src -lm -ldl
LLVMFLAGS= -s EXPORT_NAME="_arianaWASM"\
           -s ALLOW_MEMORY_GROWTH=1\
					 -s ASSERTIONS=1\
					 -s EXPORTED_FUNCTIONS="['_run_lua']"\
					 -s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]'\
					 --js-library js/libs.js

all: docs/main.js



docs/main-raw.js: cephes lua c/main.c
	$(CC) $(CFLAGS) c/tfunc.c c/plot.c c/canvas.c c/main.c -o docs/main.js $(LLVMFLAGS) lua-5.4.2/src/liblua.a cephes/cephes.bc --preload-file modules/@/ --no-heap-copy
	mv docs/main.js docs/main-raw.js

docs/main.js: js/shell-pre.js docs/main-raw.js js/shell-post.js
	cat $^ > $@
	rm -f docs/main-raw.js


cephes:
	cd cephes && make all

lua:
	cd lua-5.4.2/src && make generic CC='emcc -s ASSERTIONS=1'

clean:
	cd lua-5.4.2/src && make clean
	rm -f cephes/cephes.bc
	# rm -f docs/main.wasm
	rm -f docs/main.wast
	rm -f docs/main.wasm.map
	# rm -f docs/main.js
	# rm -f docs/main.data

.PHONY: all clean cephes