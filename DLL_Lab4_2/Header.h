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

struct Board {
	array<array<int, 7>, 6> G; //Grid
};

int COL = 7;
int ROW = 6;
int PLAYER = 1;
int AI = 2;
int MAX_DEPTH = 5;
int TURNS = 0;
Board board;

void MakeMove(Board&, int, int);
pair<int, int> MiniMax(Board&, int, int, int, int);
int Score(Board, int);
int ScoreSet(vector<int>, int);
int Heurisctic(int, int, int);
int ScorePos(int, int);
int ScoreNeg(int, int);
bool IsWin(Board&, int);
Board CopyBoard(Board);

#endif //HEADER