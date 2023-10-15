﻿// Unity built-in shader source. Copyright (c) 2016 Unity Technologies.
// Modified by leomovskii

Shader "Sprites/Grayscale" {

	Properties {
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap("Pixel snap", Float) = 0
		[HideInInspector] _RendererColor("RendererColor", Color) = (1,1,1,1)
		[HideInInspector] _Flip("Flip", Vector) = (1,1,1,1)
		[PerRendererData] _AlphaTex("External Alpha", 2D) = "white" {}
		[PerRendererData] _EnableExternalAlpha("Enable External Alpha", Float) = 0
	}

	SubShader {
		Tags {
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

		Pass {
			CGPROGRAM
				#pragma vertex SpriteVert
				#pragma fragment SpriteGrayScale
				#pragma target 2.0
				#pragma multi_compile_instancing
				#pragma multi_compile_local _ PIXELSNAP_ON
				#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
				#include "UnitySprites.cginc"
				#define GRAY_WEIGHTS float3(0.299, 0.587, 0.114)

				fixed4 SpriteGrayScale(v2f IN) : SV_Target {
					fixed4 col = SampleSpriteTexture(IN.texcoord) * IN.color;
					float gray = dot(col.rgb, GRAY_WEIGHTS) * col.a;
					return float4(gray, gray, gray, col.a);
				}
			ENDCG
		}
	}
}