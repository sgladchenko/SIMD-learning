#include <stdlib.h>
#include <stdio.h>
#include <time.h>

void normalizeNOAVX(float* array, int Nvecs);
void normalizeAVX(float* array, int Nvecs);

float randomFloat()
{
    return ((float)rand()) / ((float)(RAND_MAX)) * 3;
}

void printArray(float* array, int Nvecs)
{
    for (int i = 0; i < 3*Nvecs; i += 3)
    {
        printf("\t(%f, %f, %f)\n", array[i], array[i+1], array[i+2]);
    }
}

int main()
{
    const int Nvecs = 12;
    srand(time(0));

    // Make a dummy array of components of vectors
    float* arrayNOAVX = (float*) malloc(sizeof(float)*Nvecs*3);
    float* arrayAVX = (float*) aligned_alloc(sizeof(float)*4, sizeof(float)*Nvecs*3);
    for (int i = 0; i < 3*Nvecs; ++i) { arrayAVX[i] = arrayNOAVX[i] = randomFloat(); }

    printf("Initial arrays:\n");
    printf("arrayNOAVX:\n"); printArray(arrayNOAVX, Nvecs);
    printf("arrayAVX:\n"); printArray(arrayAVX, Nvecs);

    // Make two calculations
    normalizeNOAVX(arrayNOAVX, Nvecs);
    normalizeAVX(arrayAVX, Nvecs);

    // Print the results
    printf("Final arrays:\n");
    printf("arrayNOAVX:\n"); printArray(arrayNOAVX, Nvecs);
    printf("arrayAVX:\n"); printArray(arrayAVX, Nvecs);

    return 0;
}