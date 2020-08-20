#include "GOL_runner.cuh"

#define threadWidth 16
#define threadHeight 16




GOL::GOL(int width, int height, bool* data) {
	this->width = width;
	this->height = height;
	int size = sizeof(bool) * width * height;
	this->board = (bool *)malloc(size);
	cudaMemcpy(this->board, data, size, cudaMemcpyHostToHost);
}

bool GOL::init() {
	size = sizeof(bool) * width * height;
	cudaMalloc((void **)&d_board, size);
	cudaMalloc((void**)&d_boardNew, size);

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