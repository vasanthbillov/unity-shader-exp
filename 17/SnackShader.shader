Shader "Vasanth/SnackShader"
{

        Properties 
        {
            _Color ("Main Color", Color) = (1,1,1,1)
            _len ("len", int) = 100
        }
    
        SubShader
        {
            Tags { "RenderType"="Opaque" }
            blend SrcAlpha OneMinusSrcAlpha
            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
    
                #include "UnityCG.cginc"
    
                uniform half4 _Color;
                uniform int _len;
                uniform float _FloatArray[100]; 
    
                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 texcoord : TEXCOORD0;
                };
    
                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float2 texcoord : TEXCOORD0;
                };
    
                v2f vert (appdata v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.texcoord = v.texcoord;
                    return o;
                }
                
                float drawBox(float2 uv, float2 boxPos, float2 boxSize)
                {
                    float2 d = ((uv - boxPos) / boxSize)*0.5;
                    float2 s = smoothstep(0.0, 1.0, d) * smoothstep(0.0, 1.0, 1.0 - d);
                    return s.x * s.y;
                }

    
                float4 frag (v2f i) : SV_Target
                {
                    float shapeAlpha = 0.0;
                    float boxSize = 0.1; 
    
                    for (int y = 0; y < 10; y++) //rows
                    {
                        for (int x = 0; x < 10; x++) // 5 columns
                        {
                            int idx = y * 10 + x;
                            if (idx >= _len) break;
    
                            float2 boxPos = float2(x * boxSize, y * boxSize);
                            float boxValue = drawBox(i.texcoord, boxPos, float2(boxSize, boxSize));
                            shapeAlpha += boxValue * _FloatArray[idx];
                        }
                    }

                    float OutshapeAlpha = 0.0;
                    float OutboxSize = 0.105; 
    
                    for (int y = 0; y < 10; y++) // 5 rows
                    {
                        for (int x = 0; x < 10; x++) // 5 columns
                        {
                            int idx = y * 10 + x;
                            if (idx >= _len) break;
    
                            float2 boxPos = float2(x * OutboxSize, y * OutboxSize);
                            float boxValue = drawBox(i.texcoord, boxPos, float2(OutboxSize, OutboxSize));
                            OutshapeAlpha += boxValue * _FloatArray[idx];
                        }
                    }

                    float val = clamp(OutshapeAlpha,0,1);
                    float newShape = clamp(shapeAlpha,0,1) + val;
    
                    return float4(1, abs(sin(val)), val*cos(_Time.y), newShape) *_Color;
                }
                ENDCG
            }
        }
        FallBack "Diffuse"
    }
    