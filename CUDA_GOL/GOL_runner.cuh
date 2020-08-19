#ifndef GOL_RUNNER_H
#define GOL_RUNNER_H
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <cstdlib>



class GOL {
	public:
		GOL(int width, int height, bool* data);
		bool step();
		~GOL();
	private:
		int* width, d_width;
		int* height, d_height;
		unsigned char** vertPart, d_vertPart;
		unsigned char** horzPart, d_horzPart;
		bool* board, d_board;
};
#endif