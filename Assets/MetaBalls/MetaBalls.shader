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
        _Noise("Noise Texture", 2D) = "white" {}
    }
        SubShader{
            Tags {"Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout"}
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

                        float2 texcoord1 : TEXCOORD1;
                        float2 texcoord : TEXCOORD0;
                        
                    };

                    struct v2f {

                        float4 vertex : SV_POSITION;
                        float2 texcoord1 : TEXCOORD1;
                        float2 texcoord : TEXCOORD0;
                       
                    };

                    sampler2D _Noise;
                    sampler2D _MainTex;
                    float4 _MainTex_ST;
                    float4 _Noise_ST;
                    fixed _Cutoff;
                    fixed4 _Mask;
                    fixed4 _Color;
                    float _DebugInt;
                    uniform int _Points_Length = 0;
                    uniform float3 _Points[100];
                    uniform float4 _Colors[100];

                    float map(float s, float a1, float a2, float b1, float b2)
                    {
                        return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
                    }

                    v2f vert(appdata_t v)
                    {
                        v2f o;
                       
                        o.vertex = UnityObjectToClipPos(v.vertex);
                        
                        o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                        o.texcoord1 = TRANSFORM_TEX(v.texcoord1, _Noise);
                        return o;
                    }


                    void Unity_Saturation_float(float3 In, float Saturation, out float3 Out)
                    {
                        float luma = dot(In, float3(0.2126729, 0.7151522, 0.0721750));
                        Out = luma.xxx + Saturation.xxx * (In - luma.xxx);
                    }

                    fixed4 frag(v2f i) : SV_Target
                    {
                        fixed4 col = tex2D(_MainTex, i.texcoord);
                       

                        fixed4 posCol = fixed4(0, 0, 0, 0);
                       
                        

                        for (int j = 0; j < _Points_Length; j++)
                        {
                            // Calculates the contribution of each point
                            float di = distance(i.texcoord, _Points[j].xyz);

                            
                            
                            posCol.rgb +=
                                (
                                    (di < _Colors[j].w) ?
                                    (_Colors[j]) :
                                    (
                                        ((di > _Colors[j].w) && (di < _Colors[j].w + 0.05)) ?
                                        (_Colors[j] * map(di, _Colors[j].w, _Colors[j].w+0.05,1,0)) :
                                        float3(0, 0, 0)
                                        )
                                    );

                           
                        
                        }
                       

                        clip(col.a - _Cutoff);
                       // UNITY_APPLY_FOG(i.fogCoord, col);

                        fixed4 ret = (abs(col.g - _Mask.g) < 0.1) ? posCol : float4(0, 0, 0, 0);
                       
                        fixed4 temp;
                        
                        Unity_Saturation_float(ret,1,temp.rgb);
                       

                        return temp;
                    }
                        
                   

                ENDCG
            }
        }

}