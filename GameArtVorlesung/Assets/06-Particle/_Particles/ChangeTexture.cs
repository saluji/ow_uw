using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeTexture : MonoBehaviour

{
    public Texture[] textures;  // Array of textures to cycle through
    public float changeInterval = 1.0f;  // Time interval between texture changes

    private MeshRenderer meshRenderer;
    private int currentTextureIndex = 0;
    private float timer = 0f;

    void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();

        // Check if there are textures and a renderer
        if (textures.Length > 0 && meshRenderer != null)
        {
            // Set the initial texture
            meshRenderer.material.mainTexture = textures[currentTextureIndex];
        }
        else
        {
            Debug.LogError("Please assign textures and ensure the GameObject has a MeshRenderer component.");
        }
    }

    void Update()
    {
        // If there is more than one texture, cycle through them over time
        if (textures.Length > 1)
        {
            timer += Time.deltaTime;

            // Check if it's time to change the texture
            if (timer >= changeInterval)
            {
                // Reset the timer
                timer = 0f;

                // Change to the next texture
                currentTextureIndex = (currentTextureIndex + 1) % textures.Length;
                meshRenderer.material.mainTexture = textures[currentTextureIndex];
            }
        }
    }
}
