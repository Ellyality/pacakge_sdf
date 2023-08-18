Shader "Ellyality/SDF/SDF2D"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ObjTex ("ObjTexture", 2D) = "white" {}
        _Scale("Scale", float) = 0.05
        [HideInspector] _Min("Bound_Min", Vector) = (0.0, 0.0, 0.0, 0.0)
        [HideInspector] _Max("Bound_Max", Vector) = (0.0, 0.0, 0.0, 0.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "sdf2D.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 worldSpacePos : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _ObjTex;
            float4 _MainTex_ST;
            float4 _ObjTex_ST;
            float4 _Min;
            float4 _Max;
            float _Scale;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldSpacePos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed3 shading(float d){
                fixed3 r = (d>0.0) ? fixed3(0.9,0.6,0.3) : fixed3(0.65,0.85,1.0);
                r *= 1.0 - exp(-6.0*abs(d));
	            r *= 0.8 + 0.2*cos(150.0*d*_Scale);
	            r = LERP(r, fixed3(1.0, 1.0, 1.0), 1.0-smoothstep(0.0,0.2,abs(d)));
                return r;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 col = tex2D(_ObjTex, i.uv);
                col.xyz = pow(col.xyz, 0.454545);
                col.xy = float2(LERP(_Min.x, _Max.x, col.x), LERP(_Min.z, _Max.z, col.y));
                float d = sdCircle(i.worldSpacePos.xz, col.xy, (col.z * 2.0));
                return fixed4(shading(d), 1.0);
                //return float4(smoothstep(_Min.x, _Max.x, col.x), smoothstep(_Min.z, _Max.z, col.y), 0., 1.);
            }
            ENDCG
        }
    }
}
