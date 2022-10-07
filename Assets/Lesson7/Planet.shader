Shader "Custom/Planet"
{
    Properties
    {
        _Color0("Color ", Color) = (1,1,1,1)
        _Color1 ("Color Ground", Color) = (1,1,1,1)
        _Color2 ("Color Water", Color) = (1,1,1,1)
        _Color3 ("Color Stones", Color) = (1,1,1,1)


        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Emission ("Emission", Color ) = (1,1,1,1)
        _Height("Height", Range(-1, 1)) = 0
        _Seed("Seed", Range(0, 1000)) = 10
     
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float4 color: COLOR;
        };

        fixed4 _Color0;
        fixed4 _Color1;
        fixed4 _Color2;
        fixed4 _Color3;
        float4 _Emission;
        float _Height;
        float _Seed;


        float hash(float2 st) {
           return frac(sin(dot(st.xy, float2(12.9898, 78.233))) * 43758.5453123);
        }

        float noise(float2 p, float size) {
            float res = 0;

            p *= size;
            float2 i = floor(p + _Seed);
            float2 f = frac(p + _Seed / 739);
            float2 e = float2(0, 1);


            float z0 = hash((i + e.xx) % size);
            float z1 = hash((i + e.yx) % size);
            float z2 = hash((i + e.xy) % size);
            float z3 = hash((i + e.yy) % size);

            float2 u = smoothstep(0, 1, f);

            res = lerp(z0, z1, u.x) +
                (z2 - z0) * u.y * (1.0 - u.x) +
                (z3 - z1) * u.x * u.y;
            return res;

        }

        void vert(inout appdata_full v) {
            float height = noise(v.texcoord, 5) * 0.75 +
                noise(v.texcoord, 30) * 0.125 +
                noise(v.texcoord, 50) * 0.125;
            v.color.r = height + _Height;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color0;

            float height = IN.color.r;
            if (height < 0.45)
                c = _Color1;
            else if (height < 0.75)
                c = _Color2;
            else
                c = _Color3;


            o.Albedo = c.rgb;
            o.Emission = _Emission.xyz;
            o.Alpha = c.a;


        }
        ENDCG
    }
    FallBack "Diffuse"
}
