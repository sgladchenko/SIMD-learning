#include <immintrin.h>
#include <stdio.h>

int main_testshuffles()
{
    // Some smaller function to show how the shuffle function works
    // (and how this _MM_SHUFFLE actually works)
    
    float* array = (float*) aligned_alloc(sizeof(float), sizeof(float)*8);
    for (int i=0; i<8; ++i) { array[i] = 1+i; } 

    __m128 r1 = _mm_load_ps(array);     // 1 2 3 4
    __m128 r2 = _mm_load_ps(array + 4); // 5 6 7 8
  //__m128 rr = _mm_shuffle_ps(r1, r2, _MM_SHUFFLE(2, 1, 3, 2)); // it works :     3 4 6 7
    __m128 rr = _mm_shuffle_ps(r1, r2, 2 + 4*3 + 16*1 + 64*2);   // it also works: 3 4 6 7

    float* res = (float*) aligned_alloc(sizeof(float), sizeof(float)*4);
    _mm_store_ps(res, rr);

    for (int i = 0; i < 4; ++i) { printf("%f ", res[i]); }
    printf("\n");

    return 0;
}