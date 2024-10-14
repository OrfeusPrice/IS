#include <iostream>
#include <bitset>
#include <queue>
#include <unordered_set>
#include <vector>
#include <cmath>
#include <chrono>

using namespace std;
using namespace chrono;

const int BOARD = 4;
const int Y = 2;
const int X = 2;
const vector<pair<int, int>> D = { {-1, 0}, {1, 0}, {0, -1}, {0, 1} };

const int BOARD_BITS = BOARD * BOARD * 2;

using BoardState = bitset<BOARD_BITS>;

struct State {
	BoardState board;
	int mc; //move count
	int h; //heuristic

	int index = -1;
};

struct QueueElement {
	int stateIndex;
	int mc;
	int h;

	bool operator<(const QueueElement& other) const {
		return mc != other.mc ? mc > other.mc : h > other.h;
	}
};

vector<State> states;
//deque<State> states;
priority_queue<QueueElement> open_set;

bool IsEmpty(const BoardState& board, int x, int y) {
	int index = (x * BOARD + y) * 2;
	int cell = (board[index + 1] << 1) | board[index];
	return cell == 0;
}

int GetCell(const BoardState& board, int x, int y) {
	return (board[(x * BOARD + y) * 2 + 1] << 1) | board[(x * BOARD + y) * 2];
}


void SetCell(BoardState& board, int x, int y, int value) {
	int index = (x * BOARD + y) * 2;
	board[index] = (value & 1);
	board[index + 1] = (value >> 1);
}

void InitBoards(BoardState& board, BoardState& goal) {
	for (int x = 0; x < Y; ++x) {
		for (int y = 0; y < X; ++y) {
			SetCell(board, x, y, 1);
			SetCell(goal, x, y, 2);
		}
	}
	for (int x = BOARD - Y; x < BOARD; ++x) {
		for (int y = BOARD - X; y < BOARD; ++y) {
			SetCell(board, x, y, 2);
			SetCell(goal, x, y, 1);
		}
	}
}

bool IsWithinBounds(int x, int y) {
	return x >= 0 && x < BOARD && y >= 0 && y < BOARD;
}

void PrintBoard(const BoardState& board) {
	for (int x = 0; x < BOARD; ++x) {
		for (int y = 0; y < BOARD; ++y) {
			int index = (x * BOARD + y) * 2;
			int cell = (board[index + 1] << 1) | board[index];
			if (cell == 1) {
				cout << "1 ";
			}
			else if (cell == 2) {
				cout << "2 ";
			}
			else {
				cout << "* ";
			}
		}
		cout << endl;
	}
	cout << endl;
}

int target_x, target_y;

int Heuristic(const BoardState& board) {
	int h = 0;
	int bX = BOARD - X - 1;
	int bY = BOARD - Y - 1;
	int wX = BOARD - X;
	int wY = BOARD - Y;
	int cell;

	for (int x = 0; x < BOARD; ++x) {
		for (int y = 0; y < BOARD; ++y) {
			cell = GetCell(board, x, y);
			if (cell == 0) continue;
			if (cell == 1 && (x < wX || y < wY)) {
				target_x = 2;
				target_y = 2;
				if (GetCell(board, target_x + 1, target_y + 1) == 0)h += target_x - x + target_y - y;
				else if (GetCell(board, target_x + 1, target_y) == 0)h += target_x - x + target_y - y + 1;
				else if (GetCell(board, target_x, target_y + 1) == 0)h += target_x - x + target_y - y + 1;
				else if (GetCell(board, target_x, target_y) == 0)h += target_x - x + target_y - y + 2;
				else if (GetCell(board, target_x, target_y) == 2) h += 2; //Если на этом месте стоит другая шашка И она другого цвета, надо сделать 2 лишних хода (убрать, поставить)
			}
			else if (cell == 2 && (x > bX || y > bY)) {
				target_x = 0;
				target_y = 0;
				if (GetCell(board, target_x + 1, target_y + 2) == 0)h += target_x - x + target_y - y ;
				else if (GetCell(board, target_x + 1, target_y) == 0)h += target_x - x + target_y - y + 1;
				else if (GetCell(board, target_x, target_y + 1) == 0)h += target_x - x + target_y - y + 1;
				else if (GetCell(board, target_x, target_y) == 0)h += target_x - x + target_y - y + 2;
				else if (GetCell(board, target_x, target_y) == 1) h += 2;
			}
		}

		return h;
	}
}
void PrintStep(int curr, int depth) {
	if (states[curr].index == -1) return;

	PrintStep(states[curr].index, depth - 1);

	cout << "Ход " << depth << ":\n";
	PrintBoard(states[curr].board);
}

void AStar(BoardState start, BoardState goal) {
	high_resolution_clock::time_point start_time, finish_time;
	start_time = high_resolution_clock::now();

	unordered_set<BoardState> visited;

	State start_state{ start, 0, Heuristic(start), -1 };
	states.push_back(start_state);
	open_set.push(QueueElement{ 0, 0, start_state.h });
	visited.insert(start);

	int size = 1;

	while (!open_set.empty()) {
		int ind = open_set.top().stateIndex;
		State current = states[ind];
		open_set.pop();

		if (current.board == goal) {
			finish_time = high_resolution_clock::now();
			auto duration = chrono::duration_cast<chrono::milliseconds>(finish_time - start_time).count() / 1000.0;

			cout << "Время: " << duration << " сек\n";
			cout << "Кол-во ходов: " << current.mc << endl;
			states.push_back(current);
			PrintStep(states.size() - 1, states.back().mc);
			return;
		}

		for (int x = 0; x < BOARD; ++x) {
			for (int y = 0; y < BOARD; ++y) {
				int cell = GetCell(current.board, x, y);
				if (cell != 0) {
					BoardState new_board;
					for (auto [dx, dy] : D) {
						if (IsWithinBounds(x + dx, y + dy) && IsEmpty(current.board, x + dx, y + dy)) {
							new_board = current.board;
							SetCell(new_board, x, y, 0);
							SetCell(new_board, x + dx, y + dy, cell);

							if (visited.find(new_board) == visited.end()) {
								visited.insert(new_board);
								int h = Heuristic(new_board);
								states.push_back(State{ new_board, current.mc + 1, h, ind });
								open_set.push(QueueElement{ size++, current.mc + 1, h });
							}
						}
						if (IsWithinBounds(x + 2 * dx, y + 2 * dy) && !IsEmpty(current.board, x + dx, y + dy) && IsEmpty(current.board, x + 2 * dx, y + 2 * dy)) {
							new_board = current.board;
							SetCell(new_board, x, y, 0);
							SetCell(new_board, x + 2 * dx, y + 2 * dy, cell);

							if (visited.find(new_board) == visited.end()) {
								visited.insert(new_board);
								int h = Heuristic(new_board);
								states.push_back(State{ new_board, current.mc + 1, h, ind });
								open_set.push(QueueElement{ size++, current.mc + 1, h });
							}
						}
					}
				}
			}
		}
	}

	cout << "Решение не найдено" << endl;
}

int main() {
	setlocale(0, "");
	BoardState board, goal;
	InitBoards(board, goal);
	PrintBoard(board);

	AStar(board, goal);
	return 0;
}
