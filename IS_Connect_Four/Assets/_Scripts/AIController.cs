using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;
using UnityEngine.UI;
using Image = UnityEngine.UIElements.Image;

public class AIController : MonoBehaviour
{
    [DllImport("DLL_Lab4_2", CallingConvention = CallingConvention.Cdecl)]
    private static extern int Move(int move, int[] board);

    public List<Button> _buttons;
    public static bool PLAYER_CAN_MOVE;
    public int[] BOARD;

    private void Start()
    {
        BOARD = new int[42]
        {
            0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0
        };
        PLAYER_CAN_MOVE = true;
        for (int i = 0; i < _buttons.Count; i++)
        {
            _buttons[i].GetComponent<ButtonHandler>().index = i % 7;
        }

        for (int i = 0; i < _buttons.Count; i++)
        {
            _buttons[i].GetComponent<ButtonHandler>().Buttonindex = i;
        }

        for (int i = 0; i < 35; i++)
        {
            _buttons[i].enabled = false;
        }
    }

    private void OnEnable()
    {
        ButtonHandler.onPut += ChangesAfterPlayerPut;
    }

    private void OnDisable()
    {
        ButtonHandler.onPut -= ChangesAfterPlayerPut;
    }

    public void ChangesAfterPlayerPut(int index)
    {
        if (!PLAYER_CAN_MOVE)
        {
            Debug.Log(index % 7);
            _buttons[index].enabled = false;
            _buttons[index].image.color = Color.yellow;
            BOARD[index] = 1;
            int status = Move(index % 7, BOARD);
            if (index > 6)
            {
                _buttons[index - 7].enabled = true;
                Debug.Log($"{index - 7} теперь активна");
            }

            Invoke("RedrawBoard", 2);
        }
    }

    public void RedrawBoard()
    {
        int count = 0;
        foreach (int item in BOARD)
        {
            _buttons[item].enabled = false;
            if (item == 1)
                _buttons[count].image.color = Color.yellow;
            if (item == 2)
                _buttons[count].image.color = Color.red;
            count++;
        }

        PLAYER_CAN_MOVE = true;
    }
}