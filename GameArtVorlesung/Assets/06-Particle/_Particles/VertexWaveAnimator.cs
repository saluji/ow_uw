using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VertexWaveAnimator : MonoBehaviour
{
    public float frequency = 1.0f; // Frequency of the sine wave
    public float amplitude = 1.0f; // Amplitude of the sine wave
    public float speed = 1.0f; // Speed of the animation
    public bool useRandomOffset = true; // Enable random offsets for each vertex

    private Vector3[] originalVertices;
    private Mesh mesh;

    void Start()
    {
        // Get the mesh component of the GameObject
        mesh = GetComponent<MeshFilter>().mesh;

        // Store the original vertices for later reference
        originalVertices = mesh.vertices;
    }

    void Update()
    {
        // Create a copy of the original vertices to modify
        Vector3[] modifiedVertices = originalVertices.Clone() as Vector3[];

        // Apply sine wave animation to each vertex
        for (int i = 0; i < modifiedVertices.Length; i++)
        {
            Vector3 vertex = originalVertices[i];

            // Add a random offset if enabled
            if (useRandomOffset)
            {
                float randomOffset = Random.Range(0.0f, 1.0f);
                vertex.y += Mathf.Sin(Time.time * speed + vertex.x * frequency + randomOffset) * amplitude;
            }
            else
            {
                vertex.y += Mathf.Sin(Time.time * speed + vertex.x * frequency) * amplitude;
            }

            modifiedVertices[i] = vertex;
        }

        // Update the mesh with the modified vertices
        mesh.vertices = modifiedVertices;

        // Recalculate normals and bounds for proper rendering
        mesh.RecalculateNormals();
        mesh.RecalculateBounds();
    }
}


