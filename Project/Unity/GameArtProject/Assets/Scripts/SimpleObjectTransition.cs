using UnityEngine;
using System.Collections;
public class SimpleObjectTransition : MonoBehaviour
{
    public Transform positionA;
    public Transform positionB;

    public GameObject objectToMove;

    private Transform currentTarget;
    private bool isTransitioning = false;

    void Start()
    {
        // Set the initial target to positionA
        currentTarget = positionA;
    }

    void Update()
    {
        // Check for spacebar input
        if (Input.GetKeyDown(KeyCode.Space) && !isTransitioning)
        {
            // Switch the target position
            currentTarget = (currentTarget == positionA) ? positionB : positionA;

            // Start the transition coroutine
            StartCoroutine(TransitionToPosition(currentTarget.position));
        }
    }

    IEnumerator TransitionToPosition(Vector3 targetPosition)
    {
        isTransitioning = true;

        while (Vector3.Distance(objectToMove.transform.position, targetPosition) > 0.01f)
        {
            // Simple linear interpolation for smooth movement
            objectToMove.transform.position = Vector3.Lerp(objectToMove.transform.position, targetPosition, Time.deltaTime * 5f);
            yield return null;
        }

        isTransitioning = false;
    }
}
