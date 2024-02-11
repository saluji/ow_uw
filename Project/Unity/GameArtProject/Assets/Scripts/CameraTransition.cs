using System.Collections;
using UnityEngine;

public class CameraTransition : MonoBehaviour
{
    public Transform positionA;
    public Transform positionB;
    public Material skyboxMaterial;
    public Color solidColor;

    public GameObject objectToMove;

    private Transform currentTarget;
    private bool isTransitioning = false;
    private Camera mainCamera;

    void Start()
    {
        mainCamera = Camera.main;

        // Set the initial target to positionA
        currentTarget = positionA;
        mainCamera.transform.position = positionA.position;
        SetCameraProperties(true); // Set camera properties for position A

        // Start listening for spacebar input
        StartCoroutine(ListenForSpacebar());
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

        SetCameraProperties(currentTarget == positionA); // Set camera properties based on the current position
    }

    IEnumerator ListenForSpacebar()
    {
        while (true)
        {
            if (Input.GetKeyDown(KeyCode.Space) && !isTransitioning)
            {
                currentTarget = (currentTarget == positionA) ? positionB : positionA;
                StartCoroutine(TransitionToPosition(currentTarget.position));
            }
            yield return null;
        }
    }

    void SetCameraProperties(bool atPositionA)
    {
        if (atPositionA)
        {
            mainCamera.clearFlags = CameraClearFlags.Skybox; // Set clear flag to Skybox for position A
            RenderSettings.skybox = skyboxMaterial; // Set the Skybox material for position A
        }
        else
        {
            mainCamera.clearFlags = CameraClearFlags.SolidColor; // Set clear flag to Solid Color for position B
            mainCamera.backgroundColor = solidColor; // Set the Solid Color for position B
        }
    }
}
