 
all: main

main: lua main.c
	gcc -O1 -g -o main tfunc.c main.c lua-5.3.5/src/liblua.a -I lua-5.3.5/src -L lua-5.3.5/src -lm -ldl

tfunc:
	gcc -fPIC -shared -c -o tfunc.so tfunc.c -I lua-5.3.5/src -L lua-5.3.5/src

lua:
	cd lua-5.3.5/src && make linux

clean:
	cd lua-5.3.5/src && make clean