#include "GOL_runner.cuh"

GOL::GOL(int width, int height, bool* data) {
	this->width = new int(width);
	this->height = new int(height);
	int size = sizeof(bool) * width * height;
	this->board = (bool *)malloc(size);
	cudaMemcpy(this->board, data, size, cudaMemcpyHostToHost);

}