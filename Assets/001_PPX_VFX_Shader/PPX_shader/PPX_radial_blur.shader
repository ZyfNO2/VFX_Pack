//警告！！！该shader完全未经过性能优化，请勿引入到项目中
//主要目的是方便动画师或者特效师制作个人demo，请勿用于任何商业用途
//个人知乎账号ID:shuang-miao-80 后续可能会有更新
//https://zhuanlan.zhihu.com/p/421146056
//B站主页：https://space.bilibili.com/442123027
//最后,玩的开心!!!
Shader "PPX_radial_blur"
{
	Properties
	{
		_objectScreenPostion("用脚本控制,别管它", Vector) = (0.5,0.5,0,0)
		_alpha("透明度", Range( 0 , 3)) = 1
		_scale("收缩or扩张", Range( 0.98 , 1.02)) = 1
		_base_mask("遮罩", 2D) = "white" {}
		[Toggle(_USE_CUSTOM1_SACLE_ON)] _use_custom1_sacle("用custom1_x控制sacle缩放", Float) = 0
		[Enum(Off,0,On,1)]_Zwrite("Zwrite", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite [_Zwrite]
		ZTest Always
		Offset 0 , 0
		
		
		GrabPass{ }

		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" "Queue"="Transparent" }
			CGPROGRAM

			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
			#else
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
			#endif


			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#pragma shader_feature_local _USE_CUSTOM1_SACLE_ON


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _Zwrite;
			ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform float2 _objectScreenPostion;
			uniform float _scale;
			uniform sampler2D _base_mask;
			uniform float4 _base_mask_ST;
			uniform float _alpha;
			inline float4 ASE_ComputeGrabScreenPos( float4 pos )
			{
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				float4 o = pos;
				o.y = pos.w * 0.5f;
				o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
				return o;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				
				o.ase_texcoord2 = v.ase_texcoord;
				o.ase_color = v.color;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float4 screenPos = i.ase_texcoord1;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 center36 = _objectScreenPostion;
				float2 temp_output_9_0_g57 = center36;
				float noise156 = 1.0;
				float noise_power198 = 1.0;
				float lerpResult19_g57 = lerp( 1.0 , noise156 , noise_power198);
				float4 screenColor12_g57 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g57 ) / ( 1.0 * lerpResult19_g57 ) ) + temp_output_9_0_g57 ));
				float2 temp_output_9_0_g58 = center36;
				float4 texCoord222 = i.ase_texcoord2;
				texCoord222.xy = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _USE_CUSTOM1_SACLE_ON
				float staticSwitch212 = texCoord222.z;
				#else
				float staticSwitch212 = _scale;
				#endif
				float scale62 = ( staticSwitch212 - 1.0 );
				float lerpResult19_g58 = lerp( 1.0 , noise156 , noise_power198);
				float4 screenColor12_g58 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g58 ) / ( ( 1.0 + ( scale62 * 1.0 ) ) * lerpResult19_g58 ) ) + temp_output_9_0_g58 ));
				float2 temp_output_9_0_g59 = center36;
				float lerpResult19_g59 = lerp( 1.0 , noise156 , noise_power198);
				float4 screenColor12_g59 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g59 ) / ( ( 1.0 + ( scale62 * 2.0 ) ) * lerpResult19_g59 ) ) + temp_output_9_0_g59 ));
				float2 temp_output_9_0_g60 = center36;
				float lerpResult19_g60 = lerp( 1.0 , noise156 , noise_power198);
				float4 screenColor12_g60 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g60 ) / ( ( 1.0 + ( scale62 * 3.0 ) ) * lerpResult19_g60 ) ) + temp_output_9_0_g60 ));
				float2 temp_output_9_0_g61 = center36;
				float lerpResult19_g61 = lerp( 1.0 , noise156 , noise_power198);
				float4 screenColor12_g61 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g61 ) / ( ( 1.0 + ( scale62 * 4.0 ) ) * lerpResult19_g61 ) ) + temp_output_9_0_g61 ));
				float2 temp_output_9_0_g62 = center36;
				float lerpResult19_g62 = lerp( 1.0 , noise156 , noise_power198);
				float4 screenColor12_g62 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g62 ) / ( ( 1.0 + ( scale62 * 5.0 ) ) * lerpResult19_g62 ) ) + temp_output_9_0_g62 ));
				float2 temp_output_9_0_g70 = center36;
				float lerpResult19_g70 = lerp( 1.0 , noise156 , 1.2);
				float4 screenColor12_g70 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g70 ) / ( ( 1.0 + ( scale62 * 6.0 ) ) * lerpResult19_g70 ) ) + temp_output_9_0_g70 ));
				float2 temp_output_9_0_g69 = center36;
				float lerpResult19_g69 = lerp( 1.0 , 1.0 , 1.2);
				float4 screenColor12_g69 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g69 ) / ( ( 1.0 + ( scale62 * 7.0 ) ) * lerpResult19_g69 ) ) + temp_output_9_0_g69 ));
				float2 temp_output_9_0_g68 = center36;
				float lerpResult19_g68 = lerp( 1.0 , 1.0 , 1.2);
				float4 screenColor12_g68 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g68 ) / ( ( 1.0 + ( scale62 * 8.0 ) ) * lerpResult19_g68 ) ) + temp_output_9_0_g68 ));
				float2 temp_output_9_0_g66 = center36;
				float lerpResult19_g66 = lerp( 1.0 , 1.0 , 1.2);
				float4 screenColor12_g66 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g66 ) / ( ( 1.0 + ( scale62 * 9.0 ) ) * lerpResult19_g66 ) ) + temp_output_9_0_g66 ));
				float2 temp_output_9_0_g71 = center36;
				float lerpResult19_g71 = lerp( 1.0 , 1.0 , 1.2);
				float4 screenColor12_g71 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( (ase_grabScreenPosNorm).xy - temp_output_9_0_g71 ) / ( ( 1.0 + ( scale62 * 10.0 ) ) * lerpResult19_g71 ) ) + temp_output_9_0_g71 ));
				float4 final_grab142 = ( ( ( ( ( ( ( ( ( ( screenColor12_g57 + screenColor12_g58 ) + screenColor12_g59 ) + screenColor12_g60 ) + screenColor12_g61 ) + screenColor12_g62 ) + screenColor12_g70 ) + screenColor12_g69 ) + screenColor12_g68 ) + screenColor12_g66 ) + screenColor12_g71 );
				float2 uv_base_mask = i.ase_texcoord2.xy * _base_mask_ST.xy + _base_mask_ST.zw;
				float4 appendResult22 = (float4((( final_grab142 / ( 10.0 + 1.0 ) )).rgb , saturate( ( ( tex2D( _base_mask, uv_base_mask ).r * _alpha ) * i.ase_color.a ) )));
				
				
				finalColor = appendResult22;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
