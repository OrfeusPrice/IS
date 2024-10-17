#pragma once
#ifndef HEADER
#define HEADER
#define MIN(a,b) (((a) < (b)) ? (a) : (b))
#define MAX(a,b) (((a) > (b)) ? (a) : (b))
#include <iostream>
#include <vector>
#include <limits.h>
#include <array>
#include <sstream>

using namespace std;

void displayBoard(vector<vector<int>>& board);
int getUserInput();
void executeMove(vector<vector<int>>& board, int col, unsigned int player);
void handleErrors(int errorCode);
int computeAiMove();
vector<vector<int>> cloneBoard(vector<vector<int>> board);
bool checkWin(vector<vector<int>>& board, unsigned int player);
int calculateScore(vector<unsigned int> row, unsigned int player);
int evaluateBoard(vector<vector<int>> board, unsigned int player);
array<int, 2> performMinimax(vector<vector<int>>& board, unsigned int depth, int alpha, int beta, unsigned int player);
int heuristicEvaluation(unsigned int good, unsigned int bad, unsigned int empty);

unsigned int COLS = 7;
unsigned int ROWS = 6;
unsigned int HUMAN = 1;
unsigned int AI = 2;
unsigned int MAX_DEPTH = 5;

bool gameEnded = false;
unsigned int turnCount = 0;
unsigned int currentPlayer = HUMAN;

vector<vector<int>> gameBoard(ROWS, vector<int>(COLS));


#endif // !HEADER
