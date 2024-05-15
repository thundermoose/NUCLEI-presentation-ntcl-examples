#include <cstdint>
#include <cstdio>
__global__ void my_gpu_kernel(double *dst, const double *src, size_t number_of_elements) {
        uint64_t idx = (uint64_t)(blockIdx.x)*(uint64_t)(blockDim.x) + threadIdx.x;
        if (idx < number_of_elements)
                dst[idx] = 1.0/((src[idx]+1)*(src[idx]+1));
}

#define max(a,b) ((a)> (b) ? (a) : (b))

extern "C" void my_gpu_callback(double *dst, double *src, size_t number_of_elements, cudaStream_t *stream) {
        const size_t block_size = 256;
        const size_t number_of_blocks = max(number_of_elements/block_size,1);
        if (stream) {
                my_gpu_kernel<<<number_of_blocks, block_size, 0, *stream>>>(dst, src, number_of_elements);
        } else {
                my_gpu_kernel<<<number_of_blocks, block_size>>>(dst, src, number_of_elements);
        }
}
