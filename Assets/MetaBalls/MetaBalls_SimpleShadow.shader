// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Metaball/Ball" {
    Properties{

        _MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
        _Cutoff("Alpha cutoff", Range(0,1)) = 0.5
        _Color("Color", Color) = (1,0,0,1)
        _Mask("Mask", Color) = (0,1,0,1)
        _DebugInt("Debug", float) = 0
        _Points_Length("PointsLength", float) = 0    
        _Offset("ShadowOffset", Vector) = (0,0,0)
    }
        SubShader{
            Tags {"Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "Transparrent"}
            LOD 100

            Lighting Off

            Pass {
                CGPROGRAM
                    #pragma vertex vert
                    #pragma fragment frag
                    #pragma target 2.0
                    #pragma multi_compile_fog

                    #include "UnityCG.cginc"

                    struct appdata_t {
                        float4 vertex : POSITION;

                        float2 texcoord : TEXCOORD0;
                        
                    };

                    struct v2f {

                        float4 vertex : SV_POSITION;

                        float2 texcoord : TEXCOORD0;
                       
                    };

                    sampler2D _MainTex;
                    float4 _MainTex_ST;
                    fixed _Cutoff;
                    fixed4 _Mask;
                    fixed4 _Color;
                    float _DebugInt;
                    uniform int _Points_Length = 0;
                    uniform float3 _Points[100];
                    uniform float3 _Colors[100];
                    float3 _Offset;


                    v2f vert(appdata_t v)
                    {
                        v2f o;
                       
                        o.vertex = UnityObjectToClipPos(v.vertex);
                        
                        o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                        
                        return o;
                    }

                    fixed4 frag(v2f i) : SV_Target
                    {
                        fixed4 col = tex2D(_MainTex, i.texcoord + _Offset);
                       

                        fixed4 posCol = _Color;
                       

                        //for (int j = 0; j < _Points_Length; j++)
                        //{
                        //    // Calculates the contribution of each point
                        //    float di = distance(i.texcoord, _Points[j].xyz + _Offset);

                        //    posCol.rgb += ((di < 0.3) ? (_Colors[j] * (1-di/0.3)) : float3(0, 0, 0));                                         
                        //
                        //}

                        clip(col.a - _Cutoff);
                       // UNITY_APPLY_FOG(i.fogCoord, col);

                        fixed4 ret = (abs(col.g - _Mask.g) < 0.1) ? posCol : float4(1, 0, 0, 0);
                        
                        ret.a = 0.2;


                        return ret;
                    }
                ENDCG
            }
        }

}