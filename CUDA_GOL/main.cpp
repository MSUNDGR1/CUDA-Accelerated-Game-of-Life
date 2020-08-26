#include <iostream>
#include <fstream>
//#include <Windows.h>
#include "GOL_runner.cuh"


bool* fileRead(std::string fileName, int& width, int& height, int& numFills) {
	std::ifstream reader;
	reader.open(fileName);
	if (reader.is_open()) {
		reader >> width;
		reader >> height;
		reader >> numFills;
		int x, y;
		int readCount = 0;
		int index;
		int boolNum = height * width;
		bool* data = new bool[boolNum];
		while (readCount < numFills) {
			reader >> x; reader >> y;
			index = (y * width) + x;
			data[index] = true;
		}
		reader.close();
		return data;
	}
	else return nullptr;
}


void iterate(int numsteps, GOL& board);

int main() {
	std::string fileName = "test.txt";
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
		output = "";
		for (int h = 0; h < board.height; h++) {
			for (int w = 0; w < board.width; w++) {
				index = board.width * h + w;
				if (board.board[index] == true) output += "*";
				else output += "_";
			}
			std::cout << output << std::endl;
		}
		board.step();
	}
}