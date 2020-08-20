#include <iostream>
#include <fstream>
#include <Windows.h>

bool fileRead(std::string fileName, int& width, int& height, int& numFills, bool* data) {
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
		data = new bool[boolNum];
		while (readCount < numFills) {
			reader >> x; reader >> y;
			index = (y * width) + x;
			data[index] = true;
		}
		reader.close();
		return true;
	}
	else return false;
}


int main() {

}