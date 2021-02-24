using System.Collections;

using UnityEngine;

public class MetaBallManager : MonoBehaviour
{

    public Vector4[] positions;
    public Color[] Colors;
    float[] Sizes;

    Material metaBallRenderMaterial { get { return Resources.Load<Material>("Materials/MetaBall"); } }
    MetaBall[] allMetaBalls;

    MetaBall dragTarget;

    // Update is called once per frame
    void Update()
    {
        if(Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            LayerMask mask = (1 << MetaBallReference.EffectLayer);
            RaycastHit hit;

            if(Physics.Raycast(ray, out hit, 100, mask))
            {
                if(hit.collider.GetComponent<MetaBall>())
                {
                    dragTarget = hit.collider.GetComponent<MetaBall>();
                    dragTarget.size *= 1.05f;
                }
            }
        }

        if(Input.GetMouseButtonUp(0))
        {
            //Do joining stuff here;
            if(dragTarget)
            {
                foreach (var item in allMetaBalls)
                {
                    if (item != dragTarget)
                    {
                        if (Vector2.Distance(item.position, dragTarget.position) < 2)
                        {
                           // item.transform.parent = dragTarget.transform;

                        }
                    }
                }

                dragTarget.size *= 1/1.05f;
            }
            dragTarget = null;
        }

        if(dragTarget)
        {
           

            dragTarget.transform.position = Vector3.Lerp(dragTarget.transform.position, Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, 10)), 10*Time.deltaTime);
        
        }

        DrawMetaBalls();
    }

    public void DrawMetaBalls()
    {

        allMetaBalls = FindObjectsOfType<MetaBall>();

        positions = new Vector4[100];
        Colors = new Color[100];
        Sizes = new float[100];


        for (int i = 0; i < allMetaBalls.Length; i++)
        {
            Colors[i] = allMetaBalls[i].color;
            Sizes[i] = allMetaBalls[i].transform.localScale.magnitude / 10;
        }

        for (int i = 0; i < allMetaBalls.Length; i++)
        {
            Ray ray = Camera.main.ScreenPointToRay(Camera.main.WorldToScreenPoint(allMetaBalls[i].position));
            RaycastHit hit;
            LayerMask layer = ~0 - (1 << MetaBallReference.EffectLayer);

            if (Physics.Raycast(ray, out hit,100, layer))
            {
                positions[i] = hit.textureCoord;
            }

        }


        metaBallRenderMaterial.SetVectorArray("_Points", positions);
        metaBallRenderMaterial.SetVectorArray("_Colors", ColorsToVector4(Colors, Sizes));

        metaBallRenderMaterial.SetInt("_Points_Length", positions.Length);


    }



    public Vector4[] ColorsToVector4(Color[] Colors, float[] sizes)
    {
        Vector4[] toReturn = new Vector4[Colors.Length];

        for (int i = 0; i < toReturn.Length; i++)
        {
            toReturn[i] = new Vector4(Colors[i].r, Colors[i].g, Colors[i].b, sizes[i]);
        }

        return toReturn;
    }
}
