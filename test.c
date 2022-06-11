#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <getopt.h>
#include <string.h>

void normalizeNOAVX(float* array, int Nvecs);
void normalizeAVX(float* array, int Nvecs);

float randomFloat()
{
    return ((float)rand()) / ((float)(RAND_MAX)) * 3;
}

void printArray(float* array, int Nvecs, const char* s)
{
    printf("%s", s); 
    for (int i = 0; i < 3*Nvecs; i += 3)
    {
        printf("\t(%f, %f, %f)\n", array[i], array[i+1], array[i+2]);
    }
}

void main_test(int Nvecs, int log) // if(!log): <don't print out init arrays and results>
{
    // Some variables for perfomance calculations
    clock_t begin, end;
    double NOAVX_time, AVX_time;
    NOAVX_time = AVX_time = 0.0;

    // Make a dummy array of components of vectors
    if (log)
        printf("Initializing sample arrays...");
    
    float* arrayNOAVX = (float*) malloc(sizeof(float)*Nvecs*3);
    float* arrayAVX = (float*) aligned_alloc(sizeof(float)*4, sizeof(float)*Nvecs*3);
    srand(time(0)); // update seed
    for (int i = 0; i < 3*Nvecs; ++i)
    {
        arrayAVX[i] = arrayNOAVX[i] = randomFloat();
    }

    if (log)
    {
        printf("Initial arrays:\n");
        printArray(arrayNOAVX, Nvecs, "arrayNOAVX:\n");
        printArray(arrayAVX, Nvecs, "arrayAVX:\n");
    }

    // NOAVX-version test:
    begin = clock();
    normalizeNOAVX(arrayNOAVX, Nvecs);
    end = clock(); NOAVX_time = ((double)(end - begin)) / CLOCKS_PER_SEC;

    // AVX-version test:
    begin = clock();
    normalizeAVX(arrayAVX, Nvecs);
    end = clock(); AVX_time = ((double)(end - begin)) / CLOCKS_PER_SEC;

    if (log)
    {
        // Results
        printf("Final arrays:\n");
        printArray(arrayNOAVX, Nvecs, "arrayNOAVX:\n");
        printArray(arrayAVX, Nvecs, "arrayAVX:\n");
    }

    printf("NOAVX version, time: %f sec\n", NOAVX_time);
    printf("AVX version, time: %f sec\n", AVX_time);
    printf("Speed-up (NOAVX/AVX time ratio): %f\n", NOAVX_time/AVX_time);
}

int main(int argc, char** argv)
{
    // Default values
    int Nvecs = 20;
    int log = 0;

    int opt;
    while ((opt = getopt(argc, argv, "ln:")) != -1)
    {
        switch (opt)
        {
            case 'l':
                log = 1;
                break;
            case 'n':
                Nvecs = atoi(optarg);
                break;
        }
    }

    printf("Number of vectors (Nvecs): %d\n", Nvecs);
    printf("Print initial and resulting vectors (log): %s\n", log ? "yes" : "no");
    main_test(Nvecs, log);

    return 0;
}