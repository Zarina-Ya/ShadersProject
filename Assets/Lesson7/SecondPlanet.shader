// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/SecondPlanet"
{
    //Properties
    //{
    //    _Tex1("Texture1", 2D) = "white" {}
    //    _Tex2("Texture2", 2D) = "white" {}
    //    _MixValue("MixValue", Range(0,1)) = 0.5
    //    _Color("Main Color", COLOR) = (1,1,1,1)
    //    _Height("Height", Range(0,20)) = 0.5 // сила изгиба

    //}

    //    SubShader
    //    {
    //        Tags { "RenderType" = "Opaque" }
    //        LOD 100



    //        Pass
    //        {
    //            CGPROGRAM

    //            #pragma vertex vert
    //            #pragma fragment frag
    //            #include "UnityCG.cginc"

    //            sampler2D _Tex1;
    //            float4 _Tex1_ST;

    //            sampler2D _Tex2;
    //            float4 _Tex2_ST;

    //            float _MixValue;
    //            float4 _Color;

    //            float _Height; // сила изгиба


    //            struct v2f
    //            {
    //                float2 uv : TEXCOORD0; // UV-координаты вершины
    //                float4 vertex : SV_POSITION; // координаты вершины
    //            };

    //            v2f vert(appdata_full v)
    //            {
    //                 v.vertex.xyz += v.normal * _Height;
    //            
    //                v2f result;
    //                result.vertex = UnityObjectToClipPos(v.vertex);
    //                result.uv = TRANSFORM_TEX(v.texcoord, _Tex1);

    //             

    //                return result;
    //            }

    //            fixed4 frag(v2f i) : SV_Target
    //            {
    //                fixed4 color;
    //                color = tex2D(_Tex1, i.uv) * _MixValue;
    //                color += tex2D(_Tex2, i.uv) * (1 - _MixValue);
    //                color = color * _Color;
    //                return color;
    //            }



    //            ENDCG
    //        }
    //    }

    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" {}
        _Color("Color (RGBA)", Color) = (1, 1, 1, 1) // add _Color property
            _Height("Height", Range(0,20)) = 0.5 // сила изгиба
    }

        SubShader
        {
                    Tags { "RenderType" = "Transparent" "Queue" = "Geometry-1" "IgnoreProjector" = "True" "ForceNoShadowCasting" =
"True" }
            
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            Cull front
            LOD 100
                Stencil
        {
               Ref 10
                Comp Always
                Pass Replace
            /*Ref 10
            Comp NotEqual*/
        }
            Pass
            {
                CGPROGRAM

                #pragma vertex vert alpha
                #pragma fragment frag alpha

                #include "UnityCG.cginc"

                struct appdata_t
                {
                    float4 vertex   : POSITION;
                    float2 texcoord : TEXCOORD0;
                };

                struct v2f
                {
                    float4 vertex  : SV_POSITION;
                    half2 texcoord : TEXCOORD0;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
                float4 _Color;
                float _Height; // сила изгиба

                v2f vert(appdata_full v)
                {
                    v.vertex.xyz += v.normal * _Height;
                    v2f o;

                    o.vertex = UnityObjectToClipPos(v.vertex);
                    v.texcoord.x = 1 - v.texcoord.x;
                    o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    fixed4 col = tex2D(_MainTex, i.texcoord) * _Color; // multiply by _Color
                    return col;
                }

                ENDCG
            }
        }
}
