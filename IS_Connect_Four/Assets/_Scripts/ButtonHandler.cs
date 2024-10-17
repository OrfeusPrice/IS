using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using Button = UnityEngine.UI.Button;

public class ButtonHandler : MonoBehaviour
{
    public int index;
    public int Buttonindex;
    public static Action<int> onPut;

    private void Start()
    {
        this.GetComponent<Button>().onClick.AddListener(this.PutPlayerColor);
    }

    public void PutPlayerColor()
    {
        if (AIController.PLAYER_CAN_MOVE)
        {
            Debug.Log($"Нажата {Buttonindex}");
            AIController.PLAYER_CAN_MOVE = false;
            onPut?.Invoke(Buttonindex);
        }
    }

    public void PutEnemyColor()
    {
        
    }
}
