using UnityEngine;

[ExecuteInEditMode]
public class ShaderDisplay : MonoBehaviour
{
    public Shader replacementShader;
    public string targetTag = "ToonShader";

    private void OnValidate()
    {
        UpdateShader();
    }

    void Start()
    {
        UpdateShader();
    }

    void UpdateShader()
    {
        // Ensure a replacement shader is provided
        if (replacementShader == null)
        {
            Debug.LogError("Please assign a replacement shader in the inspector!");
            return;
        }

        // Find all GameObjects with the specified tag
        GameObject[] taggedObjects = GameObject.FindGameObjectsWithTag(targetTag);

        // Loop through each tagged GameObject
        foreach (GameObject obj in taggedObjects)
        {
            ReplaceShader(obj);
        }
    }

    void ReplaceShader(GameObject obj)
    {
        Renderer renderer = obj.GetComponent<Renderer>();

        // Check if the GameObject has a Renderer component
        if (renderer != null)
        {
            // Create a new material using the replacement shader
            Material newMaterial = new Material(replacementShader);

            // Copy the properties from the original material
            newMaterial.CopyPropertiesFromMaterial(renderer.sharedMaterial);

            // Assign the new material to the renderer
            renderer.material = newMaterial;
        }
        else
        {
            Debug.LogWarning("GameObject with tag " + targetTag + " does not have a Renderer component.");
        }
    }
}
