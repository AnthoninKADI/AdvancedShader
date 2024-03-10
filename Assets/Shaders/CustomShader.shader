Shader "Unlit/CustomShader"
{
   Properties
   {
       _Start("Main Start", float) = 0.5
       _Width("Main Width", float) = 0.5

       _Amount("Number of Line", int) = 1
       _Speed("Speed", Float) = 1
       _MainTex("Main Texture", 2D) = "white"{}
       _Color ("Main Color", Color) = (1,1,1,1)
       
       _SecTex("Second Texture", 2D) = "white"{}
       _Color2 ("Second Color", Color) = (1,1,1,1)
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
           uniform half4 _Color2;
           uniform sampler2D _MainTex;
           uniform sampler2D _SecTex;
           uniform float4 _MainTex_ST;
           uniform float _Speed;

           float _Start;
           float _Width;

           int _Amount;
           
            float4 vertexAnimMove(float4 pos)
            {
                _MainTex_ST.w += _Speed *_Time.z;
                return pos;
            }
           
           struct VertexInput
           {
               float4 vertex: POSITION;
               float4 texcoord: TEXCOORD0;
           };
           struct VertexOutput
           {
               float4 pos: SV_POSITION;
               float4 texcoord: TEXCOORD0;
           };

           float drawLine(float2 uv, float start, float end)
           {
              if(uv.x > start && uv.x < end)
              {
                  return 1;
              }
              return 0;
           }


           VertexOutput vert(VertexInput v)
           {
               VertexOutput o;
               v.vertex = vertexAnimMove(v.vertex);
               o.pos = UnityObjectToClipPos(v.vertex);
               o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
               return o;
           }

         half4 frag(VertexOutput i): COLOR  
           {
           half4 color;
           float percent = (1.0/_Amount) * 100.0;
           if((i.texcoord.x*100)% (2*percent)<percent)
           {
                color = tex2D(_MainTex, i.texcoord)*_Color;
           }

           else 
           {
                color = tex2D(_SecTex, i.texcoord)*_Color2;
           }
              return color;
           }

          
           ENDCG
       }
   }
}
