using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class model_rebuild : EditorWindow
{
    private static GUISkin skin;

    // [MenuItem("小工具合集/模型归位", false, 1)]
    [MenuItem("皮皮虾工具合集/Cool Reset Transform Tool 1.0", false, 1)]
    static void Open()
    {
        var window =
            GetWindow(typeof (model_rebuild),
            false,
            "Cool Reset Transform Tool");
        window.minSize = new Vector2(370, 150);
        window.maxSize = new Vector2(370, 150);

        // window.maximized = true;
        // Texture tex =
        //     AssetDatabase
        //         .LoadAssetAtPath<Texture>("Assets/Editor/UI_texture/icon.jpg");
        // window.titleContent = new GUIContent("模型归位", tex);
        window.titleContent = new GUIContent("Cool Reset Transform Tool");

        window.Show();
        skin =
            (GUISkin)
            EditorGUIUtility
                .Load("Assets/Editor/Cool_Reset_Transform_Tool/model_rebuild_skin.guiskin");
    }

    void OnGUI()
    {
        GUI.skin = skin;

        GUIStyle _style01 = new GUIStyle(EditorStyles.textField);
        _style01.fontSize = 24;

        _style01.wordWrap = true;

        EditorGUILayout.BeginHorizontal();

        // if (GUILayout.Button("位移清零", "button", GUILayout.Width(110)))
        if (GUILayout.Button("Translate", "button", GUILayout.Width(120)))
        {
            if (Selection.gameObjects == null)
            {
            }
            else
            {
                foreach (GameObject go in Selection.gameObjects)
                {
                    //回退操作
                    Undo.RecordObject(go.transform, "postion");
                    go.transform.localPosition = Vector3.zero;
                    //位移重置
                }
            }
        }

        // if (GUILayout.Button("旋转清零", "button", GUILayout.Width(110)))
        if (GUILayout.Button("Rotate", "button", GUILayout.Width(120)))
        {
            if (Selection.gameObjects == null)
            {
            }
            else
            {
                foreach (GameObject go in Selection.gameObjects)
                {
                    Undo.RecordObject(go.transform, "postion");
                    go.transform.localEulerAngles = new Vector3(0, 0, 0);
                }
            }
        }

        // if (GUILayout.Button("缩放归一", "button", GUILayout.Width(110)))
        if (GUILayout.Button("Scale", "button", GUILayout.Width(120)))
        {
            if (Selection.gameObjects == null)
            {
            }
            else
            {
                {
                    foreach (GameObject go in Selection.gameObjects)
                    {
                        Undo.RecordObject(go.transform, "postion");
                        go.transform.localScale = Vector3.one;
                    }
                }
            }
        }
        EditorGUILayout.EndHorizontal();

        //集体重置
        // if (GUILayout.Button("整体重置", "button", GUILayout.Width(336)))
        if (GUILayout.Button("All", "button", GUILayout.Width(366)))
        {
            foreach (GameObject go in Selection.gameObjects)
            {
                Undo.RecordObject(go.transform, "postion");
                go.transform.localPosition = Vector3.zero;
                go.transform.localEulerAngles = new Vector3(0, 0, 0);
                go.transform.localScale = Vector3.one;
            }
        }
    }
}
