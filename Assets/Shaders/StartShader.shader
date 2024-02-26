Shader "Unlit/StartShader"
{
   Properties
   {
       _Color ("Main Color", Color) = (1,1,1,1)
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
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           uniform half4 _Color;

           struct VertexInput
           {
               float4 vertex: POSITION;
           };
           struct VertexOutput
           {
               float4 pos: SV_POSITION;
           };

           VertexOutput vert(VertexInput v)
           {
               VertexOutput o;
               o.pos = UnityObjectToClipPos(v.vertex);
               return o;
           }

           half4 frag(VertexOutput i): COLOR   //half4 will be treated as a color
           {
               return _Color;
           }
          
           ENDCG
       }
   }
}
