#include "GOL_runner.cuh"

#define threadWidth 16
#define threadHeight 16


__global__ void stepper(bool* board, bool* newBoard, int* width, int* height) {
	int horizIndex = blockIdx.x * blockDim.x + threadIdx.x;
	int vertIndex = blockIdx.y * blockDim.y + threadIdx.y;
	if (horizIndex < *width && vertIndex < *height) {
		int neighborCount = 0;
		int checkInd = horizIndex + 1;
		checkInd %= *width;
		checkInd = vertIndex * *width + checkInd;
		if (board[checkInd]) neighborCount++;
		checkInd = horizIndex - 1;
		checkInd += *width; checkInd %= *width;

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