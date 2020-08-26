#include "GOL_runner.cuh"

#define threadWidth 16
#define threadHeight 16


__forceinline __device__ int horizCheck(bool* board, int* width, int* height, int* x, int* y) {
	int horizIndex, vertIndex, realIndex, count;
	vertIndex = (*y); count = 0;

	if ((*x) + 1 == (*width)) { horizIndex = 0; }
	else { horizIndex = (*width) + 1; }
	realIndex = (*width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	if ((*x) == 0) { horizIndex = (*width) - 1; }
	else { horizIndex = (*x) - 1; }
	realIndex = (*width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	return count;
}


__forceinline __device__ int vertCheck( bool* board, int* width, int* height, int* x, int* y) {
	int horizIndex, vertIndex, realIndex, count;
	horizIndex = (*x); count = 0;

	if ((*y) + 1 == (*height)) { vertIndex = 0; }
	else { vertIndex = (*height) + 1; }
	realIndex = (*width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	if ((*y) == 0) { vertIndex = (*height) - 1; }
	else { vertIndex = (*y) - 1; }
	realIndex = (*width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	return count;

}

__forceinline __device__ int cornerCheck(bool* board, int* width, int* height, int* x, int* y) {
	int horizIndex, vertIndex, realIndex, count;
	count = 0;

	if ((*y) + 1 == (*height)) { vertIndex = 0; }
	else { vertIndex = (*height) + 1; }
	if ((*x) + 1 == (*width)) { horizIndex = 0; }
	else { horizIndex = (*width) + 1; }
	realIndex = (*width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	if ((*x) == 0) { horizIndex = (*width) - 1; }
	else { horizIndex = (*x) - 1; }
	realIndex = (*width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	if ((*y) == 0) { vertIndex = (*height) - 1; }
	else { vertIndex = (*y) - 1; }
	realIndex = (*width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	if ((*x) + 1 == (*width)) { horizIndex = 0; }
	else { horizIndex = (*width) + 1; }
	realIndex = (*width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	return count;
}

__global__ void stepper(bool* board, bool* newBoard, int* width, int* height) {
	int horizIndex = blockIdx.x * blockDim.x + threadIdx.x;
	int vertIndex = blockIdx.y * blockDim.y + threadIdx.y;

	int x = blockIdx.x * blockDim.x + threadIdx.x;
	int y = blockIdx.y * blockDim.y + threadIdx.y;

	if (horizIndex < *width && vertIndex < *height) {
		int neighborCount = horizCheck(board, width, height, &x, &y);
		neighborCount += vertCheck(board, width, height, &x, &y);
		neighborCount += cornerCheck(board, width, height, &x, &y);

	}
}

GOL::GOL(int width, int height, bool* data) {
	this->width = width;
	this->height = height;
	size = sizeof(bool) * width * height;
	board = (bool *)malloc(size);
	cudaMemcpy(board, data, size, cudaMemcpyHostToHost);
}

bool GOL::init() {
	size = sizeof(bool) * width * height;
	cudaMalloc((void **)&d_board, size);
	cudaMalloc((void**)&d_boardNew, size);

	size = sizeof(int);
	cudaMalloc((void**)&d_width, size); cudaMalloc((void**)&d_height, size);
	
	cudaMemcpy(&d_board, &board, size, cudaMemcpyHostToDevice);

	numBlockVert = height / threadHeight;
	if (height % threadHeight > 0) numBlockVert++;
	numBlockHoriz = width / threadWidth;
	if (height % threadWidth > 0) numBlockHoriz++;

	initialized = true;
}

bool GOL::step(bool show, bool* output) {
	dim3 dimGrid(numBlockHoriz, numBlockVert);
	dim3 dimBlock(threadWidth, threadHeight);

}