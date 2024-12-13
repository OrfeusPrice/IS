#ifndef HEADER
#define HEADER
#pragma once


#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <queue>
#include <map>
#include <stack>
#include <cstdlib>
#include <chrono>
#include <deque>

using namespace std;
using namespace std::chrono;

const string goalState = "123456789ABCDEF0";

struct State {
	string order;
	string moves;
	int heuristic;

	char GetLast() {
		return moves[moves.length() - 1];
	}
	char GetLastSecond() {
		return moves[moves.length() - 2];
	}

	bool IsUseless() {
		switch (GetLast())
		{
		case 'U':
			if (GetLastSecond() == 'D') return true;
			return false;
			break;
		case 'D':
			if (GetLastSecond() == 'U') return true;
			return false;
			break;
		case 'R':
			if (GetLastSecond() == 'L') return true;
			return false;
			break;
		case 'L':
			if (GetLastSecond() == 'R') return true;
			return false;
			break;
		default:
			return false;
			break;
		}
	}
	int GetMovesNum() {
		return moves.length();
	}
	size_t GetCost() {
		return GetMovesNum() + heuristic;
	}
};

class CompareStates {
public:
	bool operator()(const State& a, const State& b) {
		return (a.heuristic + a.moves.length()) > (b.heuristic + b.moves.length());
	}
};


bool checkGoalState(State);

string performMove(string, int, int);

State DFS(State, int);

State IDS(State);

bool checkSolvable(State);

State BFS(State);

int ManhattanDistance(const State&);

int Heuristic(const State&);

#endif