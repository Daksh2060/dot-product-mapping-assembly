#define _POSIX_C_SOURCE 199309L
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include "lab10.h"


//Used the Timing Results from the provided timing.c file
#define TIMING_RESULT(DESCR, CODE) do { \
    struct timespec start, end; \
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start); \
    CODE; \
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end); \
    double elapsed = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9; \
    printf("%25s took %7.1f ms\n", descr, elapsed * 1000); \
} while(0)


//Function for printing array taken from provided tests.c file 
void print_double_array(double* array, uint64_t length) {
    printf("{ ");
    for (uint64_t i = 0; i < length; i++) {
        printf("%.6g ", array[i]);
    }
    printf("}\n");
}


double* create_array(uint64_t length);


void sin_stdlib(double* input, double* output, uint64_t length){

    //regular for loop calling C library version of sin function
    for (uint64_t i = 0; i < length; i++) {
        output[i] = sin(input[i]);
    }
}


int main(){

    //Changed to 10 for checking correct output
    uint64_t length = 100000;          

    //Creates 2 random arrays for in and out
    double* array1 = create_array(length);
    double* array2 = create_array(length);
    double* array3 = create_array(length);

    //Check to be sure arrays aren't empty
    assert(array1 != NULL);
    assert(array2 != NULL);
    assert(array3 != NULL);
    
    //Set the descr name, since theres only 2 tests it wont be confusing
    const char* descr = "Test";

    //Get the time for running the C version
    TIMING_RESULT(descr, sin_stdlib(array1,array2,length));

    //Get the time for running the assembly version
    TIMING_RESULT(descr, sin_x87(array1,array3,length));

    //length of 10 used to compare arrays to check both implmentations work as expected
    //print_double_array(array2, length);
    //print_double_array(array3, length);

    //Free the arrays
    free(array1);
    free(array2);
    free(array3);

    return 0;
}


