test: normalize.c test.c
	gcc -o test test.c normalize.c -lm