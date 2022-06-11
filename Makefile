test: normalize.c test.c
	gcc -g -o test test.c normalize.c -lm