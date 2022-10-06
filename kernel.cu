
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void vectorAdd(int* a, int* b, int* c)
{
    int i = threadIdx.x; //create a list of threads
    c[i] = a[i] + b[i]; //call list of threads to index arrays
    return;
}

int main()
{
    int a[] = { 1, 2, 3 };
    int b[] = { 2, 2, 2 };
    int c[sizeof(a) / sizeof(int)] = { 0 };

    //create pointers into gpu
    int* cudaA = 0; 
    int* cudaB = 0; 
    int* cudaC = 0;

    // allocate mem in gpu
    cudaMalloc(&cudaA, sizeof(a)); 
    cudaMalloc(&cudaB, sizeof(b));
    cudaMalloc(&cudaC, sizeof(c));

    // copy vectors into gpu. args[destination, source, count, direction of data]
    cudaMemcpy(cudaA, a, sizeof(a), cudaMemcpyHostToDevice);  //host = cpu, device = gpu
    cudaMemcpy(cudaB, b, sizeof(b), cudaMemcpyHostToDevice);
    
    //call vectorAdd function
    // vectorAdd<<< THREAD_SIZE, BLOCK_SIZE >>>
    // use threadsize = 1 since we have one list of threads
    vectorAdd <<< 1, sizeof(a) / sizeof(int) >>> (cudaA, cudaB, cudaC);

    cudaMemcpy(c, cudaC, sizeof(c), cudaMemcpyDeviceToHost);
    return; 
}
