#include "Header.h" 
#include "HeaderStar.h" 

int nodeCount = 0;
int blank_pos;


bool checkGoalState(State a) {
	return (a.order.compare(goalState) == 0);
}

bool checkSolvable(State startState)
{
	int inversions = 0;
	for (int i = 0; i < 15; i++)
	{
		for (int j = i + 1; j < 16; j++)
		{
			if (startState.order[j] != '0' && startState.order[i] != '0' && (startState.order[i] > startState.order[j]))
				inversions++;
		}
	}

	int row = 4 - (blank_pos / 4);
	if (row & 1)
		return !(inversions & 1);
	else
		return inversions & 1;
}

string performMove(string order, int x, int y) {
	string newState(order);
	string temp = newState.substr(x, 1);
	newState[x] = newState[y];
	newState[y] = temp[0];
	return newState;
}


// Поиск в ширину (BFS)
State BFS(State startState) {
	deque<State> rawStates;
	unordered_set<string> visited;
	rawStates.push_back(startState);
	visited.insert(startState.order);

	while (!rawStates.empty()) {
		State curState = rawStates.front();
		rawStates.pop_front();
		nodeCount += 1;

		if (checkGoalState(curState)) {
			return curState;
		}


		blank_pos = curState.order.find("0");


		if (blank_pos > 3) { // Движение вверх
			State newState;
			newState.order = performMove(curState.order, blank_pos, blank_pos - 4);
			newState.moves = curState.moves;
			newState.moves += 'U';
			if (visited.find(newState.order) == visited.end()) {
				visited.insert(newState.order);
				rawStates.push_back(newState);
			}
		}
		if (blank_pos < 12) { // Движение вниз
			State newState;
			newState.order = performMove(curState.order, blank_pos, blank_pos + 4);
			newState.moves = curState.moves;
			newState.moves += 'D';
			if (visited.find(newState.order) == visited.end()) {
				visited.insert(newState.order);
				rawStates.push_back(newState);
			}
		}
		if (blank_pos % 4 < 3) { // Движение вправо
			State newState;
			newState.order = performMove(curState.order, blank_pos, blank_pos + 1);
			newState.moves = curState.moves;
			newState.moves += 'R';
			if (visited.find(newState.order) == visited.end()) {
				visited.insert(newState.order);
				rawStates.push_back(newState);
			}
		}
		if (blank_pos % 4 > 0) { // Движение влево
			State newState;
			newState.order = performMove(curState.order, blank_pos, blank_pos - 1);
			newState.moves = curState.moves;
			newState.moves += 'L';
			if (visited.find(newState.order) == visited.end()) {
				visited.insert(newState.order);
				rawStates.push_back(newState);
			}
		}
	}
	return startState; // Возвращает начальное состояние, если не найдено решения
}

// Поиск в глубину
State DFS(State startState, int maxDepth = 100) {
	stack<State> rawStates;
	map<string, int> visited;
	rawStates.push(startState);

	while (rawStates.size() > 0) {

		State curState = rawStates.top();
		rawStates.pop();

		visited[curState.order] = curState.moves.length();
		nodeCount += 1;

		vector<State> nextStates;


		blank_pos = curState.order.find("0");

		if (blank_pos > 3) { // Движение вверх
			State newState;
			newState.moves = curState.moves + 'U';
			if (!newState.IsUseless()) {
				newState.order = performMove(curState.order, blank_pos, blank_pos - 4);
				nextStates.push_back(newState);
			}
		}
		if (blank_pos < 12) { // Движение вниз
			State newState;
			newState.moves = curState.moves + 'D';
			if (!newState.IsUseless()) {
				newState.order = performMove(curState.order, blank_pos, blank_pos + 4);
				nextStates.push_back(newState);
			}
		}
		if (blank_pos % 4 < 3) { // Движение вправо
			State newState;
			newState.moves = curState.moves + 'R';
			if (!newState.IsUseless()) {
				newState.order = performMove(curState.order, blank_pos, blank_pos + 1);
				nextStates.push_back(newState);
			}
		}
		if (blank_pos % 4 > 0) { // Движение влево
			State newState;
			newState.moves = curState.moves + 'L';
			if (!newState.IsUseless()) {
				newState.order = performMove(curState.order, blank_pos, blank_pos - 1);
				nextStates.push_back(newState);
			}
		}


		for (int i = 0; i < nextStates.size(); i++) {
			if (nextStates[i].moves.length() > maxDepth) { // Пропускает состояния, глубина которых превышает максимальную
				continue;
			}
			if (checkGoalState(nextStates[i])) {
				return nextStates[i];
			}
			if (visited.find(nextStates[i].order) != visited.end()
				&& visited[nextStates[i].order] < nextStates[i].moves.length()) { // Пропускает состояние, если оно было посещено с меньшим количеством ходов
				continue;
			}
			rawStates.push(nextStates[i]);
		}
	}
	return startState; // Возвращает начальное состояние, если не найдено решения
}

// Итеративный поиск в глубину
State IDS(State startState) {
	for (int i = 1; i < 84; i++) { // Повторяет для разных максимальных глубин поиска
		State searchResult = DFS(startState, i);
		if (checkGoalState(searchResult)) {
			return searchResult;
		}
	}

	return startState; // Возвращает начальное состояние, если не найдено решения
}

int ManhattanDistance(const State& state) {
	int distance = 0;
	for (int i = 0; i < 16; i++) {
		if (state.order[i] != '0') {
			int targetRow = (state.order[i] - '1') / 4; // Целевой ряд
			int targetCol = (state.order[i] - '1') % 4; // Целевой столбец
			int currentRow = i / 4; // Текущий ряд
			int currentCol = i % 4; // Текущий столбец
			distance += abs(currentRow - targetRow) + abs(currentCol - targetCol);
		}
	}
	return distance;
}

int Heuristic(const State& state) {
	return ManhattanDistance(state); 
}

// A* поиск
State AStar(State startState) {
	priority_queue<State, vector<State>, CompareStates> rawStates;
	unordered_set<string> visited;

	rawStates.push(startState);

	while (!rawStates.empty()) {
		State curState = rawStates.top();
		rawStates.pop();
		nodeCount += 1;

		if (checkGoalState(curState)) {
			return curState;
		}

		visited.insert(curState.order);

		blank_pos = curState.order.find("0");

		if (blank_pos % 4 < 3) {
			State newState;
			newState.moves = curState.moves + 'R';
			if (!newState.IsUseless()) {
				newState.order = performMove(curState.order, blank_pos, blank_pos + 1);
				newState.heuristic = Heuristic(newState);
				if (visited.find(newState.order) == visited.end()) {
					rawStates.push(newState);
				}
			}
		}
		if (blank_pos > 3) {
			State newState;
			newState.moves = curState.moves + 'U';
			if (!newState.IsUseless()) {
				newState.order = performMove(curState.order, blank_pos, blank_pos - 4);
				newState.heuristic = Heuristic(newState);
				if (visited.find(newState.order) == visited.end()) {
					rawStates.push(newState);
				}
			}
		}
		if (blank_pos % 4 > 0) {
			State newState;
			newState.moves = curState.moves + 'L';
			if (!newState.IsUseless()) {
				newState.order = performMove(curState.order, blank_pos, blank_pos - 1);
				newState.heuristic = Heuristic(newState);
				if (visited.find(newState.order) == visited.end()) {
					rawStates.push(newState);
				}
			}
		}
		if (blank_pos < 12) {
			State newState;
			newState.moves = curState.moves + 'D';
			if (!newState.IsUseless()) {
				newState.order = performMove(curState.order, blank_pos, blank_pos + 4);
				newState.heuristic = Heuristic(newState);
				if (visited.find(newState.order) == visited.end()) {
					rawStates.push(newState);
				}
			}
		}
	}

	return startState;
}

void StartStar() {
	vector<pair<char, char>> directions{ {0, 1}, {-1, 0}, {0, -1}, {1, 0} }; // LEFT, UP, RIGHT, DOWN 
	unordered_map<HT, int> visited;
	unordered_map<int, int> path;
	//string s = "51247308A6BE9FCD";//27
	//string s = "FE169B4C0A73D852";//52
	//string s = "D79F2E8A45106C3B";//55
	string s = "BAC0F478E19623D5";//61
	Node start;
	start.BuildState(s);
	if (!start.IsSolvable()) {
		cout << "Нерешаемо";
		return;
	}


	time_point<system_clock> startTime = system_clock::now();
	int searchResult = IDAStar(start, visited, path, directions);
	time_point<system_clock> endTime = system_clock::now();
	std::chrono::duration<double> runTime = endTime - startTime;
	cout << "IDA* Времени заняло: " << runTime.count() * 1000 << " ms" << endl;
	cout << "Ходов: " << searchResult << endl << "Ходы: ";
	while (searchResult != -1 && searchResult) {
		cout << str[path[searchResult--]];
	}
	

	/*string str = "";
	time_point<system_clock> startTime = system_clock::now();
	int searchResult = AStarOptim(start, path, directions, str);
	time_point<system_clock> endTime = system_clock::now();
	std::chrono::duration<double> runTime = endTime - startTime;
	cout << "A* Времени заняло: " << runTime.count() * 1000 << " ms" << endl;
	cout << "Ходов: " << str.length();
	cout << "\nРешение:" << str << endl;*/

	
}

void Start() {
	State startState;
	startState.moves = "  ";
	//startState.order = "1234067859ACDEBF";//5
	//startState.order = "16245A3709C8DEBF";//10
	//startState.order = "1723068459ACDEBF";//13
	startState.order = "12345678A0BE9FCD";//19
	//startState.order = "51247308A6BE9FCD";//27
	//startState.order = "F2345678A0BE91DC";//33
	//startState.order = "75123804A6BE9FCD";//35
	//startState.order = "04582E1DF79BCA36";//48
	//startState.order = "FE169B4C0A73D852";//52

	blank_pos = startState.order.find("0");

	if (!checkSolvable(startState))
	{
		cout << "Решения нет" << endl;
		return;
	}

	time_point<system_clock> startTime = system_clock::now();
	//State searchResult = BFS(startState); 
	//State searchResult = DFS(startState, 15);
	//State searchResult = IDS(startState); 
	State searchResult = AStar(startState); 

	time_point<system_clock> endTime = system_clock::now();
	std::chrono::duration<double> runTime = endTime - startTime;
	searchResult.moves.pop_back();
	searchResult.moves.pop_back();
	if (searchResult.order == startState.order && startState.order != goalState)
		cout << "Решение не найдено (но оно есть)\n";

	cout << "Перемещения: " << searchResult.moves << endl;
	cout << "Кол-во перемещений: " << searchResult.GetMovesNum() << endl;
	cout << "Число рассмотренных узлов: " << nodeCount << endl;
	cout << "Времени заняло: " << runTime.count() * 1000 << " ms" << endl;
	cout << "Памяти использовано: " << nodeCount * (16 + searchResult.moves.length()) << " байт" << endl;
}

int main(int argc, char* argv[]) {
	setlocale(0, "");

	//Start();
	StartStar();

	return 0;
}