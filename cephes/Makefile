all: cephes.bc

cephes.bc: *.c
	emcc -Oz -Wall -s LINKABLE=1 *.c -o cephes.bc

# https://dassur.ma/things/c-to-webassembly/

# /opt/clang/bin/clang --target=wasm32 -O3 -flto -nostdlib -Wl,--no-entry -Wl,--export-all -Wl,--lto-O3 -o cephes.bc *.c
