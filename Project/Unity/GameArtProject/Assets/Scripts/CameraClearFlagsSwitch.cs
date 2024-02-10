using UnityEngine;
public class CameraClearFlagsSwitch : MonoBehaviour
{
    public bool useSkybox = true;
    public Color solidColor = Color.black; // Change this color as needed

    private Camera mainCamera;

    void Start()
    {
        // Get the main camera component
        mainCamera = Camera.main;

        if (mainCamera == null)
        {
            Debug.LogError("Main camera not found!");
        }
    }

    void Update()
    {
        // Check the boolean variable and set clear flags accordingly
        if (useSkybox)
        {
            mainCamera.clearFlags = CameraClearFlags.Skybox;
        }
        else
        {
            mainCamera.clearFlags = CameraClearFlags.SolidColor;
            mainCamera.backgroundColor = solidColor;
        }
    }
}
