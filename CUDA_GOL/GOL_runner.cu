#include "GOL_runner.cuh"
#include <stdio.h>
#define threadWidth 16
#define threadHeight 16


 __inline __device__ int horizCheck(bool* board, int width, int height, int x, int y) {
	int horizIndex, vertIndex, realIndex, count;
	vertIndex = (y); count = 0;

	if ((x) + 1 == (width)) { horizIndex = 0; }
	else { horizIndex = (width) + 1; }
	realIndex = (width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	if ((x) == 0) { horizIndex = (width) - 1; }
	else { horizIndex = (x) - 1; }
	realIndex = (width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	return count;
}


__inline __device__ int vertCheck( bool* board, int width, int height, int x, int y) {
	int horizIndex, vertIndex, realIndex, count;
	horizIndex = (x); count = 0;

	if ((y) + 1 == (height)) { vertIndex = 0; }
	else { vertIndex = (height) + 1; }
	realIndex = (width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	if ((y) == 0) { vertIndex = (height) - 1; }
	else { vertIndex = (y) - 1; }
	realIndex = (width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	return count;

}

__inline __device__ int cornerCheck(bool* board, int width, int height, int x, int y) {
	int horizIndex, vertIndex, realIndex, count;
	count = 0;

	if ((y) + 1 == (height)) { vertIndex = 0; }
	else { vertIndex = (height) + 1; }
	if ((x) + 1 == (width)) { horizIndex = 0; }
	else { horizIndex = (width) + 1; }
	realIndex = (width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	if ((x) == 0) { horizIndex = (width) - 1; }
	else { horizIndex = (x) - 1; }
	realIndex = (width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	if ((y) == 0) { vertIndex = (height) - 1; }
	else { vertIndex = (y) - 1; }
	realIndex = (width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	if ((x) + 1 == (width)) { horizIndex = 0; }
	else { horizIndex = (width) + 1; }
	realIndex = (width) * vertIndex + horizIndex;
	if (board[realIndex]) count++;

	return count;
}

 __global__ void stepper(bool* board, bool* newBoard, int* width, int* height) {

	int x = blockIdx.x * blockDim.x + threadIdx.x;
	int y = blockIdx.y * blockDim.y + threadIdx.y;

	

	if (x < (*width) && y < (*height)) {
		int count = 0; int horizIndex, vertIndex, realIndex;

		vertIndex = (y);

		if ((x)+1 == (*width)) { horizIndex = 0; }
		else { horizIndex = (*width)+1; }
		realIndex = (*width)*vertIndex + horizIndex;
		if (board[realIndex]) count++;

		if ((x) == 0) { horizIndex = (*width)-1; }
		else { horizIndex = (x)-1; }
		realIndex = (*width)*vertIndex + horizIndex;
		if (board[realIndex]) count++;

		horizIndex = (x);

		if ((y)+1 == (*height)) { vertIndex = 0; }
		else { vertIndex = (*height)+1; }
		realIndex = (*width)*vertIndex + horizIndex;
		if (board[realIndex]) count++;

		if ((y) == 0) { vertIndex = (*height)-1; }
		else { vertIndex = (y)-1; }
		realIndex = (*width)*vertIndex + horizIndex;
		if (board[realIndex]) count++;

		if ((y)+1 == (*height)) { vertIndex = 0; }
		else { vertIndex = (*height)+1; }
		if ((x)+1 == (*width)) { horizIndex = 0; }
		else { horizIndex = (*width)+1; }
		realIndex = (*width)*vertIndex + horizIndex;
		if (board[realIndex]) count++;

		if ((x) == 0) { horizIndex = (*width)-1; }
		else { horizIndex = (x)-1; }
		realIndex = (*width)*vertIndex + horizIndex;
		if (board[realIndex]) count++;

		if ((y) == 0) { vertIndex = (*height)-1; }
		else { vertIndex = (y)-1; }
		realIndex = (*width)*vertIndex + horizIndex;
		if (board[realIndex]) count++;

		if ((x)+1 == (*width)) { horizIndex = 0; }
		else { horizIndex = (*width)+1; }
		realIndex = (*width)*vertIndex + horizIndex;
		if (board[realIndex]) count++;


		/*int neighborCount = horizCheck(board, *width, *height, x, y);
		neighborCount += vertCheck(board, *width, *height, x, y);
		neighborCount += cornerCheck(board, *width, *height, x, y);*/
		/*if (x < 12 && x > 8) { if (y < 12 && y > 8) { printf("X: %d Y: %d NeighborCount: %d\n", x, y, neighborCount); } }*/
		 realIndex = y * (*width) + x;
		bool cellState = board[realIndex];
		if (cellState && count < 2) { newBoard[realIndex] = false; }
		else if (cellState && count > 3) { newBoard[realIndex] = true; }
		else if (!cellState && count == 3) { newBoard[realIndex] = true; }
	}
}

GOL::GOL(int width, int height, bool* data) {
	this->width = width;
	this->height = height;
	size = sizeof(bool) * width * height;
	board = (bool *)malloc(size);
	//cudaMemcpy(board, data, size, cudaMemcpyHostToHost);
	cudaMemcpy(board, data, size, cudaMemcpyHostToHost);
}

void GOL::init() {
	cudaMalloc((void **)&d_board, size);
	cudaMalloc((void **)&d_boardNew, size);

	size = sizeof(int);
	cudaMalloc((void**)&d_width, size); cudaMalloc((void**)&d_height, size);
	cudaMemcpy(d_width, &width, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_height, &height, size, cudaMemcpyHostToDevice);


	size = sizeof(bool) * width * height;
	cudaMemcpy(&d_board, &board, size, cudaMemcpyHostToDevice);

	numBlockVert = height / threadHeight;
	if (height % threadHeight > 0) numBlockVert++;
	numBlockHoriz = width / threadWidth;
	if (height % threadWidth > 0) numBlockHoriz++;
}

bool GOL::step() {
	dim3 dimGrid(numBlockHoriz, numBlockVert);
	dim3 dimBlock(threadWidth, threadHeight);
	stepper << <dimGrid, dimBlock >> > (&d_board, &d_boardNew, d_width, d_height);
	
	cudaMemcpy(&d_board, &d_boardNew, size, cudaMemcpyDeviceToDevice);
	cudaMemcpy(board, &d_board, size, cudaMemcpyDeviceToHost);
	cudaDeviceSynchronize();
	return true;
}

GOL::~GOL() {
	cudaFree(&d_board); cudaFree(&d_boardNew);
	cudaFree(&d_width); cudaFree(&d_height);
}