Shader "Unlit/TextureShader"
{
   Properties
   {
       _MainTex("Main Texture", 2D) = "white"{}
       _Color ("Main Color", Color) = (1,1,1,1)
       _Height ("Height", Float) = 0.1
   }
   SubShader
   {

       Tags{
       "Queue" = "Transparent"
       "RenderType" = "Transparent"
       "IgnoreProjector" = "True"
       }
       Pass
       { 
           Blend SrcAlpha OneMinusSrcAlpha
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           uniform half4 _Color;
           uniform sampler2D _MainTex;
           uniform float4 _MainTex_ST;
           uniform float _Height;


          struct VertexInput
          {
              float4 vertex: POSITION;
              float4 normal: NORMAL;
              float4 texcoord: TEXCOORD0;
          };

           struct VertexOutput
           {
               float4 pos: SV_POSITION;
               float4 texcoord: TEXCOORD0;
           };

           VertexOutput vert(VertexInput v)
           {
               VertexOutput o;
               float displacement = tex2Dlod(_MainTex, v.texcoord* _MainTex_ST);
               o.pos = UnityObjectToClipPos(v.vertex + (v.normal * displacement* _Height));
               o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
               return o;
           }

           half4 frag(VertexOutput i): COLOR   //half4 will be treated as a color
           {
               return tex2D(_MainTex, i.texcoord) * _Color;
           }
          
           ENDCG
       }
   }
}
