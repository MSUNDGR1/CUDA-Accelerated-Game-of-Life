#ifndef GOL_RUNNER_H
#define GOL_RUNNER_H
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <cstdlib>



class GOL {
	public:
		GOL(int width, int height, bool* data);
		bool init();
		bool step(bool show, bool* output);
		~GOL();
	private:
		int width; int* d_width;
		int height; int * d_height;
		bool* board, d_board, d_boardNew;
		int size, numBlockVert, numBlockHoriz;
		bool initialized = false;
};
#endif