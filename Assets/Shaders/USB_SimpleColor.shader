Shader "Unlit/USB_SimpleColor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)

		[Toggle] _Enable("Enable ?", Float) = 0

		[KeywordEnum(Off, Red, Blue)]
		_Options ("Color options", Float) = 0

		[PowerSlider (3.0)] _Bright("Bright", Range(0.1,1)) = 0.2



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

			#pragma shader_feature _ENABLE_ON
			#pragma multi_compile _OPTIONS_OF _OPTIONS_RED _OPTIONS_BLUE

            #include "UnityCG.cginc"

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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Color;

			float _Bright;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 col = tex2D(_MainTex, i.uv); 

				#if _ENABLE_ON  
				#if _OPTIONS_OFF

				
					return col * _Color * _Bright;
					#elif _OPTIONS_RED
					return col* float4(1,0,0,1)* _Bright *_Color;
					#elif _OPTIONS_BLUE
					return col* float4(0,0,1,1)* _Bright *_Color;
					#endif
				

				#else

						return col * _Color;

				#endif					

                return col * _Color  ;
            }
            ENDCG
        }
    }
}
