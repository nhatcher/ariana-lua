all: cephes.bc

cephes.bc: *.c
	emcc -Oz -Wall -s LINKABLE=1 *.c -o cephes.bc