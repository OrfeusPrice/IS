#ifndef HEADERSTAR
#define HEADERSTAR
#pragma once
#include <iostream>
#include <algorithm>
#include <unordered_map>
#include <chrono>
#include <array>
#include <vector>
#include <stack>
#include <string>
#include <queue>
#include <set>

using namespace std;
using namespace std::chrono;


const int X = 15;
const string str = "LDRU";

typedef unsigned long long HT; // HashTable

inline bool IsValid(int r, int c) {
	return 0 <= r && r < 4 && 0 <= c && c < 4;
}

struct Node {
	string curState; 
	pair<int, int> blank;
	void BuildState(string input) {
		curState = input;
		for (int i = 0; i < 16; ++i) {
			if (curState[i] >= 'A' && curState[i] <= 'F') {
				curState[i] = curState[i] - 'A' + 10;
			}
			else if (curState[i] >= '0' && curState[i] <= '9') {
				curState[i] = curState[i] - '0';
			}
			if (!curState[i]) {
				blank = make_pair(i / 4, i % 4);
				curState[i] = X;
			}
			else {
				curState[i]--;
			}
		}
	}

	bool IsSolvable() const {
		int sum = 0;
		for (int i = 0; i < 16; i++)
			for (int j = 0; j < i; j++)
				if (curState[i] != X && curState[j] != X && curState[j] > curState[i])
					sum++;
		sum += blank.first;
		return sum % 2 != 0;
	}
	bool IsGoalState() const {
		return is_sorted(curState.begin(), curState.end());
	}
	int Heuristic() const {
		int ans = 0;
		for (int i = 0; i < 16; i++) {
			int i1 = curState[i] / 4, j1 = curState[i] % 4;
			if (curState[i] != X)
				ans += abs(i / 4 - i1) + abs(i % 4 - j1); // Manhattan distance
		}
		return ans;
	}
	HT ToHT() {
		HT res = 0;
		for (int i = 0; i < 16; ++i) {
			res <<= 4;  //  Сдвиг влево на 4 бита
			res |= curState[i];  //  Использование оператора "ИЛИ" для побитового соединения
		}
		return res;
	}
};

struct CompareA {
	Node st;
	int movesCount;
	int dir;
	bool operator<(const CompareA& elem) const {
		if (this->st.Heuristic() + movesCount == elem.st.Heuristic() + elem.movesCount) {
			return movesCount > elem.movesCount; 
		}
		else {
			return this->st.Heuristic() + movesCount > elem.st.Heuristic() + elem.movesCount;
		}
	}

	CompareA(const Node& st, int movesCount, int dir) {
		this->st = st;
		this->movesCount = movesCount;
		this->dir = dir;
	}
};

bool AStarOptim(Node& start, unordered_map<int, int>& path, const vector<pair<char, char>>& directions, string& solution) {
	priority_queue<CompareA> openList;
	set<HT> closedList;
	openList.push(CompareA(start, 0, -1));

	while (!openList.empty()) {
		CompareA current = openList.top();
		openList.pop();

		HT hash = current.st.ToHT();
		if (closedList.count(hash)) continue;

		if (current.st.IsGoalState()) {
			solution = "";
			int movesCount = current.movesCount;
			while (movesCount > 0) {
				solution = str[path[movesCount]] + solution;
				movesCount--;
			}
			return true;
		}

		closedList.insert(hash);

		char i = current.st.blank.first, j = current.st.blank.second;
		for (int d = 0; d < 4; ++d) {
			int new_i = i + directions[d].first, new_j = j + directions[d].second;
			if (IsValid(new_i, new_j) && (current.dir == -1 || (current.dir + 2) % 4 != d)) {
				Node new_st = current.st;
				swap(new_st.curState[i * 4 + j], new_st.curState[new_i * 4 + new_j]);
				new_st.blank = make_pair(new_i, new_j);

				int newMC = current.movesCount + 1;
				path[newMC + 1] = d;

				openList.push(CompareA(new_st, newMC, d));
			}
		}
	}
	return false;
}


bool DeepSearch(Node& st, int movesCount, int dir, int lim, int& nlim, unordered_map<HT, int>& visited, unordered_map<int, int>& path, const vector<pair<char, char>>& directions) {
	if (movesCount + st.Heuristic() > lim) {
		nlim = min(nlim, movesCount + st.Heuristic());
		return false;
	}
	if (st.IsGoalState())
		return true;
	HT hash = st.ToHT();
	if (visited.count(hash) && visited[hash] <= movesCount) {
		return false;
	}
	visited[hash] = movesCount;
	char i = st.blank.first, j = st.blank.second;
	for (int d = 0; d < 4; ++d) {
		int new_i = i + directions[d].first, new_j = j + directions[d].second;
		if (IsValid(new_i, new_j) && (dir == -1 || (dir + 2) % 4 != d)) {
			Node new_st = st;
			swap(new_st.curState[i * 4 + j], new_st.curState[new_i * 4 + new_j]);
			new_st.blank = make_pair(new_i, new_j);
			path[movesCount + 1] = d;
			if (DeepSearch(new_st, movesCount + 1, d, lim, nlim, visited, path, directions))
				return true;
		}
	}
	return false;
}

int IDAStar(Node& start, unordered_map<HT, int>& visited, unordered_map<int, int>& path, const vector<pair<char, char>>& directions) {
	int lim = start.Heuristic();
	while (true) {
		int nlim = INT_MAX;
		path.clear();
		visited.clear();
		if (DeepSearch(start, 0, -1, lim, nlim, visited, path, directions))
			return lim;
		if (nlim == INT_MAX)
			return -1;
		lim = nlim;
	}
}

void StartStar();

#endif