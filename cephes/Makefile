all: cephes.bc

cephes.bc: *.c
	emcc -s LINKABLE=1 *.c -o cephes.bc