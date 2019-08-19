 
all: main

main: cephes lua main.c
	gcc -O1 -g -o main tfunc.c main.c lua-5.3.5/src/liblua.a cephes/cephes.so -Ilua-5.3.5/src -Icephes -Lcephes -Llua-5.3.5/src -lm -ldl

cephes:
	cd cephes && make all

lua:
	cd lua-5.3.5/src && make linux

clean:
	cd lua-5.3.5/src && make clean
	rm cephes/cephes.so

.PHONY: all clean cephes