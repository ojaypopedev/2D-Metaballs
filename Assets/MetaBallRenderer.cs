using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.UI;

[RequireComponent(typeof(Camera))]
public class MetaBallRenderer : MonoBehaviour
{
    Camera EffectCamera;
    Camera thisCam { get { return GetComponent<Camera>(); } }

    RenderTexture metaBallRenderTexture { get { return Resources.Load<RenderTexture>("RenderTextures/MetaBallTex"); } }
    PostProcessProfile postProcessVolume { get { return Resources.Load<PostProcessProfile>("PostProcessing/MetaBallPostProcessing"); } }
    GameObject effectCameraPrefab { get { return Resources.Load<GameObject>("Prefabs/EffectCamera"); } }
    GameObject renderMesh { get { return Resources.Load<GameObject>("Prefabs/RenderMesh"); } }    
    

    void Start()
    {
        GameObject effectCam = Instantiate(effectCameraPrefab, transform.position, Quaternion.identity ,transform);
        EffectCamera = effectCam.GetComponent<Camera>();


        Instantiate(renderMesh, transform);
        EffectCamera.cullingMask = (1 << MetaBallReference.EffectLayer);
        thisCam.cullingMask = ~0 - (1 << MetaBallReference.EffectLayer);   

    }

    // Update is called once per frame
    void Update()
    {
        EffectCamera.orthographicSize = thisCam.orthographicSize;
    }
}
