using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SocialPlatforms;

[ExecuteInEditMode]
public class MetaBall : MonoBehaviour
{

    public MetaBallReference.MetaballShape shape;

    [Range(0, 3)] public float size = 1;

    SpriteRenderer renderer { get { return GetComponent<SpriteRenderer>(); } }

    public Vector4 position { get { return (Vector4)transform.position; } }

    public Color color;

    SphereCollider collider { get { return GetComponent<SphereCollider>(); } }

    public MetaBall child;

    // Update is called once per frame
    void Update()
    {

        if(child)
        {
            if(Vector3.Distance(transform.position, child.position) >2)
            {
                child.transform.position = Vector3.Lerp(child.transform.position, transform.position, Time.deltaTime * 8);
            }
        }

        if (!renderer)
        {
            gameObject.AddComponent<SpriteRenderer>();
        }

        if(!collider)
        {
            gameObject.AddComponent<SphereCollider>();

        }

        renderer.sprite = MetaBallReference.Shapes.GetSprite(shape);
        renderer.color = MetaBallReference.MaskColor;

        transform.localScale = Vector3.one * size;

    }
}


