#include "pch.h"
#include "Header.h"

void MakeMove(vector<vector<int> >& b, int c, unsigned int p) {
	for (unsigned int r = 0; r < ROW; r++) {
		if (b[r][c] == 0) {
			b[r][c] = p;
			break;
		}
	}
}

int AiMove() {
	return MiniMax(board, MAX_DEPTH, INT_MIN, INT_MAX, AI).second;
}

pair<int, int> MiniMax(vector<vector<int> >& b, unsigned int d, int alf, int bet, unsigned int p) {
	if (d == 0 || d >= (COL * ROW) - TURNS) {
		return { TabScore(b, AI), -1 };
	}
	if (p == AI) {
		pair<int, int> bestMove = { INT_MIN, -1 };
		if (IsWin(b, PLAYER)) {
			return bestMove;
		}
		for (unsigned int c = 0; c < COL; c++) {
			if (b[ROW - 1][c] == 0) {
				vector<vector<int> > newBoard = CloneBoard(b);
				MakeMove(newBoard, c, p);
				int score = MiniMax(newBoard, d - 1, alf, bet, PLAYER).first;
				bestMove = (score > bestMove.first) ? pair<int, int>{score, (int)c} : bestMove;
				alf = max(alf, bestMove.first);
				if (alf >= bet) { break; }
			}
		}
		return bestMove;
	}
	else {
		pair<int, int> bestMove = { INT_MAX, -1 };
		if (IsWin(b, AI)) {
			return bestMove;
		}
		for (unsigned int c = 0; c < COL; c++) {
			if (b[ROW - 1][c] == 0) {
				vector<vector<int> > newBoard = CloneBoard(b);
				MakeMove(newBoard, c, p);
				int score = MiniMax(newBoard, d - 1, alf, bet, AI).first;
				bestMove = (score < bestMove.first) ? pair<int, int>{score, (int)c} : bestMove;
				bet = min(bet, bestMove.first);
				if (alf >= bet) { break; }
			}
		}
		return bestMove;
	}
}

int TabScore(vector<vector<int> > b, unsigned int p) {
	int score = 0;
	for (unsigned int r = 0; r < ROW; r++) {
		for (unsigned int c = 0; c < COL - 3; c++) {
			score += ScoreSet({ b[r][c], b[r][c + 1], b[r][c + 2], b[r][c + 3] }, p);
		}
	}
	for (unsigned int c = 0; c < COL; c++) {
		for (unsigned int r = 0; r < ROW - 3; r++) {
			score += ScoreSet({ b[r][c], b[r + 1][c], b[r + 2][c], b[r + 3][c] }, p);
		}
	}
	for (unsigned int r = 0; r < ROW - 3; r++) {
		for (unsigned int c = 0; c < COL - 3; c++) {
			score += ScoreSet({ b[r][c], b[r + 1][c + 1], b[r + 2][c + 2], b[r + 3][c + 3] }, p);
		}
	}
	for (unsigned int r = 3; r < ROW; r++) {
		for (unsigned int c = 0; c < COL - 3; c++) {
			score += ScoreSet({ b[r][c], b[r - 1][c + 1], b[r - 2][c + 2], b[r - 3][c + 3] }, p);
		}
	}
	return score;
}

int ScoreSet(vector<int> v, unsigned int p) {
	unsigned int good = 0;
	unsigned int bad = 0;
	unsigned int empty = 0;
	for (unsigned int i = 0; i < v.size(); i++) {
		good += (v[i] == p) ? 1 : 0;
		bad += (v[i] != 0) ? 1 : 0;
		empty += (v[i] == 0) ? 1 : 0;
	}

	bad -= good;
	return Heurisctic(good, bad, empty);
}

int Heurisctic(unsigned int g, unsigned int b, unsigned int e) {
	//Стратегия, при которой ИИ будет стремиться к "4 в ряд" в свою пользу сильнее, чем мешать игроку собрать 4 в ряд.
	//Иначе будет стремиться мешать игроку собрать 2 и 3 сильнее, чем самому собрать 2 и 3.

	int score = 0;
	if (g == 4) { score += 1001; }
	else if (g == 3 && e == 1) { score += 100; }
	else if (g == 2 && e == 2) { score += 10; }
	else if (b == 2 && e == 2) { score -= 11; }
	else if (b == 3 && e == 1) { score -= 101; }
	else if (b == 4) { score -= 1000; }
	return score;
}

bool IsWin(vector<vector<int> >& b, unsigned int p) {
	unsigned int winSequence = 0;

	for (unsigned int c = 0; c < COL - 3; c++) {
		for (unsigned int r = 0; r < ROW; r++) {
			for (int i = 0; i < 4; i++) {
				if ((unsigned int)b[r][c + i] == p) {
					winSequence++;
				}
				if (winSequence == 4) { return true; }
			}
			winSequence = 0;
		}
	}
	for (unsigned int c = 0; c < COL; c++) {
		for (unsigned int r = 0; r < ROW - 3; r++) {
			for (int i = 0; i < 4; i++) {
				if ((unsigned int)b[r + i][c] == p) {
					winSequence++;
				}
				if (winSequence == 4) { return true; }
			}
			winSequence = 0;
		}
	}
	for (unsigned int c = 0; c < COL - 3; c++) {
		for (unsigned int r = 3; r < ROW; r++) {
			for (int i = 0; i < 4; i++) {
				if ((unsigned int)b[r - i][c + i] == p) {
					winSequence++;
				}
				if (winSequence == 4) { return true; }
			}
			winSequence = 0;
		}
	}
	for (unsigned int c = 0; c < COL - 3; c++) {
		for (unsigned int r = 0; r < ROW - 3; r++) {
			for (int i = 0; i < 4; i++) {
				if ((unsigned int)b[r + i][c + i] == p) {
					winSequence++;
				}
				if (winSequence == 4) { return true; }
			}
			winSequence = 0;
		}
	}
	return false;
}

vector<vector<int> > CloneBoard(vector<vector<int> > b) {
	vector<vector<int>> newBoard(ROW, vector<int>(COL));
	for (unsigned int r = 0; r < ROW; r++) {
		for (unsigned int c = 0; c < COL; c++) {
			newBoard[r][c] = b[r][c];
		}
	}
	return newBoard;
}

void ChangeExternBoard(int* extboard) {
	for (int r = 0; r < ROW; r++) {
		for (int c = 0; c < COL; c++) {
			extboard[r * COL + c] = board[r][c];
		}
	}
}

extern "C" __declspec(dllexport) int Move(int move, int* extboard, int player) {
	for (int r = 0; r < ROW; r++) {
		for (int c = 0; c < COL; c++) {
			board[r][c] = extboard[r * COL + c];
		}
	}

	if (player == 1) {
		MakeMove(board, move, PLAYER);
		TURNS++;
		ChangeExternBoard(extboard);
		if (IsWin(board, PLAYER)) return 1; // Победил игрок
	}

	if (player == 2) {
		MakeMove(board, AiMove(), AI);
		TURNS++;
		ChangeExternBoard(extboard);
		if (IsWin(board, AI)) return 2; // Победил компьютер
	}

	if (TURNS == ROW * COL) {
		return 3; // Ничья
	}

	return 0;
}
