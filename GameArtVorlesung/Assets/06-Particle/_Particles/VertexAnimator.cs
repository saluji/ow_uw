using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VertexAnimator : MonoBehaviour
{
    public float maxOffset = 1.0f; // Maximum vertical offset
    public float speed = 1.0f; // Speed of the movement

    private Vector3[] originalVertices;
    private Vector3[] randomOffsets;
    private Mesh mesh;

    void Start()
    {
        // Get the mesh component of the GameObject
        mesh = GetComponent<MeshFilter>().mesh;

        // Store the original vertices for later reference
        originalVertices = mesh.vertices;

        // Generate random offsets for each vertex
        GenerateRandomOffsets();
    }

    void GenerateRandomOffsets()
    {
        randomOffsets = new Vector3[originalVertices.Length];

        for (int i = 0; i < randomOffsets.Length; i++)
        {
            randomOffsets[i] = new Vector3(
                Random.Range(-maxOffset, maxOffset),
                Random.Range(-maxOffset, maxOffset),
                Random.Range(-maxOffset, maxOffset)
            );
        }
    }

    void Update()
    {
        // Create a copy of the original vertices to modify
        Vector3[] modifiedVertices = originalVertices.Clone() as Vector3[];

        // Apply random movement to each vertex
        for (int i = 0; i < modifiedVertices.Length; i++)
        {
            Vector3 vertex = originalVertices[i];
            Vector3 randomOffset = randomOffsets[i];

            vertex.y += Mathf.Sin(Time.time * speed + randomOffset.x) * randomOffset.y;
            modifiedVertices[i] = vertex;
        }

        // Update the mesh with the modified vertices
        mesh.vertices = modifiedVertices;

        // Recalculate normals and bounds for proper rendering
        mesh.RecalculateNormals();
        mesh.RecalculateBounds();
    }
}
