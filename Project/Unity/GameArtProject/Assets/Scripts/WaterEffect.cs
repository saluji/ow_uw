using UnityEngine;

public class WaterEffect : MonoBehaviour
{
    [SerializeField] float scrollSpeed = 0.5f;
    [SerializeField] float x;
    [SerializeField] float y;
    Renderer rend;

    void Start()
    {
        rend = GetComponent<Renderer>();
    }

    void Update()
    {
        float offset = Time.time * scrollSpeed;
        rend.material.SetTextureOffset("_MainTex", new Vector2(x * offset, y * offset));
    }
}
