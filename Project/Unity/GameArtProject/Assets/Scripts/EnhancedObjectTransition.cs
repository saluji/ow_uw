using UnityEngine;
using System.Collections.Generic;
using System.Collections;

public class EnhancedObjectTransition : MonoBehaviour
{
    public Transform positionA;
    public Transform positionB;

    public GameObject objectToMove;
    public Material skyboxA;
    public Material skyboxB;

    public float transitionSpeed = 5f;
    public float reflectionIntensity = 1f;

    public GameObject[] objectsToToggle; // Add objects to this array in the Inspector
    public GameObject[] additionalObjectsToToggleInA; // Add objects to this array in the Inspector

    private Transform currentTarget;
    private bool isTransitioning = false;

    void Start()
    {
        // Set the initial target to positionA
        currentTarget = positionA;

        // Set the initial Skybox
        RenderSettings.skybox = skyboxA;
        RenderSettings.skybox.SetFloat("_ReflectionIntensity", reflectionIntensity);
    }

    void Update()
    {
        // Check for spacebar input
        if (Input.GetKeyDown(KeyCode.Space) && !isTransitioning)
        {
            // Switch the target position
            currentTarget = (currentTarget == positionA) ? positionB : positionA;

            // Switch the Skybox
            RenderSettings.skybox = (currentTarget == positionA) ? skyboxA : skyboxB;
            RenderSettings.skybox.SetFloat("_ReflectionIntensity", reflectionIntensity);

            // Toggle the list of objects based on the position
            ToggleObjects(objectsToToggle, currentTarget == positionA);

            // Toggle additional list of objects based on the position
            ToggleObjects(additionalObjectsToToggleInA, currentTarget != positionA);

            // Start the transition coroutine
            StartCoroutine(TransitionToPosition(currentTarget.position));
        }
    }

    void ToggleObjects(GameObject[] objects, bool isActive)
    {
        foreach (var obj in objects)
        {
            if (obj != null) // Check if the object exists
            {
                obj.SetActive(isActive);
            }
        }

        // Toggle the directional light based on the position
        GameObject directionalLight = GameObject.Find("Directional Light"); // Replace with the actual name of your directional light
        if (directionalLight != null)
        {
            directionalLight.SetActive(currentTarget == positionA);
        }
    }

    IEnumerator TransitionToPosition(Vector3 targetPosition)
    {
        isTransitioning = true;

        while (Vector3.Distance(objectToMove.transform.position, targetPosition) > 0.01f)
        {
            // Smoothly interpolate towards the target position
            objectToMove.transform.position = Vector3.Lerp(
                objectToMove.transform.position,
                targetPosition,
                Time.deltaTime * transitionSpeed
            );

            yield return null;
        }

        isTransitioning = false;
    }
}
