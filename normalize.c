#include <immintrin.h>
#include <math.h>

#define Sqr(x) (x)*(x)
#define ShuffleMask(a,b,c,d) ((a) | (b << 2) | (c << 4) | (d << 6))

// Efficient usage of vector intrinsics for 
// normalizing 3D vectors. In the arrays data
// is organized in the following way: { x0, y0, z0, x1, y1, z1, x2, y2, z2, ... }
// (3*Nvecs elements)

void normalizeNOAVX(float* array, int Nvecs)
{
    // Implementation of this function which doesn't use any vector intrinsics,
    // instead, just makes it as usual with the for-loop

    for (int i = 0; i < 3*Nvecs; i += 3)
    {
        float tmp = 1.0f / sqrtf(Sqr(array[i]) + Sqr(array[i+1]) + Sqr(array[i+2]));
        array[i    ] *= tmp;
        array[i + 1] *= tmp;
        array[i + 2] *= tmp;
    }
}

void normalizeAVX(float* array, int Nvecs)
{
    // Implementation that actually uses vector intrinsics

    // Idea is to do normalization for 4 vectors placed next to each other simultaneously
    // then go next 4 vectors, rather than doing some operations in parallel for only one vector; 
    // it also allows to make summations like (x_i)^2 + (y_i)^2 + (z_i)^2
    // in parallel for these 4 vectors.

    // Note: Nvecs must be a multiple of 4 to work properly,
    // so each iteration here normalizes 4 vectors at once (4*3 = 12 floats)

    for (int i = 0; i < 3*Nvecs; i += 12)
    {
        // 0: Take 4 vectors from memory to the registers
        __m128 reg0 = _mm_load_ps(array + i);     // x0, y0, z0, x1
        __m128 reg1 = _mm_load_ps(array + i + 4); // y1, z1, x2, y2
        __m128 reg2 = _mm_load_ps(array + i + 8); // z2, x3, y3, z3

        // 1: Shuffling registers: AOS to SOA
        __m128 rreg = _mm_shuffle_ps(reg1, reg2, ShuffleMask(2,3,1,2)); // x2, y2, x3, y3
        __m128 lreg = _mm_shuffle_ps(reg0, reg1, ShuffleMask(1,2,0,1)); // y0, z0, y1, z1

        __m128 xs = _mm_shuffle_ps(reg0, rreg, ShuffleMask(0,3,0,2)); // x0, x1, x2, x3
        __m128 ys = _mm_shuffle_ps(lreg, rreg, ShuffleMask(0,2,1,3)); // y0, y1, y2, y3
        __m128 zs = _mm_shuffle_ps(lreg, reg2, ShuffleMask(1,3,0,3)); // z0, z1, z2, z3

        // 2: Calculating squares; sum them and evaluate square roots
        reg0 = _mm_mul_ps(xs, xs);
        reg1 = _mm_mul_ps(ys, ys);
        reg2 = _mm_mul_ps(zs, zs);

        lreg = _mm_add_ps(reg0, reg1);
        lreg = _mm_add_ps(lreg, reg2);
        lreg = _mm_sqrt_ps(lreg); // in each ith float (i in {0,1,2,3}): sqrt((x_i)^2 + (y_i)^2 + (z_i)^2)

        // 3: Normalizing the components
        xs = _mm_div_ps(xs, lreg);
        ys = _mm_div_ps(ys, lreg);
        zs = _mm_div_ps(zs, lreg);

        // 4: Shuffling them back: SOA to AOS
        __m128 creg = _mm_shuffle_ps(zs, xs, ShuffleMask(0,2,1,3)); // z0, z2, x1, x3
        lreg = _mm_shuffle_ps(xs, ys, ShuffleMask(0,2,0,2));        // x0, x2, y0, y2
        rreg = _mm_shuffle_ps(ys, zs, ShuffleMask(1,3,1,3));        // y1, y3, z1, z3

        reg0 = _mm_shuffle_ps(lreg, creg, ShuffleMask(0,2,0,2)); // x0, y0, z0, x1
        reg1 = _mm_shuffle_ps(rreg, lreg, ShuffleMask(0,2,1,3)); // y1, z1, x2, y2
        reg2 = _mm_shuffle_ps(creg, rreg, ShuffleMask(1,3,1,3)); // z2, x3, y3, z3

        // Final stage: Store it in the memory
        _mm_store_ps(array + i, reg0);
        _mm_store_ps(array + i + 4, reg1);
        _mm_store_ps(array + i + 8, reg2);
    }
}