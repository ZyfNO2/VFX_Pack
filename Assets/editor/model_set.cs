using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class model_set : AssetPostprocessor
{
    // Start is called before the first frame update
    const string PATH="Assets/Art_resource/Model";

    void OnPreprocessModel()
    {
        if(!assetPath.Contains(PATH))
            return;
        ModelImporter importer=(ModelImporter)assetImporter;
        importer.importBlendShapes=false;
        importer.importCameras=false;
        importer.importVisibility=false;
        importer.importLights=false;
        importer.isReadable=false;
        importer.importBlendShapes=false;
      

        importer.animationType=ModelImporterAnimationType.None;
        importer.importAnimation=false;
        importer.materialImportMode=ModelImporterMaterialImportMode.None;



        // importer.animation=false;
        // importer.wrapMode=TextureWrapMode.Repeat;
        // importer.mipmapEnabled=false;

    }

}
