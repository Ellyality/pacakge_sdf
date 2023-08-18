using UnityEngine;

namespace Ellyality.SDF
{
    [AddComponentMenu("Ellyality/SDF/2D Display")]
    public class DisplaySDF2D : MonoBehaviour
    {
        [SerializeField] Transform target;
        [SerializeField] MeshRenderer meshRenderer;
        [SerializeField] [Range(1, 10)]float size;
        [SerializeField] bool animation = false;
        [SerializeField] float animation_height;
        [SerializeField] float animation_distance;

        Material mat;
        Texture2D texture;

        Vector3 min;
        Vector3 max;
        Vector3 color;

        private void OnEnable()
        {
            meshRenderer.material = new Material(Shader.Find("Ellyality/SDF/SDF2D"));
            mat = meshRenderer.sharedMaterial;
            texture = new Texture2D(1, 1, TextureFormat.RGB24, false, false);
            texture.filterMode = FilterMode.Point;
            mat.SetTexture("_ObjTex", texture);
        }

        private void OnDrawGizmosSelected()
        {
            Bounds b = meshRenderer.bounds;
            Gizmos.DrawWireCube(b.center, b.size);
        }

        private void Update()
        {
            target.localScale = new Vector3(size, size, size);
            if (animation) target.localPosition = new Vector3(Mathf.Cos(Time.time) * animation_distance, animation_height, Mathf.Sin(Time.time) * animation_distance);
            texture.SetPixel(0, 0, GetColorAsPos());
            texture.Apply();
            min = meshRenderer.bounds.min;
            max = meshRenderer.bounds.max;
            mat.SetVector("_Min", min);
            mat.SetVector("_Max", max);
        }

        Color GetColorAsPos()
        {
            Bounds b = meshRenderer.bounds;
            Vector3 a = new Vector3(
                Mathf.InverseLerp(b.min.x, b.max.x, target.position.x),
                Mathf.InverseLerp(b.min.y, b.max.y, target.position.y),
                Mathf.InverseLerp(b.min.z, b.max.z, target.position.z)
            );
            color = a;
            return new Color(a.x, a.z, size / 10f);
        }
    }
}
