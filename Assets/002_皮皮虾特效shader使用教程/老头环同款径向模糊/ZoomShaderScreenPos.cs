using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]

public class ZoomShaderScreenPos : MonoBehaviour
{
    // Start is called before the first frame update

    // [SerializeField] private Material material;
    public Material material;
    // public GameObject model;


     void   Update() {
        
        Vector2 screenPixels=Camera.main.WorldToScreenPoint(transform.position);
        screenPixels=new Vector2(screenPixels.x/Screen.width,screenPixels.y/Screen.height);
        material.SetVector("_objectScreenPostion",screenPixels);
    }
}
