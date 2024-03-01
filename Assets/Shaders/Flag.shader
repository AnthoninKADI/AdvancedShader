Shader "Unlit/Flag"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
        _HeightFactor("Height", float) =0.1
        _Speed("Speed", float) = 0
        _Frequency("Frequency", float) = 0
        _Amplitude("Amplitude", float) = 0

    }
    SubShader
    {
        Tags {}

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;
 
             #include "UnityCG.cginc"

            float4 vertexAnimFlag(float4 pos, float2 uv)
            {
                pos.z = pos.z + sin((uv.x - _Time.y * _Speed) * _Frequency) * _Amplitude * uv.x;
                return pos;
            }

            struct VertexInput
            {
                float4 vertex:POSITION;
                float4 normal:NORMAL;
                float4 texcoord: TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos:SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                v.vertex = vertexAnimFlag(v.vertex,v.texcoord);
                o.pos = UnityObjectToClipPos(v.vertex );
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                               

                return o;
            }

            half4 frag(VertexOutput i) : COLOR
            {
                return tex2D(_MainTex, i.texcoord);
            }
            ENDCG
        }
    }
}