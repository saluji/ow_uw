using UnityEngine;
using UnityEngine.UI;

public class MoveCameraOnButtonClick : MonoBehaviour
{
    public Transform positionOW;
    public Transform positionUW;
    public float transitionDuration = 1.0f;

    private Transform cameraTransform; // Reference to the "Camera" GameObject
    private Vector3 targetPosition;
    private bool isTransitioning = false;

    void Start()
    {
        // Get the transform of the parent "Camera" GameObject
        cameraTransform = transform;

        targetPosition = positionOW.position; // Start at position OW

        // Attempt to find the Button component
        Button yourUIButton = GetComponent<Button>();

        // If the Button component is not on the same GameObject, try to find it in children
        if (yourUIButton == null)
        {
            yourUIButton = GetComponentInChildren<Button>();
        }

        if (yourUIButton != null)
        {
            yourUIButton.onClick.AddListener(OnClickButton);
        }
        else
        {
            Debug.LogError("Button component not found!");
        }
    }

    void OnClickButton()
    {
        // Toggle between Position OW and Position UW
        ToggleTransition();
    }

    void Update()
    {
        // Smoothly move the "Camera" GameObject using Vector3.Lerp
        if (isTransitioning)
        {
            float t = Mathf.Clamp01(Time.deltaTime / transitionDuration);
            cameraTransform.position = Vector3.Lerp(cameraTransform.position, targetPosition, t);

            if (t >= 1.0f)
            {
                isTransitioning = false;
            }
        }
    }

    void ToggleTransition()
    {
        // Toggle between Position OW and Position UW
        if (targetPosition == positionOW.position)
        {
            targetPosition = positionUW.position;
        }
        else
        {
            targetPosition = positionOW.position;
        }

        // Start the transition
        isTransitioning = true;
    }
}
