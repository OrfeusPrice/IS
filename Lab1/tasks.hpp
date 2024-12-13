#ifndef TaskS
#define TaskS

#include <iostream>
#include <deque>
#include <queue>
#include <set>
#include <unordered_map>
#include <unordered_set>
#include <chrono>

using namespace std;
using namespace std::chrono;

struct State
{
	int value;
	int step;
};

pair<int, int> Task1(int start, int finish);
pair<int, int> Task2(int start, int finish);
pair<int, int> Task3(int start, int finish);
pair<int, int> Task4(int start, int finish);
void Test(int start, int finish, pair<int,int> function(int, int));

#endif