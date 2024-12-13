#include "tasks.hpp"

deque<State> _dq;
unordered_set<int> _visited;
int _count_steps = 0;
State _cur;

void Test(int start, int finish, pair<int, int> function(int, int))
{
	cout << "Start: " << start << ", Finish: " << finish << endl;
	auto startTime = high_resolution_clock::now();
	auto result = function(start, finish);
	auto endTime = high_resolution_clock::now();
	auto duration = duration_cast<microseconds>(endTime - startTime);
	cout << "Время: " << duration.count() / 1000.0 << " мс ";
	cout << "Количество операций: " << result.first << " ";
	cout << "Узлов рассмотрено: " << result.second << endl;
}

void PushIfGoodValue_1_2(int next, int start, int finish) {
	if (_visited.find(next) == _visited.end() && next <= finish) {
		_visited.insert(next);
		_dq.push_back({ next, _cur.step + 1 });
	}
};

void PushIfGoodValue_3(int next, int start, int finish) {
	if (next >= start && _visited.find(next) == _visited.end()) {
		_visited.insert(next);
		_dq.push_back({ next, _cur.step + 1 });
	}
};

pair<int, int> Task1(int start, int finish)
{
	_dq.clear();
	_visited.clear();
	_count_steps = 0;
	_dq.push_back({ start, 0 });
	_visited.insert(start);

	while (!_dq.empty()) {
		_cur = _dq.front();
		_dq.pop_front();
		_count_steps++;

		if (_cur.value == finish) {
			return { _cur.step, _count_steps };
		}

		PushIfGoodValue_1_2(_cur.value + 3, start, finish);
		PushIfGoodValue_1_2(_cur.value << 1, start, finish);
	}
	return { -1, _count_steps };
}
pair<int, int> Task2(int start, int finish)
{
	_dq.clear();
	_visited.clear();
	_count_steps = 0;
	_dq.push_back({ start, 0 });
	_visited.insert(start);

	while (!_dq.empty()) {
		_cur = _dq.front();
		_dq.pop_front();
		_count_steps++;

		if (_cur.value == finish) {
			return { _cur.step, _count_steps };
		}

		PushIfGoodValue_1_2(_cur.value + 3, start, finish);
		PushIfGoodValue_1_2(_cur.value << 1, start, finish);
		PushIfGoodValue_1_2(_cur.value - 2, start, finish);
	}
	return { -1, _count_steps };
}

pair<int, int> Task3(int start, int finish) {
	_dq.clear();
	_visited.clear();
	_count_steps = 0;
	_dq.push_back({ finish, 0 });
	_visited.insert(finish);

	while (!_dq.empty()) {
		_cur = _dq.front();
		_dq.pop_front();
		_count_steps++;

		if (_cur.value == start) {
			return { _cur.step, _count_steps };
		}

		if (_cur.value % 2 == 0)
			PushIfGoodValue_3(_cur.value >> 1, start, finish);

		PushIfGoodValue_3(_cur.value - 3, start, finish);
	}

	return { -1, _count_steps };
}

pair<int, int> Task4(int start, int finish) {
	deque<State> front_dq, back_dq;
	State front_cur, back_cur;
	unordered_map<int, int> front_dist, back_dist;
	_count_steps = 0;

	front_dq.push_back({ start, 0 });
	back_dq.push_back({ finish, 0 });
	front_dist[start] = 0;
	back_dist[finish] = 0;

	while (!front_dq.empty() && !back_dq.empty()) {
		_count_steps++;

		front_cur = front_dq.front();
		front_dq.pop_front();

		if (back_dist.find(front_cur.value) != back_dist.end()) {
			return { front_cur.step + back_dist[front_cur.value], _count_steps };
		}

		int next = front_cur.value * 2;
		if (front_dist.find(next) == front_dist.end() && next <= finish) {
			front_dist[next] = front_cur.step + 1;
			front_dq.push_back({ next, front_cur.step + 1 });
		}

		next = front_cur.value + 3;
		if (front_dist.find(next) == front_dist.end() && next <= finish) {
			front_dist[next] = front_cur.step + 1;
			front_dq.push_back({ next, front_cur.step + 1 });
		}


		back_cur = back_dq.front();
		back_dq.pop_front();

		if (front_dist.find(back_cur.value) != front_dist.end()) {
			return { back_cur.step + front_dist[back_cur.value], _count_steps };
		}

		if (back_cur.value % 2 == 0) {
			next = back_cur.value / 2;
			if (back_dist.find(next) == back_dist.end() && next >= start) {
				back_dist[next] = back_cur.step + 1;
				back_dq.push_back({ next, back_cur.step + 1 });
			}
		}

		next = back_cur.value - 3;
		if (back_dist.find(next) == back_dist.end() && next >= start) {
			back_dist[next] = back_cur.step + 1;
			back_dq.push_back({ next, back_cur.step + 1 });
		}
	}
	return { -1, _count_steps };
}