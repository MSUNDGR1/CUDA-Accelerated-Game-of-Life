#include <iostream>
#include <stdlib.h>
#include <fstream>
#include <Windows.h>
#include "GOL_runner.cuh"


bool* fileRead(std::string fileName, int& width, int& height, int& numFills) {
	std::ifstream file(fileName.c_str(), std::ios::in);
	
	if (file.is_open()) {
		char intBuff[4];
		file >> width;
		file >> height;
		file >> numFills;
		
		
		int x, y;
		int readCount = 0;
		int index;
		int boolNum = height * width;
		std::cout << "Set up reads, datSize: " << boolNum << std::endl;
		bool* data = new bool[boolNum]();
		std::cout << "Data alloc" << std::endl;
		while (readCount < numFills) {
			file >> x; file >> y;
			//file.read(intBuff, 4);
			//x = *((int*)intBuff);
			//file.read(intBuff, 4);
			//y = *((int*)intBuff);
			index = (y * width) + x;
			data[index] = true;
			readCount++;
		}
		file.close();
		return data;
	}
	else return nullptr;
}


void iterate(int numsteps, GOL& board);

int main() {
	std::string fileName = "glider.txt";
	int width, height, numFills;
	bool* data = fileRead(fileName, width, height, numFills);
	std::cout << "File Read" << std::endl;
	if (data == nullptr) return -1;
	GOL board(width, height, data);
	board.init();
	int numSteps = 0;
	while (numSteps != -1) {
		std::cout << "Enter number of steps to iterate over: ";
		std::cin >> numSteps;
		iterate(numSteps, board);

	}
	delete(&board);
}

void iterate(int numsteps, GOL& board) {
	std::string output;
	int index;
	for (int i = 0; i < numsteps; i++) {
		system("CLS");
		//if (board.board[198])std::cout << "Filled at center, cpp" << std::endl;
		for (int h = 0; h < board.height; h++) {
			output = "";
			for (int w = 0; w < board.width; w++) {
				index = board.width * h + w;
				if (board.board[index] == true) { output += "*"; }
				else output += "_";
			}
			std::cout << output << std::endl;
		}
		board.step();
		Sleep(80);
		
	}
}