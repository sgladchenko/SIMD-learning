test: normalize.c test.c
	gcc -o test test.c normalize.c -lm -O3

test.asm: test
	objdump -S test -M intel > test.asm