using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterAnimator : MonoBehaviour
{
    public float scrollSpeed = 0.5f; // Speed of the water animation
    public string texturePropertyName = "_MainTex"; // Name of the texture property in the shader
    public Vector2 scrollDirection = new Vector2(1.0f, 0.0f); // Scrolling direction in UV space

    Renderer rendererComponent;

    void Start()
    {
        // Get the renderer component attached to the GameObject
        rendererComponent = GetComponent<Renderer>();

        if (rendererComponent == null)
        {
            Debug.LogError("Renderer component not found on the GameObject!");
            return;
        }

        // Ensure the material has the specified texture property
        if (!rendererComponent.material.HasProperty(texturePropertyName))
        {
            Debug.LogError($"Texture property '{texturePropertyName}' not found in the material!");
            return;
        }
    }

    void Update()
    {
        // Move the texture offset based on time to create the animation
        float offset = Time.time * scrollSpeed;
        Vector2 offsetVector = new Vector2(offset * scrollDirection.x, offset * scrollDirection.y);

        // Apply the updated texture offset to the material
        rendererComponent.material.SetTextureOffset(texturePropertyName, offsetVector);
    }
}