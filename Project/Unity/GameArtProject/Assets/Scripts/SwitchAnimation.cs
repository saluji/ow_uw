using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwitchAnimation : MonoBehaviour
{
    public Animator animator;
    bool state = false;
    public void SwitchWorld()
    {
        state = animator.GetBool("switch");
        animator.SetBool("switch", !state);
    }
}
