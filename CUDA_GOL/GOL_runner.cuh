#ifndef GOL_RUNNER_H
#define GOL_RUNNER_H
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <cstdlib>



class GOL {
	public:
		GOL(int width, int height, bool* data);
		void init();
		bool step();
		int width; int* d_width;
		int height; int* d_height;
		bool* board, d_board, d_boardNew;
		~GOL();
	private:
		
		int size, numBlockVert, numBlockHoriz;

};
#endif