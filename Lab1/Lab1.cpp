#include "tasks.hpp"

int main()
{
	setlocale(0, "");
	vector<pair<int, int>> v = { {1, 100}, {2, 55}, {2, 100},
	{1, 97}, {2, 1000}, {2, 800000}, { 2, 10000001 } };

	for (pair<int, int> p : v)
	{
		int start = p.first;
		int finish = p.second;

		cout << "Task#1 \n";
		Test(start, finish, Task1);
		cout << "\nTask#2 \n";
		Test(start, finish, Task2);
		cout << "\nTask#3 \n";
		Test(start, finish, Task3);
		cout << "\nTask#4 \n";
		Test(start, finish, Task4);

		cout << "_____________________________________________" << endl;
	}

	cout << "Введите начальное и конечное число: " << endl;
	int start, finish;
	cin >> start >> finish;
	cout << "Task#1	\n";
	Test(start, finish, Task1);
	cout << "\nTask#2	\n";
	Test(start, finish, Task2);
	cout << "\nTask#3	\n";
	Test(start, finish, Task3);
	cout << "\nTask#4	\n";
	Test(start, finish, Task4);
}


