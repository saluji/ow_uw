using UnityEngine;
using System.Collections;

public class SimpleObjectTransition : MonoBehaviour
{
    public Transform positionA;
    public Transform positionB;
    public GameObject objectToMove;
    public Camera mainCamera;
    public Color solidColor;
    public Material skyboxMaterial;
    public GameObject[] objectsToToggle;

    private Transform currentTarget;
    private bool isTransitioning = false;

    void Start()
    {
        currentTarget = positionA;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space) && !isTransitioning)
        {
            currentTarget = (currentTarget == positionA) ? positionB : positionA;
            StartCoroutine(TransitionToPosition(currentTarget.position));
        }
    }

    IEnumerator TransitionToPosition(Vector3 targetPosition)
    {
        isTransitioning = true;

        // Switch camera clear flag and skybox
        if (currentTarget == positionA)
        {
            mainCamera.clearFlags = CameraClearFlags.SolidColor;
            mainCamera.backgroundColor = solidColor;
        }
        else
        {
            mainCamera.clearFlags = CameraClearFlags.Skybox;
            RenderSettings.skybox = skyboxMaterial;
        }

        // Toggle objects
        foreach (var obj in objectsToToggle)
        {
            obj.SetActive(currentTarget == positionA);
        }

        while (Vector3.Distance(objectToMove.transform.position, targetPosition) > 0.01f)
        {
            objectToMove.transform.position = Vector3.Lerp(objectToMove.transform.position, targetPosition, Time.deltaTime * 5f);
            yield return null;
        }

        isTransitioning = false;
    }
}
