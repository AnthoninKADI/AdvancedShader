Shader "Unlit/Outline"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _Color("Main Color", Color) = (1, 1, 1, 1)
        _Outline("Outline Width", Range(0.001, 0.1)) = 0.01
        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Overlay"
            "IgnoreProjector" = "True"
            "RenderType" = "Overlay"
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma exclude_renderers gles xbox360 ps3
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : POSITION;
            };

            float4 _Color;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag(v2f i) : COLOR
            {
                return _Color * tex2D(_MainTex, i.pos.xy / i.pos.w);
            }
            ENDCG
        }
        
        ZWrite Off
        Cull Front

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma exclude_renderers gles xbox360 ps3
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : POSITION;
            };

            float _Outline;
            float4 _OutlineColor;

            v2f vert(appdata v)
            {
                float4x4 modelView = UnityObjectToWorld;
                float4 originalPos = mul(modelView, v.vertex);
                float4 offset = _Outline * originalPos;
                v.vertex.xyz += offset.xyz;

                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag(v2f i) : COLOR
            {
                return _OutlineColor;
            }
            ENDCG
        }
    }
}
