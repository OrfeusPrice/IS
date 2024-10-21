#include "pch.h"
#include "Header.h"



void MakeMove(Board& b, int c, int p) {
	for (int r = 0; r < ROW; r++) {
		if (b.G[r][c] == 0) {
			b.G[r][c] = p;
			break;
		}
	}
}

pair<int, int> MiniMax(Board& b, int d, int alf, int bet, int p) {
	if (d == 0 || d >= (COL * ROW) - TURNS)
		return { Score(b, AI), -1 };
	if (IsWin(b, p == AI ? PLAYER : AI))
		return { (p == AI ? INT_MIN : INT_MAX), -1 };

	pair<int, int> bestMove = { p == AI ? INT_MIN : INT_MAX, -1 };
	for (int c = 0; c < COL; c++)
		if (b.G[ROW - 1][c] == 0) {
			Board newBoard = CloneBoard(b);
			MakeMove(newBoard, c, p);
			int score = MiniMax(newBoard, d - 1, alf, bet, p == AI ? PLAYER : AI).first;
			bestMove = (p == AI ? score > bestMove.first : score < bestMove.first) ? pair<int, int>{score, (int)c} : bestMove;
			if (p == AI)
				alf = max(alf, bestMove.first);
			else
				bet = min(bet, bestMove.first);
			if (alf >= bet)  break;
		}
	return bestMove;
}


int Score(Board b, int p) {
	int score = 0;
	for (int r = 0; r < ROW; r++) {
		for (int c = 0; c < COL - 3; c++) {
			score += ScoreSet({ b.G[r][c], b.G[r][c + 1], b.G[r][c + 2], b.G[r][c + 3] }, p);
		}
	}
	for (int c = 0; c < COL; c++) {
		for (int r = 0; r < ROW - 3; r++) {
			score += ScoreSet({ b.G[r][c], b.G[r + 1][c], b.G[r + 2][c], b.G[r + 3][c] }, p);
		}
	}
	for (int r = 0; r < ROW - 3; r++) {
		for (int c = 0; c < COL - 3; c++) {
			score += ScoreSet({ b.G[r][c], b.G[r + 1][c + 1], b.G[r + 2][c + 2], b.G[r + 3][c + 3] }, p);
		}
	}
	for (int r = 3; r < ROW; r++) {
		for (int c = 0; c < COL - 3; c++) {
			score += ScoreSet({ b.G[r][c], b.G[r - 1][c + 1], b.G[r - 2][c + 2], b.G[r - 3][c + 3] }, p);
		}
	}
	return score;
}

int ScoreSet(vector<int> v, int p) {
	int good = 0, bad = 0, empty = 0;
	for (int i = 0; i < v.size(); i++)
		if (v[i] == p) good++;
		else if (v[i] != 0) bad++;
		else empty++;

	return Heurisctic(good, bad, empty);
}

int Heurisctic(int g, int b, int e) {
	//Стратегия, при которой ИИ будет стремиться к "4 в ряд" в свою пользу сильнее, чем мешать игроку собрать 4 в ряд.
	//Иначе будет стремиться мешать игроку собрать 2 и 3 сильнее, чем самому собрать 2 и 3.
	return ScorePos(g, e) + ScoreNeg(b, e);
}

int ScorePos(int g, int e) {
	switch (g) {
	case 4: return 1001;
	case 3: return (e == 1) ? 100 : 0;
	case 2: return (e == 2) ? 10 : 0;
	default: return 0;
	}
}

int ScoreNeg(int b, int e) {
	switch (b) {
	case 2: return (e == 2) ? -11 : 0;
	case 3: return (e == 1) ? -101 : 0;
	case 4: return -1000;
	default: return 0;
	}
}

bool IsWin(Board& b, int p) {
	for (int r = 0; r < ROW; r++) {
		for (int c = 0; c < COL - 3; c++) {
			if (b.G[r][c] == p && b.G[r][c + 1] == p && b.G[r][c + 2] == p && b.G[r][c + 3] == p) {
				return true;
			}
		}
	}
	for (int c = 0; c < COL; c++) {
		for (int r = 0; r < ROW - 3; r++) {
			if (b.G[r][c] == p && b.G[r + 1][c] == p && b.G[r + 2][c] == p && b.G[r + 3][c] == p) {
				return true;
			}
		}
	}
	for (int r = 0; r < ROW - 3; r++) {
		for (int c = 0; c < COL - 3; c++) {
			if (b.G[r][c] == p && b.G[r + 1][c + 1] == p && b.G[r + 2][c + 2] == p && b.G[r + 3][c + 3] == p) {
				return true;
			}
		}
	}
	for (int r = 3; r < ROW; r++) {
		for (int c = 0; c < COL - 3; c++) {
			if (b.G[r][c] == p && b.G[r - 1][c + 1] == p && b.G[r - 2][c + 2] == p && b.G[r - 3][c + 3] == p) {
				return true;
			}
		}
	}
	return false;
}

Board CloneBoard(Board b) {
	Board newBoard;
	for (int r = 0; r < ROW; r++) {
		for (int c = 0; c < COL; c++) {
			newBoard.G[r][c] = b.G[r][c];
		}
	}
	return newBoard;
}

void ChangeExternBoard(int* extboard) {
	for (int r = 0; r < ROW; r++) {
		for (int c = 0; c < COL; c++) {
			extboard[r * COL + c] = board.G[r][c];
		}
	}
}

extern "C" __declspec(dllexport) int Move(int move, int* extboard, int player) {
	for (int r = 0; r < ROW; r++) {
		for (int c = 0; c < COL; c++) {
			board.G[r][c] = extboard[r * COL + c];
		}
	}

	if (player == 1) {
		MakeMove(board, move, PLAYER);
		TURNS++;
		ChangeExternBoard(extboard);
		if (IsWin(board, PLAYER)) return 1; // Победил игрок
	}

	if (player == 2) {
		MakeMove(board, MiniMax(board, MAX_DEPTH, INT_MIN, INT_MAX, AI).second, AI);
		TURNS++;
		ChangeExternBoard(extboard);
		if (IsWin(board, AI)) return 2; // Победил компьютер
	}

	if (TURNS == ROW * COL) {
		return 3; // Ничья
	}

	return 0;
}
