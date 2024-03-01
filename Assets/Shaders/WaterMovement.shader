Shader "Unlit/WaterMovement"
{ 
    Properties{
        _Color("Color",Color) = (1,1,1,1)
        _SecondaryColor("Secondary Color",Color) = (1,1,1,1)
        //_MainTex("Main Texture", 2D) = "white"{}
        _NoiseTexF("Noise Texture", 2D) = "black" {}
        _HeightFactor("Height", float) =0.1
        _Speed("Speed", float) = 0
        _Frequency("Frequency", float) = 0
        _Amplitude("Amplitude", float) = 0

    }
    SubShader
    {
        Tags { 

        }
       
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;
            uniform half4 _SecondaryColor;
            uniform sampler2D _NoiseTexF;
            uniform float4 _NoiseTexF_ST;
            uniform sampler2D _NoiseTexS;
            uniform float4 _NoiseTexS_ST;
            uniform float _HeightFactor;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;

            #include "UnityCG.cginc"


            float4 vertexAnimFlag(float4 pos, float2 uv)
            {
                pos.y = pos.y + sin((uv.y - _Time.y * _Speed) * _Frequency) * _Amplitude/100;// * uv.y
                
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
                float4 displacement:COLOR; 
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                v.vertex = vertexAnimFlag(v.vertex,v.texcoord);
                float4 offset = (v.normal * tex2Dlod(_NoiseTexF, v.texcoord*_NoiseTexF_ST)*_HeightFactor);
                o.pos = UnityObjectToClipPos(v.vertex + offset);
                o.texcoord.xy = (v.texcoord.xy * _NoiseTexF_ST.xy + _NoiseTexF_ST.zw);
                //o.displacement = lerp(_Color,_SecondaryColor,v.vertex.y);
                float percentage = (v.vertex.y + offset.y) / _HeightFactor;
                o.displacement = (_Color * percentage + _SecondaryColor * (1-percentage));
                
                return o;
            }

            half4 frag(VertexOutput i) : COLOR
            {
            return i.displacement;
                //tex2D(_NoiseTexF, i.texcoord) * _Color + (1-tex2D(_NoiseTexF, i.texcoord)) * _SecondaryColor;
            }
            ENDCG
        }
    }
}