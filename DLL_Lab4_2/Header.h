#pragma once
#ifndef HEADER_H
#define HEADER_H

#include <stdio.h>
#include <iostream>
#include <vector>
#include <limits.h>
#include <array>
#include <sstream>


using namespace std;

unsigned int COL = 7;
unsigned int ROW = 6;
unsigned int PLAYER = 1;
unsigned int AI = 2;
unsigned int MAX_DEPTH = 5;
unsigned int TURNS = 0;

vector<vector<int>> board(ROW, vector<int>(COL));

void MakeMove(vector<vector<int>>&, int, unsigned int);
int AiMove();
pair<int, int> MiniMax(vector<vector<int>>&, unsigned int, int, int, unsigned int);
int TabScore(vector<vector<int>>, unsigned int);
int ScoreSet(vector<int>, unsigned int);
int Heurisctic(unsigned int, unsigned int, unsigned int);
bool IsWin(vector<vector<int>>&, unsigned int);
vector<vector<int>> CloneBoard(vector<vector<int>>);

#endif //HEADER