// Toony Colors Pro+Mobile 2
// (c) 2014-2023 Jean Moreno

Shader "Toony Colors Pro 2/User/Rooty_Shader01"
{
	Properties
	{
		[TCP2HeaderHelp(Base)]
		_Color ("Color", Color) = (1,1,1,1)
		[TCP2ColorNoAlpha] _HColor ("Highlight Color", Color) = (0.75,0.75,0.75,1)
		[TCP2ColorNoAlpha] _SColor ("Shadow Color", Color) = (0.2,0.2,0.2,1)
		[HideInInspector] __BeginGroup_ShadowHSV ("Shadow HSV", Float) = 0
		_Shadow_HSV_H ("Hue", Range(-180,180)) = 0
		_Shadow_HSV_S ("Saturation", Range(-1,1)) = 0
		_Shadow_HSV_V ("Value", Range(-1,1)) = 0
		[HideInInspector] __EndGroup ("Shadow HSV", Float) = 0
		[MainTexture] _MainTex ("Albedo", 2D) = "white" {}
		[TCP2Separator]

		[TCP2Header(Ramp Shading)]
		[TCP2Gradient] _Ramp ("Ramp Texture (RGB)", 2D) = "gray" {}
		_RampOffset ("Ramp Offset", Range(0,1)) = 0.5
		_RampSize ("Ramp Size", Range(0.001,1)) = 1
		[TCP2Separator]
		
		[TCP2HeaderHelp(Specular)]
		[Toggle(TCP2_SPECULAR)] _UseSpecular ("Enable Specular", Float) = 0
		[TCP2ColorNoAlpha] _SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_SpecularShadowAttenuation ("Specular Shadow Attenuation", Float) = 0.25
		_SpecularToonSize ("Toon Size", Range(0,1)) = 0.25
		_SpecularToonSmoothness ("Toon Smoothness", Range(0.001,0.5)) = 0.05
		[TCP2Separator]

		[TCP2HeaderHelp(Emission)]
		[TCP2ColorNoAlpha] [HDR] _Emission ("Emission Color", Color) = (0,0,0,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(Rim Lighting)]
		[Toggle(TCP2_RIM_LIGHTING)] _UseRim ("Enable Rim Lighting", Float) = 0
		[TCP2ColorNoAlpha] _RimColor ("Rim Color", Color) = (0.8,0.8,0.8,0.5)
		_RimMinVert ("Rim Min", Range(0,2)) = 0.5
		_RimMaxVert ("Rim Max", Range(0,2)) = 1
		//Rim Direction
		_RimDirVert ("Rim Direction", Vector) = (0,0,1,1)
		[TCP2Separator]

		[TCP2HeaderHelp(Reflections)]
		[Toggle(TCP2_REFLECTIONS)] _UseReflections ("Enable Reflections", Float) = 0
		[TCP2ColorNoAlpha] _ReflectionColor ("Color", Color) = (1,1,1,1)
		_ReflectionSmoothness ("Smoothness", Range(0,1)) = 0.5
		
		[NoScaleOffset] _Cube ("Reflection Cubemap", Cube) = "black" {}
		[TCP2ColorNoAlpha] _ReflectionCubemapColor ("Color", Color) = (1,1,1,1)
		_ReflectionCubemapRoughness ("Cubemap Roughness", Range(0,1)) = 0.5
		[HideInInspector] _ReflectionTex ("Planar Reflection RenderTexture", 2D) = "white" {}
		_FresnelMin ("Fresnel Min", Range(0,2)) = 0
		_FresnelMax ("Fresnel Max", Range(0,2)) = 1.5
		[TCP2Separator]
		
		[TCP2HeaderHelp(Subsurface Scattering)]
		[Toggle(TCP2_SUBSURFACE)] _UseSubsurface ("Enable Subsurface Scattering", Float) = 0
		_SubsurfaceDistortion ("Distortion", Range(0,2)) = 0.2
		_SubsurfacePower ("Power", Range(0.1,16)) = 3
		_SubsurfaceScale ("Scale", Float) = 1
		[TCP2ColorNoAlpha] _SubsurfaceColor ("Color", Color) = (0.5,0.5,0.5,1)
		[TCP2ColorNoAlpha] _SubsurfaceAmbientColor ("Ambient Color", Color) = (0.5,0.5,0.5,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(MatCap)]
		[Toggle(TCP2_MATCAP)] _UseMatCap ("Enable MatCap", Float) = 0
		[NoScaleOffset] [NoScaleOffset] _MatCapTex ("MatCap (RGB)", 2D) = "gray" {}
		[TCP2ColorNoAlpha] _MatCapColor ("MatCap Color", Color) = (1,1,1,1)
		[TCP2Separator]
		[TCP2HeaderHelp(Ambient Lighting)]
		[Toggle(TCP2_AMBIENT)] _UseAmbient ("Enable Ambient/Indirect Diffuse", Float) = 0
		//AMBIENT CUBEMAP
		_AmbientCube ("Ambient Cubemap", Cube) = "_Skybox" {}
		_TCP2_AMBIENT_RIGHT ("+X (Right)", Color) = (0,0,0,1)
		_TCP2_AMBIENT_LEFT ("-X (Left)", Color) = (0,0,0,1)
		_TCP2_AMBIENT_TOP ("+Y (Top)", Color) = (0,0,0,1)
		_TCP2_AMBIENT_BOTTOM ("-Y (Bottom)", Color) = (0,0,0,1)
		_TCP2_AMBIENT_FRONT ("+Z (Front)", Color) = (0,0,0,1)
		_TCP2_AMBIENT_BACK ("-Z (Back)", Color) = (0,0,0,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(Vertex Displacement)]
		[Toggle(TCP2_VERTEX_DISPLACEMENT)] _UseVertexDisplacement ("Enable Vertex Displacement", Float) = 0
		_WorldDisplacementTex ("World Displacement Texture", 2D) = "black" {}
		 _DisplacementStrength ("Displacement Strength", Range(-1,1)) = 0.01
		[TCP2Separator]
		[HideInInspector] __BeginGroup_ShadowHSV ("Shadow Line", Float) = 0
		_ShadowLineThreshold ("Threshold", Range(0,1)) = 0.5
		_ShadowLineSmoothing ("Smoothing", Range(0.001,0.1)) = 0.015
		_ShadowLineStrength ("Strength", Float) = 1
		_ShadowLineColor ("Color (RGB) Opacity (A)", Color) = (0,0,0,1)
		[HideInInspector] __EndGroup ("Shadow Line", Float) = 0
		
		[Toggle(TCP2_TEXTURED_THRESHOLD)] _UseTexturedThreshold ("Enable Textured Threshold", Float) = 0
		_StylizedThreshold ("Stylized Threshold", 2D) = "gray" {}
		[TCP2Separator]
		
		[TCP2ColorNoAlpha] _DiffuseTint ("Diffuse Tint", Color) = (1,0.5,0,1)
		[NoScaleOffset] _DiffuseTintMask ("Diffuse Tint Mask", 2D) = "white" {}
		[TCP2Separator]
		
		[TCP2HeaderHelp(Sketch)]
		[Toggle(TCP2_SKETCH)] _UseSketch ("Enable Sketch Effect", Float) = 0
		_ProgressiveSketchTexture ("Progressive Texture", 2D) = "black" {}
		_ProgressiveSketchSmoothness ("Progressive Smoothness", Range(0.005,0.5)) = 0.1
		[TCP2Separator]
		
		[TCP2HeaderHelp(Outline)]
		_OutlineWidth ("Width", Range(0.1,4)) = 1
		_OutlineColorVertex ("Color", Color) = (0,0,0,1)
		_OutlineOffset ("Offset", Vector) = (0,0,0,0)
		[Space]
		_OutlineZSmooth ("Z Correction", Range(-3,3)) = 0

		// Avoid compile error if the properties are ending with a drawer
		[HideInInspector] __dummy__ ("unused", Float) = 0
	}

	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
			"Queue"="AlphaTest+25"
		}

		CGINCLUDE

		#include "UnityCG.cginc"
		#include "UnityLightingCommon.cginc"	// needed for LightColor

		// Texture/Sampler abstraction
		#define TCP2_TEX2D_WITH_SAMPLER(tex)						UNITY_DECLARE_TEX2D(tex)
		#define TCP2_TEX2D_NO_SAMPLER(tex)							UNITY_DECLARE_TEX2D_NOSAMPLER(tex)
		#define TCP2_TEX2D_SAMPLE(tex, samplertex, coord)			UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, coord)
		#define TCP2_TEX2D_SAMPLE_LOD(tex, samplertex, coord, lod)	UNITY_SAMPLE_TEX2D_SAMPLER_LOD(tex, samplertex, coord, lod)

		// Shader Properties
		TCP2_TEX2D_WITH_SAMPLER(_WorldDisplacementTex);
		TCP2_TEX2D_WITH_SAMPLER(_MainTex);
		TCP2_TEX2D_WITH_SAMPLER(_MatCapTex);
		TCP2_TEX2D_WITH_SAMPLER(_StylizedThreshold);
		TCP2_TEX2D_WITH_SAMPLER(_ProgressiveSketchTexture);
		TCP2_TEX2D_WITH_SAMPLER(_DiffuseTintMask);
		sampler2D _Ramp;
		samplerCUBE _Cube;
		sampler2D _ReflectionTex;
		samplerCUBE _AmbientCube;
		
		// Shader Properties
		float4 _WorldDisplacementTex_ST;
		float _DisplacementStrength;
		float4 _OutlineOffset;
		float _OutlineZSmooth;
		float _OutlineWidth;
		fixed4 _OutlineColorVertex;
		float4 _RimDirVert;
		float _RimMinVert;
		float _RimMaxVert;
		float4 _MainTex_ST;
		fixed4 _Color;
		half4 _Emission;
		fixed4 _MatCapColor;
		float4 _StylizedThreshold_ST;
		float _RampOffset;
		float _RampSize;
		float _Shadow_HSV_H;
		float _Shadow_HSV_S;
		float _Shadow_HSV_V;
		float4 _ProgressiveSketchTexture_ST;
		float _ProgressiveSketchSmoothness;
		fixed4 _HColor;
		fixed4 _SColor;
		fixed4 _DiffuseTint;
		float _ShadowLineThreshold;
		float _ShadowLineStrength;
		float _ShadowLineSmoothing;
		fixed4 _ShadowLineColor;
		float _SubsurfaceDistortion;
		float _SubsurfacePower;
		float _SubsurfaceScale;
		fixed4 _SubsurfaceColor;
		fixed4 _SubsurfaceAmbientColor;
		float _SpecularToonSize;
		float _SpecularToonSmoothness;
		float _SpecularShadowAttenuation;
		fixed4 _SpecularColor;
		fixed4 _RimColor;
		float _ReflectionCubemapRoughness;
		fixed4 _ReflectionCubemapColor;
		float _FresnelMin;
		float _FresnelMax;
		fixed4 _ReflectionColor;
		float _ReflectionSmoothness;

		fixed4 _TCP2_AMBIENT_RIGHT;
		fixed4 _TCP2_AMBIENT_LEFT;
		fixed4 _TCP2_AMBIENT_TOP;
		fixed4 _TCP2_AMBIENT_BOTTOM;
		fixed4 _TCP2_AMBIENT_FRONT;
		fixed4 _TCP2_AMBIENT_BACK;

		//--------------------------------
		// HSV HELPERS
		// source: http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
		
		float3 rgb2hsv(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
			float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
		
			float d = q.x - min(q.w, q.y);
			float e = 1.0e-10;
			return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}
		
		float3 hsv2rgb(float3 c)
		{
			c.g = max(c.g, 0.0); //make sure that saturation value is positive
			float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
			float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
			return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
		}
		
		float3 ApplyHSV_3(float3 color, float h, float s, float v)
		{
			float3 hsv = rgb2hsv(color.rgb);
			hsv += float3(h/360,s,v);
			return hsv2rgb(hsv);
		}
		float3 ApplyHSV_3(float color, float h, float s, float v) { return ApplyHSV_3(color.xxx, h, s ,v); }
		
		float4 ApplyHSV_4(float4 color, float h, float s, float v)
		{
			float3 hsv = rgb2hsv(color.rgb);
			hsv += float3(h/360,s,v);
			return float4(hsv2rgb(hsv), color.a);
		}
		float4 ApplyHSV_4(float color, float h, float s, float v) { return ApplyHSV_4(color.xxxx, h, s, v); }
		
		//Specular help functions (from UnityStandardBRDF.cginc)
		inline float3 SpecSafeNormalize(float3 inVec)
		{
			half dp3 = max(0.001f, dot(inVec, inVec));
			return inVec * rsqrt(dp3);
		}
		
		half3 DirAmbient (half3 normal)
		{
			fixed3 retColor =
				saturate( normal.x * _TCP2_AMBIENT_RIGHT.rgb) +
				saturate(-normal.x * _TCP2_AMBIENT_LEFT.rgb) +
				saturate( normal.y * _TCP2_AMBIENT_TOP.rgb) +
				saturate(-normal.y * _TCP2_AMBIENT_BOTTOM.rgb) +
				saturate( normal.z * _TCP2_AMBIENT_FRONT.rgb) +
				saturate(-normal.z * _TCP2_AMBIENT_BACK.rgb);
			return retColor * 2.0;
		}
		
		// Cubic pulse function
		// Adapted from: http://www.iquilezles.org/www/articles/functions/functions.htm (c) 2017 - Inigo Quilez - MIT License
		float linearPulse(float c, float w, float x)
		{
			x = abs(x - c);
			if (x > w)
			{
				return 0;
			}
			x /= w;
			return 1 - x;
		}
		
		ENDCG

		// Outline Include
		CGINCLUDE

		struct appdata_outline
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 texcoord0 : TEXCOORD0;
			#if TCP2_UV2_AS_NORMALS
			float4 texcoord1 : TEXCOORD1;
		#elif TCP2_UV3_AS_NORMALS
			float4 texcoord2 : TEXCOORD2;
		#elif TCP2_UV4_AS_NORMALS
			float4 texcoord3 : TEXCOORD3;
		#endif
		#if TCP2_COLORS_AS_NORMALS
			float4 vertexColor : COLOR;
		#endif
		#if TCP2_TANGENT_AS_NORMALS
			float4 tangent : TANGENT;
		#endif
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		struct v2f_outline
		{
			float4 vertex : SV_POSITION;
			float4 screenPosition : TEXCOORD0;
			float4 vcolor : TEXCOORD1;
			float4 pack2 : TEXCOORD2; /* pack2.xyz = worldNormal  pack2.w = ndl */
			UNITY_VERTEX_OUTPUT_STEREO
		};

		v2f_outline vertex_outline (appdata_outline v)
		{
			v2f_outline output;
			UNITY_INITIALIZE_OUTPUT(v2f_outline, output);
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

			float3 worldNormalUv = mul(unity_ObjectToWorld, float4(v.normal, 1.0)).xyz;
			// Shader Properties Sampling
			float3 __vertexDisplacementWorld = ( TCP2_TEX2D_SAMPLE_LOD(_WorldDisplacementTex, _WorldDisplacementTex, v.texcoord0.xy * _WorldDisplacementTex_ST.xy + _WorldDisplacementTex_ST.zw, 0).rgb * _DisplacementStrength );
			float3 __outlineOffset = ( _OutlineOffset.xyz );
			float __outlineLightingWrapFactorVertex = ( 1.0 );
			float __outlineZsmooth = ( _OutlineZSmooth );
			float __outlineWidth = ( _OutlineWidth );
			float4 __outlineColorVertex = ( _OutlineColorVertex.rgba );

			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
			#if defined(TCP2_VERTEX_DISPLACEMENT)
			worldPos.xyz += __vertexDisplacementWorld;
			#endif
			v.vertex.xyz = mul(unity_WorldToObject, float4(worldPos, 1)).xyz;
			output.pack2.xyz = worldNormalUv;
			float4 clipPos = output.vertex;

			// Screen Position
			float4 screenPos = ComputeScreenPos(clipPos);
			output.screenPosition = screenPos;
			float3 objSpaceLight = normalize(mul(unity_WorldToObject, _WorldSpaceLightPos0).xyz);
			float3 normal = __outlineOffset;
			half lightWrap = __outlineLightingWrapFactorVertex;
			half ndl = max(0, (dot(v.normal.xyz, objSpaceLight.xyz) + lightWrap) / (1 + lightWrap));
			output.pack2.w = ndl;
		
			//Z correction in view space
			normal = mul(UNITY_MATRIX_V, float4(normal, 0)).xyz;
			normal.z += __outlineZsmooth;
			normal = mul(float4(normal, 0), UNITY_MATRIX_V).xyz;
		
			//Camera-independent outline size
			float dist = distance(_WorldSpaceCameraPos.xyz, mul(unity_ObjectToWorld, v.vertex).xyz);
			float size = dist;
		
		#if !defined(SHADOWCASTER_PASS)
			output.vertex = UnityObjectToClipPos(v.vertex.xyz + normal * __outlineWidth * size * 0.01);
		#else
			v.vertex = v.vertex + float4(normal,0) * __outlineWidth * size * 0.01;
		#endif
		
			output.vcolor.xyzw = __outlineColorVertex;

			return output;
		}

		float4 fragment_outline (v2f_outline input) : SV_Target
		{

			// Shader Properties Sampling
			float4 __outlineColor = ( float4(1,1,1,1) );

			half4 outlineColor = __outlineColor * input.vcolor.xyzw;
			outlineColor *= input.pack2.w;

			return outlineColor;
		}

		ENDCG
		// Outline Include End

		// Outline
		Pass
		{
			Name "Outline"
			Tags
			{
				"LightMode"="ForwardBase"
			}
			Cull Off
			ZWrite Off
			Offset 0,0
			Blend Off

			CGPROGRAM

			#pragma vertex vertex_outline
			#pragma fragment fragment_outline

			#pragma target 3.0

			#pragma multi_compile _ TCP2_COLORS_AS_NORMALS TCP2_TANGENT_AS_NORMALS TCP2_UV1_AS_NORMALS TCP2_UV2_AS_NORMALS TCP2_UV3_AS_NORMALS TCP2_UV4_AS_NORMALS
			#pragma multi_compile _ TCP2_UV_NORMALS_FULL TCP2_UV_NORMALS_ZW
			#pragma multi_compile_instancing
			
			//--------------------------------------
			// Toony Colors Pro 2 keywords
			#pragma shader_feature_local_vertex TCP2_VERTEX_DISPLACEMENT

			ENDCG
		}
		// Main Surface Shader

		CGPROGRAM

		#pragma surface surf ToonyColorsCustom vertex:vertex_surface exclude_path:deferred exclude_path:prepass keepalpha noambient nolightmap nofog nolppv
		#pragma target 3.0

		//================================================================
		// SHADER KEYWORDS

		#pragma shader_feature_local_fragment TCP2_SPECULAR
		#pragma shader_feature_local_vertex TCP2_VERTEX_DISPLACEMENT
		#pragma shader_feature_local TCP2_RIM_LIGHTING
		#pragma shader_feature_local_fragment TCP2_REFLECTIONS
		#pragma shader_feature_local_fragment TCP2_AMBIENT
		#pragma shader_feature_local TCP2_MATCAP
		#pragma shader_feature_local_fragment TCP2_SUBSURFACE
		#pragma shader_feature_local_fragment TCP2_SKETCH
		#pragma shader_feature_local_fragment TCP2_TEXTURED_THRESHOLD

		//================================================================
		// STRUCTS

		// Vertex input
		struct appdata_tcp2
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 texcoord0 : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
		#if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED)
			half4 tangent : TANGENT;
		#endif
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		struct Input
		{
			half3 viewDir;
			half3 worldNormal; INTERNAL_DATA
			float4 screenPosition;
			half rim;
			half2 matcap;
			float2 texcoord0;
		};

		//================================================================

		// Custom SurfaceOutput
		struct SurfaceOutputCustom
		{
			half atten;
			half3 Albedo;
			half3 Normal;
			half3 worldNormal;
			half3 Emission;
			half Specular;
			half Gloss;
			half Alpha;
			half ndv;
			half ndvRaw;

			Input input;

			// Shader Properties
			float __stylizedThreshold;
			float __stylizedThresholdScale;
			float __rampOffset;
			float __rampSize;
			float __shadowHue;
			float __shadowSaturation;
			float __shadowValue;
			float __shadowHsvMask;
			float4 __progressiveSketchTexture;
			float __progressiveSketchSmoothness;
			float3 __highlightColor;
			float3 __shadowColor;
			float3 __diffuseTint;
			float3 __diffuseTintMask;
			float __shadowLineThreshold;
			float __shadowLineStrength;
			float __shadowLineSmoothing;
			float4 __shadowLineColor;
			float __occlusion;
			float __ambientIntensity;
			float __subsurfaceDistortion;
			float __subsurfacePower;
			float __subsurfaceScale;
			float3 __subsurfaceColor;
			float3 __subsurfaceAmbientColor;
			float __subsurfaceThickness;
			float __specularToonSize;
			float __specularToonSmoothness;
			float __specularShadowAttenuation;
			float3 __specularColor;
			float3 __rimColor;
			float __rimStrength;
			float __reflectionCubemapRoughness;
			float3 __reflectionCubemapColor;
			float __fresnelMin;
			float __fresnelMax;
			float3 __reflectionColor;
			float __reflectionSmoothness;
		};

		//================================================================
		// VERTEX FUNCTION

		void vertex_surface(inout appdata_tcp2 v, out Input output)
		{
			UNITY_INITIALIZE_OUTPUT(Input, output);

			// Texture Coordinates
			output.texcoord0.xy = v.texcoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			// Shader Properties Sampling
			float3 __vertexDisplacementWorld = ( TCP2_TEX2D_SAMPLE_LOD(_WorldDisplacementTex, _WorldDisplacementTex, output.texcoord0.xy * _WorldDisplacementTex_ST.xy + _WorldDisplacementTex_ST.zw, 0).rgb * _DisplacementStrength );
			float3 __rimDirVert = ( _RimDirVert.xyz );
			float __rimMinVert = ( _RimMinVert );
			float __rimMaxVert = ( _RimMaxVert );

			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
			#if defined(TCP2_VERTEX_DISPLACEMENT)
			worldPos.xyz += __vertexDisplacementWorld;
			#endif
			v.vertex.xyz = mul(unity_WorldToObject, float4(worldPos, 1)).xyz;
			float4 clipPos = UnityObjectToClipPos(v.vertex);

			// Screen Position
			float4 screenPos = ComputeScreenPos(clipPos);
			output.screenPosition = screenPos;
			half3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

			#if defined(TCP2_RIM_LIGHTING)
			half3 rViewDir = viewDir;
			half3 rimDir = __rimDirVert;
			rViewDir = normalize(UNITY_MATRIX_V[0].xyz * rimDir.x + UNITY_MATRIX_V[1].xyz * rimDir.y + UNITY_MATRIX_V[2].xyz * rimDir.z);
			half rim = 1.0f - saturate(dot(rViewDir, v.normal.xyz));
			rim = smoothstep(__rimMinVert, __rimMaxVert, rim);
			output.rim = rim;
			#endif
			#if defined(TCP2_MATCAP)
			//MatCap
			float3 worldNorm = normalize(unity_WorldToObject[0].xyz * v.normal.x + unity_WorldToObject[1].xyz * v.normal.y + unity_WorldToObject[2].xyz * v.normal.z);
			worldNorm = mul((float3x3)UNITY_MATRIX_V, worldNorm);
			float3 perspectiveOffset = (screenPos.xyz / screenPos.w) - 0.5;
			worldNorm.xy -= (perspectiveOffset.xy * perspectiveOffset.z) * 0.5;
			output.matcap = worldNorm.xy * 0.5 + 0.5;
			#endif

		}

		//================================================================
		// SURFACE FUNCTION

		void surf(Input input, inout SurfaceOutputCustom output)
		{
			//Screen Space UV
			float2 screenUV = input.screenPosition.xy / input.screenPosition.w;
			
			// Shader Properties Sampling
			float4 __albedo = ( TCP2_TEX2D_SAMPLE(_MainTex, _MainTex, input.texcoord0.xy).rgba );
			float4 __mainColor = ( _Color.rgba );
			float __alpha = ( __albedo.a * __mainColor.a );
			float3 __emission = ( _Emission.rgb );
			float3 __matcapColor = ( _MatCapColor.rgb );
			output.__stylizedThreshold = ( TCP2_TEX2D_SAMPLE(_StylizedThreshold, _StylizedThreshold, input.texcoord0.xy * _StylizedThreshold_ST.xy + _StylizedThreshold_ST.zw).a );
			output.__stylizedThresholdScale = ( 1.0 );
			output.__rampOffset = ( _RampOffset );
			output.__rampSize = ( _RampSize );
			output.__shadowHue = ( _Shadow_HSV_H );
			output.__shadowSaturation = ( _Shadow_HSV_S );
			output.__shadowValue = ( _Shadow_HSV_V );
			output.__shadowHsvMask = ( __albedo.a );
			output.__progressiveSketchTexture = ( TCP2_TEX2D_SAMPLE(_ProgressiveSketchTexture, _ProgressiveSketchTexture, screenUV * _ScreenParams.zw * _ProgressiveSketchTexture_ST.xy + _ProgressiveSketchTexture_ST.zw).rgba );
			output.__progressiveSketchSmoothness = ( _ProgressiveSketchSmoothness );
			output.__highlightColor = ( _HColor.rgb );
			output.__shadowColor = ( _SColor.rgb );
			output.__diffuseTint = ( _DiffuseTint.rgb );
			output.__diffuseTintMask = ( TCP2_TEX2D_SAMPLE(_DiffuseTintMask, _DiffuseTintMask, input.texcoord0.xy).rgb );
			output.__shadowLineThreshold = ( _ShadowLineThreshold );
			output.__shadowLineStrength = ( _ShadowLineStrength );
			output.__shadowLineSmoothing = ( _ShadowLineSmoothing );
			output.__shadowLineColor = ( _ShadowLineColor.rgba );
			output.__occlusion = ( __albedo.a );
			output.__ambientIntensity = ( 1.0 );
			output.__subsurfaceDistortion = ( _SubsurfaceDistortion );
			output.__subsurfacePower = ( _SubsurfacePower );
			output.__subsurfaceScale = ( _SubsurfaceScale );
			output.__subsurfaceColor = ( _SubsurfaceColor.rgb );
			output.__subsurfaceAmbientColor = ( _SubsurfaceAmbientColor.rgb );
			output.__subsurfaceThickness = ( 1.0 );
			output.__specularToonSize = ( _SpecularToonSize );
			output.__specularToonSmoothness = ( _SpecularToonSmoothness );
			output.__specularShadowAttenuation = ( _SpecularShadowAttenuation );
			output.__specularColor = ( _SpecularColor.rgb );
			output.__rimColor = ( _RimColor.rgb );
			output.__rimStrength = ( 1.0 );
			output.__reflectionCubemapRoughness = ( _ReflectionCubemapRoughness );
			output.__reflectionCubemapColor = ( _ReflectionCubemapColor.rgb );
			output.__fresnelMin = ( _FresnelMin );
			output.__fresnelMax = ( _FresnelMax );
			output.__reflectionColor = ( _ReflectionColor.rgb );
			output.__reflectionSmoothness = ( _ReflectionSmoothness );

			output.input = input;

			half3 worldNormal = WorldNormalVector(input, output.Normal);
			output.worldNormal = worldNormal;

			half ndv = abs(dot(input.viewDir, normalize(output.Normal.xyz)));
			half ndvRaw = ndv;
			output.ndv = ndv;
			output.ndvRaw = ndvRaw;

			output.Albedo = __albedo.rgb;
			output.Alpha = __alpha;

			output.Albedo *= __mainColor.rgb;
			output.Emission += __emission;
			
			//MatCap
			#if defined(TCP2_MATCAP)
			half2 capCoord = input.matcap;
			half3 matcap = ( TCP2_TEX2D_SAMPLE(_MatCapTex, _MatCapTex, capCoord).rgb ) * __matcapColor;
			output.Albedo *= matcap;
			#endif

		}

		//================================================================
		// LIGHTING FUNCTION

		inline half4 LightingToonyColorsCustom(inout SurfaceOutputCustom surface, half3 viewDir, UnityGI gi)
		{

			half ndv = surface.ndv;
			half3 lightDir = gi.light.dir;
			#if defined(UNITY_PASS_FORWARDBASE)
				half3 lightColor = _LightColor0.rgb;
				half atten = surface.atten;
			#else
				// extract attenuation from point/spot lights
				half3 lightColor = _LightColor0.rgb;
				half atten = max(gi.light.color.r, max(gi.light.color.g, gi.light.color.b)) / max(_LightColor0.r, max(_LightColor0.g, _LightColor0.b));
			#endif

			half3 normal = normalize(surface.Normal);
			half ndl = dot(normal, lightDir);
			#if defined(TCP2_TEXTURED_THRESHOLD)
			float stylizedThreshold = surface.__stylizedThreshold;
			stylizedThreshold -= 0.5;
			stylizedThreshold *= surface.__stylizedThresholdScale;
			ndl += stylizedThreshold;
			#endif
			// Apply attenuation (shadowmaps & point/spot lights attenuation)
			ndl *= atten;
			half3 ramp;
			
			//Define ramp threshold and smoothstep depending on context
			#define		RAMP_TEXTURE	_Ramp
			#define		RAMP_THRESHOLD	surface.__rampOffset
			#define		RAMP_SMOOTH		surface.__rampSize
			half2 rampUv = ndl.xx * 0.5 + 0.5;
			half remap_min = RAMP_THRESHOLD - RAMP_SMOOTH*0.5;
			half diff = (RAMP_THRESHOLD + RAMP_SMOOTH*0.5) - remap_min;
			rampUv = saturate(rampUv * (1.0 / diff) - (remap_min / diff));
			ramp = tex2D(RAMP_TEXTURE, rampUv).rgb;

			//Shadow HSV
			float3 albedoShadowHSV = ApplyHSV_3(surface.Albedo, surface.__shadowHue, surface.__shadowSaturation, surface.__shadowValue);
			surface.Albedo = lerp(albedoShadowHSV, surface.Albedo, ramp + surface.__shadowHsvMask * (1 - ramp));
			
			// Sketch
			#if defined(TCP2_SKETCH)
			half4 sketch = surface.__progressiveSketchTexture;
			half4 sketchWeights = half4(0,0,0,0);
			half sketchStep = 1.0 / 5.0;
			half sketchSmooth = surface.__progressiveSketchSmoothness;
			sketchWeights.a = smoothstep(sketchStep + sketchSmooth, sketchStep - sketchSmooth, ramp);
			sketchWeights.b = smoothstep(sketchStep*2 + sketchSmooth, sketchStep*2 - sketchSmooth, ramp) - sketchWeights.a;
			sketchWeights.g = smoothstep(sketchStep*3 + sketchSmooth, sketchStep*3 - sketchSmooth, ramp) - sketchWeights.a - sketchWeights.b;
			sketchWeights.r = smoothstep(sketchStep*4 + sketchSmooth, sketchStep*4 - sketchSmooth, ramp) - sketchWeights.a - sketchWeights.b - sketchWeights.g;
			half combinedSketch = 1.0 - dot(sketch, sketchWeights);
			
			#endif

			// Highlight/Shadow Colors
			#if !defined(UNITY_PASS_FORWARDBASE)
				ramp = lerp(half3(0,0,0), surface.__highlightColor, ramp);
			#else
				ramp = lerp(surface.__shadowColor, surface.__highlightColor, ramp);
			#endif

			// Diffuse Tint
			half3 diffuseTint = saturate(surface.__diffuseTint + ndl);
			ramp = lerp(ramp, ramp * diffuseTint, surface.__diffuseTintMask);
			
			//Shadow Line
			float ndlAtten = ndl * atten;
			float shadowLineThreshold = surface.__shadowLineThreshold;
			float shadowLineStrength = surface.__shadowLineStrength;
			float shadowLineFw = fwidth(ndlAtten);
			float shadowLineSmoothing = surface.__shadowLineSmoothing * shadowLineFw * 10;
			float shadowLine = min(linearPulse(ndlAtten, shadowLineSmoothing, shadowLineThreshold) * shadowLineStrength, 1.0);
			half4 shadowLineColor = surface.__shadowLineColor;
			ramp = lerp(ramp.rgb, shadowLineColor.rgb, shadowLine * shadowLineColor.a);

			// Output color
			half4 color;
			color.rgb = surface.Albedo * lightColor.rgb * ramp;
			color.a = surface.Alpha;
			#if defined(TCP2_SKETCH)
			color.rgb *= combinedSketch;
			#endif

			// Apply indirect lighting (ambient)
			half occlusion = surface.__occlusion;
			#ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
			#if defined(TCP2_AMBIENT)
				half3 ambient = gi.indirect.diffuse;
				
				//Ambient Cubemap
				ambient.rgb += texCUBE(_AmbientCube, normal);
				
				//Directional Ambient
				ambient.rgb += DirAmbient(normal);
				ambient *= surface.Albedo * occlusion * surface.__ambientIntensity;

				#if defined(TCP2_SKETCH)
				ambient.rgb *= combinedSketch;
				#endif
				color.rgb += ambient;
			#endif
			#endif

				//Subsurface Scattering
			#if defined(TCP2_SUBSURFACE)
			#if (POINT || SPOT)
				half3 ssLight = lightDir + normal * surface.__subsurfaceDistortion;
				half ssDot = pow(saturate(dot(viewDir, -ssLight)), surface.__subsurfacePower) * surface.__subsurfaceScale;
				half3 ssColor = ((ssDot * surface.__subsurfaceColor) + surface.__subsurfaceAmbientColor) * surface.__subsurfaceThickness;
			#if !defined(UNITY_PASS_FORWARDBASE)
				ssColor *= atten;
			#endif
				color.rgb *= surface.Albedo * ssColor;
			#endif
			#endif

			half3 halfDir = SpecSafeNormalize(float3(lightDir) + float3(viewDir));
			
			#if defined(TCP2_SPECULAR)
			//Blinn-Phong Specular
			float ndh = max(0, dot (normal, halfDir));
			float spec = smoothstep(surface.__specularToonSize + surface.__specularToonSmoothness, surface.__specularToonSize - surface.__specularToonSmoothness,1 - (ndh / (1+surface.__specularToonSmoothness)));
			spec *= ndl;
			half specShadowAtten = saturate(atten * ndl + surface.__specularShadowAttenuation);
			spec *= specShadowAtten;
			
			//Apply specular
			color.rgb += spec * lightColor.rgb * surface.__specularColor;
			#endif
			// Rim Lighting
			#if defined(TCP2_RIM_LIGHTING)
			half rim = surface.input.rim;
			rim = ( rim );
			half3 rimColor = surface.__rimColor;
			half rimStrength = surface.__rimStrength;
			//Rim light mask
			color.rgb += ndl * atten * rim * rimColor * rimStrength;
			#endif
			// ForwardBase pass only
			#if !defined(UNITY_PASS_FORWARDADD)

				#if defined(TCP2_REFLECTIONS)
					// Reflection probes/skybox
					half3 reflections = gi.indirect.specular * occlusion;
					#if defined(TCP2_REFLECTIONS)
					// Reflection cubemap
					half3 reflectVector = reflect(-viewDir, surface.worldNormal);
					reflections.rgb += texCUBElod(_Cube, half4(reflectVector.xyz, surface.__reflectionCubemapRoughness * 10.0)).rgb;
					reflections.rgb *= surface.__reflectionCubemapColor;
					reflections.rgb += tex2D(_ReflectionTex, surface.input.screenPosition.xy / surface.input.screenPosition.w).rgb;
					#endif
					half fresnelMin = surface.__fresnelMin;
					half fresnelMax = surface.__fresnelMax;
					half fresnelTerm = smoothstep(fresnelMin, fresnelMax, 1 - surface.ndvRaw);
					reflections *= fresnelTerm;
					reflections *= surface.__reflectionColor;
					color.rgb += reflections;
				#endif

			#endif

			return color;
		}

		void LightingToonyColorsCustom_GI(inout SurfaceOutputCustom surface, UnityGIInput data, inout UnityGI gi)
		{
			half3 normal = surface.Normal;

			#if defined(TCP2_REFLECTIONS)
			// GI with reflection probes support
			half smoothness = surface.__reflectionSmoothness;
			Unity_GlossyEnvironmentData g = UnityGlossyEnvironmentSetup(smoothness, data.worldViewDir, normal, half3(0,0,0));	// last parameter is actually unused
			gi = UnityGlobalIllumination(data, 1.0, normal, g); // occlusion is applied in the lighting function, if necessary
			#else
			gi = UnityGlobalIllumination(data, 1.0, normal); // occlusion is applied in the lighting function, if necessary
			#endif

			surface.atten = data.atten; // transfer attenuation to lighting function
			gi.light.color = _LightColor0.rgb; // remove attenuation

		}

		ENDCG

		// Outline - Depth Pass Only
		Pass
		{
			Name "Outline Depth"
			Tags
			{
				"LightMode"="ForwardBase"
			}
			Cull Off
			Offset 0,0

			// Write to Depth Buffer only
			ColorMask 0
			ZWrite On

			CGPROGRAM
			#pragma vertex vertex_outline
			#pragma fragment fragment_outline
			#pragma multi_compile _ TCP2_COLORS_AS_NORMALS TCP2_TANGENT_AS_NORMALS TCP2_UV1_AS_NORMALS TCP2_UV2_AS_NORMALS TCP2_UV3_AS_NORMALS TCP2_UV4_AS_NORMALS
			#pragma multi_compile _ TCP2_UV_NORMALS_FULL TCP2_UV_NORMALS_ZW
			#pragma multi_compile_instancing
			#pragma target 3.0
			ENDCG
		}
		//================================================================
		// SHADOW CASTER PASS

		// Shadow Caster (for shadows and depth texture)
		Pass
		{
			Name "ShadowCaster"
			Tags
			{
				"LightMode" = "ShadowCaster"
			}
			ZWrite On
			Blend Off

			CGPROGRAM

			#define SHADOWCASTER_PASS

			#pragma vertex vertex_shadowcaster
			#pragma fragment fragment_shadowcaster
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing

			#pragma multi_compile TCP2_NONE TCP2_ZSMOOTH_ON
			#pragma multi_compile TCP2_NONE TCP2_OUTLINE_CONST_SIZE
			#pragma multi_compile _ TCP2_COLORS_AS_NORMALS TCP2_TANGENT_AS_NORMALS TCP2_UV1_AS_NORMALS TCP2_UV2_AS_NORMALS TCP2_UV3_AS_NORMALS TCP2_UV4_AS_NORMALS
			#pragma multi_compile _ TCP2_UV_NORMALS_FULL TCP2_UV_NORMALS_ZW

			#pragma shader_feature_local_vertex TCP2_VERTEX_DISPLACEMENT

			// half _Cutoff;

			struct appdata_shadowcaster
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
			#if TCP2_COLORS_AS_NORMALS
				float4 vertexColor : COLOR;
			#endif
			// TODO: need a way to know if texcoord1 is used in the Shader Properties
			#if TCP2_UV2_AS_NORMALS
				float2 uv2 : TEXCOORD1;
			#endif
			#if TCP2_TANGENT_AS_NORMALS
				float4 tangent : TANGENT;
			#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f_shadowcaster
			{
				V2F_SHADOW_CASTER_NOPOS
				float4 screenPosition : TEXCOORD1;
				float4 vcolor : TEXCOORD2;
				float4 pack2 : TEXCOORD3; /* pack2.xyz = worldNormal  pack2.w = ndl */
				UNITY_VERTEX_OUTPUT_STEREO
			};

			void vertex_shadowcaster (appdata_shadowcaster v, out v2f_shadowcaster output, out float4 opos : SV_POSITION)
			{
				UNITY_INITIALIZE_OUTPUT(v2f_shadowcaster, output);
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				float3 worldNormalUv = mul(unity_ObjectToWorld, float4(v.normal, 1.0)).xyz;
				// Shader Properties Sampling
				float3 __vertexDisplacementWorld = ( TCP2_TEX2D_SAMPLE_LOD(_WorldDisplacementTex, _WorldDisplacementTex, v.texcoord0.xy * _WorldDisplacementTex_ST.xy + _WorldDisplacementTex_ST.zw, 0).rgb * _DisplacementStrength );
				float3 __outlineOffset = ( _OutlineOffset.xyz );
				float __outlineLightingWrapFactorVertex = ( 1.0 );
				float __outlineZsmooth = ( _OutlineZSmooth );
				float __outlineWidth = ( _OutlineWidth );
				float4 __outlineColorVertex = ( _OutlineColorVertex.rgba );

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#if defined(TCP2_VERTEX_DISPLACEMENT)
				worldPos.xyz += __vertexDisplacementWorld;
				#endif
				v.vertex.xyz = mul(unity_WorldToObject, float4(worldPos, 1)).xyz;
				output.pack2.xyz = worldNormalUv;
				float3 objSpaceLight = normalize(mul(unity_WorldToObject, _WorldSpaceLightPos0).xyz);
				float3 normal = __outlineOffset;
				half lightWrap = __outlineLightingWrapFactorVertex;
				half ndl = max(0, (dot(v.normal.xyz, objSpaceLight.xyz) + lightWrap) / (1 + lightWrap));
				output.pack2.w = ndl;
			
				//Z correction in view space
				normal = mul(UNITY_MATRIX_V, float4(normal, 0)).xyz;
				normal.z += __outlineZsmooth;
				normal = mul(float4(normal, 0), UNITY_MATRIX_V).xyz;
			
				//Camera-independent outline size
				float dist = distance(_WorldSpaceCameraPos.xyz, mul(unity_ObjectToWorld, v.vertex).xyz);
				float size = dist;
			
			#if !defined(SHADOWCASTER_PASS)
				output.vertex = UnityObjectToClipPos(v.vertex.xyz + normal * __outlineWidth * size * 0.01);
			#else
				v.vertex = v.vertex + float4(normal,0) * __outlineWidth * size * 0.01;
			#endif
			
				output.vcolor.xyzw = __outlineColorVertex;
				float4 clipPos = UnityObjectToClipPos(v.vertex);

				// Screen Position
				float4 screenPos = ComputeScreenPos(clipPos);
				output.screenPosition = screenPos;

				TRANSFER_SHADOW_CASTER_NOPOS(output,opos)
			}

			half4 fragment_shadowcaster(v2f_shadowcaster input, UNITY_VPOS_TYPE vpos : VPOS) : SV_Target
			{

				SHADOW_CASTER_FRAGMENT(input)
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
	CustomEditor "ToonyColorsPro.ShaderGenerator.MaterialInspector_SG2"
}

/* TCP_DATA u config(ver:"2.9.9";unity:"2022.3.10f1";tmplt:"SG2_Template_Default";features:list["UNITY_5_4","UNITY_5_5","UNITY_5_6","UNITY_2017_1","UNITY_2018_1","UNITY_2018_2","UNITY_2018_3","UNITY_2019_1","UNITY_2019_2","UNITY_2019_3","UNITY_2019_4","UNITY_2020_1","UNITY_2021_1","UNITY_2021_2","UNITY_2022_2","RIM","TEXTURE_RAMP_SLIDERS","SPEC_LEGACY","SPECULAR","SPECULAR_SHADER_FEATURE","SPECULAR_TOON","RIM_SHADER_FEATURE","OUTLINE","OUTLINE_OPAQUE","OUTLINE_ZSMOOTH","SHADOW_LINE","SHADOW_LINE_CRISP_AA","TEXTURED_THRESHOLD","TT_SHADER_FEATURE","DIFFUSE_TINT","DIFFUSE_TINT_MASK","SKETCH_AMBIENT","SKETCH_SHADER_FEATURE","SKETCH_PROGRESSIVE","SKETCH_PROGRESSIVE_SMOOTH","OUTLINE_DEPTH","OUTLINE_CONSTANT_SIZE","OUTLINE_BEHIND_DEPTH","OUTLINE_LIGHTING_WRAP","OUTLINE_LIGHTING_VERT","OUTLINE_LIGHTING","OUTLINE_FAKE_RIM","OUTLINE_SHADOWCASTER","TEXTURE_RAMP","RIM_VERTEX","RIM_DIR","RIM_DIR_PERSP_CORRECTION","RIM_LIGHTMASK","EMISSION","SPECULAR_NO_ATTEN","SUBSURFACE_SCATTERING","SUBSURFACE_AMB_COLOR","SS_MULTIPLICATIVE","SS_NO_LIGHTCOLOR","SS_SHADER_FEATURE","SHADOW_HSV","SHADOW_HSV_MASK","ATTEN_AT_NDL","GLOSSY_REFLECTIONS","PLANAR_REFLECTION","REFLECTION_CUBEMAP","REFL_ROUGH","REFLECTION_FRESNEL","REFLECTION_SHADER_FEATURE","MATCAP","MATCAP_MULT","MATCAP_PERSPECTIVE_CORRECTION","MATCAP_SHADER_FEATURE","CUBE_AMBIENT","DIRAMBIENT","OCCLUSION","AMBIENT_SHADER_FEATURE","VERTEX_DISPLACEMENT_WORLD","VERTEX_DISP_SHADER_FEATURE"];flags:list["noambient"];flags_extra:dict[];keywords:dict[RENDER_TYPE="Opaque",RampTextureDrawer="[TCP2Gradient]",RampTextureLabel="Ramp Texture",SHADER_TARGET="3.0",RIM_LABEL="Rim Lighting"];shaderProperties:list[];customTextures:list[];codeInjection:codeInjection(injectedFiles:list[];mark:False);matLayers:list[]) */
/* TCP_HASH 72450c0c74a53a34f0b61ba7baf2c0c9 */
