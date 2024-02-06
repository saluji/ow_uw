using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnClickAnimation : MonoBehaviour
{
    public Animator animator;
    private void OnMouseUpAsButton()
    {
        animator.SetTrigger("Play");
    }
}
