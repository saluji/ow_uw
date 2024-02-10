// Toony Colors Pro+Mobile 2
// (c) 2014-2023 Jean Moreno

// Terrain BasePass shader:
// This shader is used when the terrain is viewed from the "Base Distance" setting.
// It uses low resolution generated textures from the "BaseGen" shader to draw the terrain entirely,
// thus preventing to perform the full splat map blending code to increase performances.

Shader "Hidden/Toony Colors Pro 2/User/My TCP2 Shader-BasePass"
{
	Properties
	{
		[TCP2HeaderHelp(Base)]
		_Color ("Color", Color) = (1,1,1,1)
		[TCP2ColorNoAlpha] _HColor ("Highlight Color", Color) = (0.75,0.75,0.75,1)
		[TCP2ColorNoAlpha] _SColor ("Shadow Color", Color) = (0.2,0.2,0.2,1)
		[TCP2Separator]

		[TCP2Header(Ramp Shading)]
		[TCP2Gradient] _Ramp ("Ramp Texture (RGB)", 2D) = "gray" {}
		[TCP2Separator]
		[TCP2HeaderHelp(Terrain)]
		[HideInInspector] TerrainMeta_maskMapTexture ("Mask Map", 2D) = "white" {}
		[HideInInspector] TerrainMeta_normalMapTexture ("Normal Map", 2D) = "bump" {}
		[HideInInspector] TerrainMeta_normalScale ("Normal Scale", Float) = 1
		[Toggle(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)] _EnableInstancedPerPixelNormal("Enable Instanced per-pixel normal", Float) = 1.0
		[TCP2Separator]
		[HideInInspector] __BeginGroup_ShadowHSV ("Shadow Line", Float) = 0
		_ShadowLineThreshold ("Threshold", Range(0,1)) = 0.5
		_ShadowLineSmoothing ("Smoothing", Range(0.001,0.1)) = 0.015
		_ShadowLineStrength ("Strength", Float) = 1
		_ShadowLineColor ("Color (RGB) Opacity (A)", Color) = (0,0,0,1)
		[HideInInspector] __EndGroup ("Shadow Line", Float) = 0
		
		_StylizedThreshold ("Stylized Threshold", 2D) = "gray" {}
		[TCP2Separator]
		
		[TCP2ColorNoAlpha] _DiffuseTint ("Diffuse Tint", Color) = (1,0.5,0,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(Sketch)]
		_SketchTexture ("Sketch Texture", 2D) = "black" {}
		_SketchTexture_OffsetSpeed ("Sketch Texture UV Offset Speed", Float) = 120
		[TCP2Separator]
		
		[TCP2HeaderHelp(Outline)]
		_OutlineWidth ("Width", Range(0.1,4)) = 1
		_OutlineColorVertex ("Color", Color) = (0,0,0,1)
		
		[HideInInspector] [NoScaleOffset] _Normal0 ("Layer 0 Normal Map", 2D) = "bump" {}
		[HideInInspector] [NoScaleOffset] _Normal1 ("Layer 1 Normal Map", 2D) = "bump" {}
		[HideInInspector] [NoScaleOffset] _Normal2 ("Layer 2 Normal Map", 2D) = "bump" {}
		[HideInInspector] [NoScaleOffset] _Normal3 ("Layer 3 Normal Map", 2D) = "bump" {}
		[HideInInspector] _Splat0 ("Layer 0 Albedo", 2D) = "gray" {}
		[HideInInspector] _Splat1 ("Layer 1 Albedo", 2D) = "gray" {}
		[HideInInspector] _Splat2 ("Layer 2 Albedo", 2D) = "gray" {}
		[HideInInspector] _Splat3 ("Layer 3 Albedo", 2D) = "gray" {}

		// Avoid compile error if the properties are ending with a drawer
		[HideInInspector] __dummy__ ("unused", Float) = 0
	}

	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
			"Queue"="Geometry-100"
			"TerrainCompatible"="True"
		}

		CGINCLUDE

		#include "UnityCG.cginc"
		#include "UnityLightingCommon.cginc"	// needed for LightColor

		// Texture/Sampler abstraction
		#define TCP2_TEX2D_WITH_SAMPLER(tex)						UNITY_DECLARE_TEX2D(tex)
		#define TCP2_TEX2D_NO_SAMPLER(tex)							UNITY_DECLARE_TEX2D_NOSAMPLER(tex)
		#define TCP2_TEX2D_SAMPLE(tex, samplertex, coord)			UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, coord)
		#define TCP2_TEX2D_SAMPLE_LOD(tex, samplertex, coord, lod)	UNITY_SAMPLE_TEX2D_SAMPLER_LOD(tex, samplertex, coord, lod)

		// Terrain
		#define TERRAIN_INSTANCED_PERPIXEL_NORMAL
		#define TERRAIN_BASE_PASS

		//================================================================
		// Terrain Shader specific
		
		//----------------------------------------------------------------
		// Per-layer variables
		
		CBUFFER_START(_Terrain)
			float4 _Control_ST;
			float4 _Control_TexelSize;
			half _DiffuseHasAlpha0, _DiffuseHasAlpha1, _DiffuseHasAlpha2, _DiffuseHasAlpha3;
			half _LayerHasMask0, _LayerHasMask1, _LayerHasMask2, _LayerHasMask3;
			// half4 _Splat0_ST, _Splat1_ST, _Splat2_ST, _Splat3_ST;
			half _NormalScale0, _NormalScale1, _NormalScale2, _NormalScale3;
		
			#ifdef UNITY_INSTANCING_ENABLED
				float4 _TerrainHeightmapRecipSize;   // float4(1.0f/width, 1.0f/height, 1.0f/(width-1), 1.0f/(height-1))
				float4 _TerrainHeightmapScale;       // float4(hmScale.x, hmScale.y / (float)(kMaxHeight), hmScale.z, 0.0f)
			#endif
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif
		CBUFFER_END
		
		//----------------------------------------------------------------
		// Terrain textures
		
		TCP2_TEX2D_WITH_SAMPLER(_Control);
		
		#if defined(TERRAIN_BASE_PASS)
			TCP2_TEX2D_WITH_SAMPLER(_MainTex);
			TCP2_TEX2D_WITH_SAMPLER(_NormalMap);
		#endif
		
		//----------------------------------------------------------------
		// Terrain Instancing
		
		#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
			#define ENABLE_TERRAIN_PERPIXEL_NORMAL
		#endif
		
		#ifdef UNITY_INSTANCING_ENABLED
			TCP2_TEX2D_NO_SAMPLER(_TerrainHeightmapTexture);
			TCP2_TEX2D_WITH_SAMPLER(_TerrainNormalmapTexture);
		#endif
		
		UNITY_INSTANCING_BUFFER_START(Terrain)
			UNITY_DEFINE_INSTANCED_PROP(float4, _TerrainPatchInstanceData)  // float4(xBase, yBase, skipScale, ~)
		UNITY_INSTANCING_BUFFER_END(Terrain)
		
		void TerrainInstancing(inout float4 positionOS, inout float3 normal, inout float2 uv)
		{
		#ifdef UNITY_INSTANCING_ENABLED
			float2 patchVertex = positionOS.xy;
			float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);
		
			float2 sampleCoords = (patchVertex.xy + instanceData.xy) * instanceData.z; // (xy + float2(xBase,yBase)) * skipScale
			float height = UnpackHeightmap(_TerrainHeightmapTexture.Load(int3(sampleCoords, 0)));
		
			positionOS.xz = sampleCoords * _TerrainHeightmapScale.xz;
			positionOS.y = height * _TerrainHeightmapScale.y;
		
			#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
				normal = float3(0, 1, 0);
			#else
				normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb * 2 - 1;
			#endif
			uv = sampleCoords * _TerrainHeightmapRecipSize.zw;
		#endif
		}
		
		void TerrainInstancing(inout float4 positionOS, inout float3 normal)
		{
			float2 uv = { 0, 0 };
			TerrainInstancing(positionOS, normal, uv);
		}
		
		//----------------------------------------------------------------
		// Terrain Holes
		
		#if defined(_ALPHATEST_ON)
			TCP2_TEX2D_WITH_SAMPLER(_TerrainHolesTexture);
		
			void ClipHoles(float2 uv)
			{
				float hole = TCP2_TEX2D_SAMPLE(_TerrainHolesTexture, _TerrainHolesTexture, uv).r;
				clip(hole == 0.0f ? -1 : 1);
			}
		#endif
		
		// Shader Properties
		TCP2_TEX2D_WITH_SAMPLER(_Normal0);
		TCP2_TEX2D_NO_SAMPLER(_Normal1);
		TCP2_TEX2D_NO_SAMPLER(_Normal2);
		TCP2_TEX2D_NO_SAMPLER(_Normal3);
		TCP2_TEX2D_WITH_SAMPLER(_Splat0);
		TCP2_TEX2D_NO_SAMPLER(_Splat1);
		TCP2_TEX2D_NO_SAMPLER(_Splat2);
		TCP2_TEX2D_NO_SAMPLER(_Splat3);
		TCP2_TEX2D_WITH_SAMPLER(_StylizedThreshold);
		TCP2_TEX2D_WITH_SAMPLER(_SketchTexture);
		sampler2D _Ramp;
		
		// Shader Properties
		float _OutlineWidth;
		fixed4 _OutlineColorVertex;
		float4 _Splat0_ST;
		float4 _Splat1_ST;
		float4 _Splat2_ST;
		float4 _Splat3_ST;
		fixed4 _Color;
		float4 _StylizedThreshold_ST;
		float4 _SketchTexture_ST;
		half _SketchTexture_OffsetSpeed;
		fixed4 _HColor;
		fixed4 _SColor;
		fixed4 _DiffuseTint;
		float _ShadowLineThreshold;
		float _ShadowLineStrength;
		float _ShadowLineSmoothing;
		fixed4 _ShadowLineColor;

		// Hash without sin and uniform across platforms
		// Adapted from: https://www.shadertoy.com/view/4djSRW (c) 2014 - Dave Hoskins - CC BY-SA 4.0 License
		float2 hash22(float2 p)
		{
			float3 p3 = frac(p.xyx * float3(443.897, 441.423, 437.195));
			p3 += dot(p3, p3.yzx + 19.19);
			return frac((p3.xx+p3.yz)*p3.zy);
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
			float4 tangent : TANGENT;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		struct v2f_outline
		{
			float4 vertex : SV_POSITION;
			float4 vcolor : TEXCOORD0;
			float pack1 : TEXCOORD1; /* pack1.x = ndl */
			UNITY_VERTEX_OUTPUT_STEREO
		};

		v2f_outline vertex_outline (appdata_outline v)
		{
			v2f_outline output;
			UNITY_INITIALIZE_OUTPUT(v2f_outline, output);
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

			TerrainInstancing(v.vertex, v.normal, v.texcoord0.xy);
				v.tangent.xyz = cross(v.normal, float3(0,0,1));
				v.tangent.w = -1;

			// Shader Properties Sampling
			float __outlineLightingWrapFactorVertex = ( 1.0 );
			float __outlineWidth = ( _OutlineWidth );
			float4 __outlineColorVertex = ( _OutlineColorVertex.rgba );

			float3 objSpaceLight = normalize(mul(unity_WorldToObject, _WorldSpaceLightPos0).xyz);
			float3 normal = objSpaceLight.xyz;
			half lightWrap = __outlineLightingWrapFactorVertex;
			half ndl = max(0, (dot(v.normal.xyz, objSpaceLight.xyz) + lightWrap) / (1 + lightWrap));
			output.pack1.x = ndl;
		
			float size = 1;
		
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
			outlineColor *= input.pack1.x;

			return outlineColor;
		}

		ENDCG
		// Outline Include End
		// Main Surface Shader

		CGPROGRAM

		#pragma surface surf ToonyColorsCustom vertex:vertex_surface exclude_path:deferred exclude_path:prepass keepalpha nolightmap nofog nolppv addshadow
		#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
		#pragma target 3.0

		//================================================================
		// SHADER KEYWORDS

		#pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL
		#pragma multi_compile_local_fragment __ _ALPHATEST_ON

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
			half4 tangent : TANGENT;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		struct Input
		{
			half3 tangent;
			float4 screenPosition;
			float2 texcoord0;
		};

		//================================================================

		// Custom SurfaceOutput
		struct SurfaceOutputCustom
		{
			half atten;
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Specular;
			half Gloss;
			half Alpha;

			Input input;

			half terrainWeight;

			// Shader Properties
			float __stylizedThreshold;
			float __stylizedThresholdScale;
			float3 __sketchColor;
			float3 __sketchTexture;
			float __sketchThresholdScale;
			float3 __highlightColor;
			float3 __shadowColor;
			float3 __diffuseTint;
			float __shadowLineThreshold;
			float __shadowLineStrength;
			float __shadowLineSmoothing;
			float4 __shadowLineColor;
			float __ambientIntensity;
		};

		//================================================================
		// VERTEX FUNCTION

		void vertex_surface(inout appdata_tcp2 v, out Input output)
		{
			UNITY_INITIALIZE_OUTPUT(Input, output);

			TerrainInstancing(v.vertex, v.normal, v.texcoord0.xy);
				v.tangent.xyz = cross(v.normal, float3(0,0,1));
				v.tangent.w = -1;

			// Texture Coordinates
			output.texcoord0 = v.texcoord0.xy;

			float4 clipPos = UnityObjectToClipPos(v.vertex);

			// Screen Position
			float4 screenPos = ComputeScreenPos(clipPos);
			output.screenPosition = screenPos;

			output.tangent = mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0)).xyz;

		}

		//================================================================
		// SURFACE FUNCTION

		void surf(Input input, inout SurfaceOutputCustom output)
		{
			//Screen Space UV
			float2 screenUV = input.screenPosition.xy / input.screenPosition.w;
			
			// Shader Properties Sampling
			float4 __layer0NormalMap = ( TCP2_TEX2D_SAMPLE(_Normal0, _Normal0, input.texcoord0.xy * _Splat0_ST.xy + _Splat0_ST.zw).rgba );
			float4 __layer1NormalMap = ( TCP2_TEX2D_SAMPLE(_Normal1, _Normal0, input.texcoord0.xy * _Splat1_ST.xy + _Splat1_ST.zw).rgba );
			float4 __layer2NormalMap = ( TCP2_TEX2D_SAMPLE(_Normal2, _Normal0, input.texcoord0.xy * _Splat2_ST.xy + _Splat2_ST.zw).rgba );
			float4 __layer3NormalMap = ( TCP2_TEX2D_SAMPLE(_Normal3, _Normal0, input.texcoord0.xy * _Splat3_ST.xy + _Splat3_ST.zw).rgba );
			float4 __layer0Albedo = ( TCP2_TEX2D_SAMPLE(_Splat0, _Splat0, input.texcoord0.xy * _Splat0_ST.xy + _Splat0_ST.zw).rgba );
			float4 __layer1Albedo = ( TCP2_TEX2D_SAMPLE(_Splat1, _Splat0, input.texcoord0.xy * _Splat1_ST.xy + _Splat1_ST.zw).rgba );
			float4 __layer2Albedo = ( TCP2_TEX2D_SAMPLE(_Splat2, _Splat0, input.texcoord0.xy * _Splat2_ST.xy + _Splat2_ST.zw).rgba );
			float4 __layer3Albedo = ( TCP2_TEX2D_SAMPLE(_Splat3, _Splat0, input.texcoord0.xy * _Splat3_ST.xy + _Splat3_ST.zw).rgba );
			float4 __mainColor = ( _Color.rgba );
			output.__stylizedThreshold = ( TCP2_TEX2D_SAMPLE(_StylizedThreshold, _StylizedThreshold, input.texcoord0.xy * _StylizedThreshold_ST.xy + _StylizedThreshold_ST.zw).a );
			output.__stylizedThresholdScale = ( 1.0 );
			output.__sketchColor = ( float3(0,0,0) );
			output.__sketchTexture = ( TCP2_TEX2D_SAMPLE(_SketchTexture, _SketchTexture, screenUV * _ScreenParams.zw * _SketchTexture_ST.xy + _SketchTexture_ST.zw + hash22(floor(_Time.xx * _SketchTexture_OffsetSpeed.xx) / _SketchTexture_OffsetSpeed.xx)).aaa );
			output.__sketchThresholdScale = ( 1.0 );
			output.__highlightColor = ( _HColor.rgb );
			output.__shadowColor = ( _SColor.rgb );
			output.__diffuseTint = ( _DiffuseTint.rgb );
			output.__shadowLineThreshold = ( _ShadowLineThreshold );
			output.__shadowLineStrength = ( _ShadowLineStrength );
			output.__shadowLineSmoothing = ( _ShadowLineSmoothing );
			output.__shadowLineColor = ( _ShadowLineColor.rgba );
			output.__ambientIntensity = ( 1.0 );

			output.input = input;

			// Terrain
			
			float2 terrainTexcoord0 = input.texcoord0.xy;
			
			#if defined(_ALPHATEST_ON)
				ClipHoles(terrainTexcoord0.xy);
			#endif
			
			#if defined(TERRAIN_BASE_PASS)
			
				half4 terrain_mixedDiffuse = TCP2_TEX2D_SAMPLE(_MainTex, _MainTex, terrainTexcoord0.xy).rgba;
				half3 normalTS = half3(0.0h, 0.0h, 1.0h);
			
			#else
			
				// Sample the splat control texture generated by the terrain
				// adjust splat UVs so the edges of the terrain tile lie on pixel centers
				float2 terrainSplatUV = (terrainTexcoord0.xy * (_Control_TexelSize.zw - 1.0f) + 0.5f) * _Control_TexelSize.xy;
				half4 terrain_splat_control_0 = TCP2_TEX2D_SAMPLE(_Control, _Control, terrainSplatUV);
			
				// Calculate weights and perform the texture blending
				half terrain_weight = dot(terrain_splat_control_0, half4(1,1,1,1));
			
				#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
					clip(terrain_weight == 0.0f ? -1 : 1);
				#endif
			
				// Normalize weights before lighting and restore afterwards so that the overall lighting result can be correctly weighted
				terrain_splat_control_0 /= (terrain_weight + 1e-3f);
			
				// Sample terrain normal maps
				half4 normal0 = __layer0NormalMap;
				half4 normal1 = __layer1NormalMap;
				half4 normal2 = __layer2NormalMap;
				half4 normal3 = __layer3NormalMap;
				#define UnpackFunction UnpackNormalWithScale
				half3 normalTS = UnpackFunction(normal0, _NormalScale0) * terrain_splat_control_0.r;
				normalTS += UnpackFunction(normal1, _NormalScale1) * terrain_splat_control_0.g;
				normalTS += UnpackFunction(normal2, _NormalScale2) * terrain_splat_control_0.b;
				normalTS += UnpackFunction(normal3, _NormalScale3) * terrain_splat_control_0.a;
				normalTS.z += 1e-3f; // to avoid nan after normalizing
			
				output.Normal = normalTS;
			
			#endif // TERRAIN_BASE_PASS
			
			#if defined(INSTANCING_ON) && defined(SHADER_TARGET_SURFACE_ANALYSIS) && defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
				output.Normal = float3(0, 0, 1); // make sure that surface shader compiler realizes we write to normal, as UNITY_INSTANCING_ENABLED is not defined for SHADER_TARGET_SURFACE_ANALYSIS.
			#endif
				
			// Terrain normal, if using instancing and per-pixel normal map
			#if defined(UNITY_INSTANCING_ENABLED) && !defined(SHADER_API_D3D11_9X) && defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
				float2 terrainNormalCoords = (terrainTexcoord0.xy / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
				float3 geomNormal = normalize(TCP2_TEX2D_SAMPLE(_TerrainNormalmapTexture, _TerrainNormalmapTexture, terrainNormalCoords.xy).xyz * 2 - 1);
			
				float3 geomTangent = normalize(cross(geomNormal, float3(0, 0, 1)));
				float3 geomBitangent = normalize(cross(geomTangent, geomNormal));
				output.Normal = output.Normal.x * geomTangent
							  + output.Normal.y * geomBitangent
							  + output.Normal.z * geomNormal;
				output.Normal = output.Normal.xzy;
			#endif
			
			output.Albedo = half3(1,1,1);
			output.Alpha = 1;

			#if !defined(TERRAIN_BASE_PASS)
				// Sample textures that will be blended based on the terrain splat map
				half4 splat0 = __layer0Albedo;
				half4 splat1 = __layer1Albedo;
				half4 splat2 = __layer2Albedo;
				half4 splat3 = __layer3Albedo;
			
				#define BLEND_TERRAIN_HALF4(outVariable, sourceVariable) \
					half4 outVariable = terrain_splat_control_0.r * sourceVariable##0; \
					outVariable += terrain_splat_control_0.g * sourceVariable##1; \
					outVariable += terrain_splat_control_0.b * sourceVariable##2; \
					outVariable += terrain_splat_control_0.a * sourceVariable##3;
				#define BLEND_TERRAIN_HALF(outVariable, sourceVariable) \
					half4 outVariable = dot(terrain_splat_control_0, half4(sourceVariable##0, sourceVariable##1, sourceVariable##2, sourceVariable##3));
			
				BLEND_TERRAIN_HALF4(terrain_mixedDiffuse, splat)
			
			#endif // !TERRAIN_BASE_PASS
			
			#if !defined(TERRAIN_BASE_PASS)
				output.terrainWeight = terrain_weight;
			#endif
			
			output.Albedo = terrain_mixedDiffuse.rgb;
			output.Alpha = terrain_mixedDiffuse.a;
			
			output.Albedo *= __mainColor.rgb;

		}

		//================================================================
		// LIGHTING FUNCTION

		inline half4 LightingToonyColorsCustom(inout SurfaceOutputCustom surface, UnityGI gi)
		{

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
			float stylizedThreshold = surface.__stylizedThreshold;
			stylizedThreshold -= 0.5;
			stylizedThreshold *= surface.__stylizedThresholdScale;
			ndl += stylizedThreshold;
			half3 ramp;
			
			//Define ramp threshold and smoothstep depending on context
			#define		RAMP_TEXTURE	_Ramp
			half2 rampUv = ndl.xx * 0.5 + 0.5;
			ramp = tex2D(RAMP_TEXTURE, rampUv).rgb;

			// Apply attenuation (shadowmaps & point/spot lights attenuation)
			ramp *= atten;
			half3 sketchColor = lerp(surface.__sketchColor, half3(1,1,1), surface.__sketchTexture);
			half3 sketch = lerp(sketchColor, half3(1,1,1), saturate(ramp * surface.__sketchThresholdScale));

			// Highlight/Shadow Colors
			#if !defined(UNITY_PASS_FORWARDBASE)
				ramp = lerp(half3(0,0,0), surface.__highlightColor, ramp);
			#else
				ramp = lerp(surface.__shadowColor, surface.__highlightColor, ramp);
			#endif

			// Diffuse Tint
			half3 diffuseTint = saturate(surface.__diffuseTint + ndl);
			ramp *= diffuseTint;
			
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
			color.rgb *= sketch.rgb;

			// Apply indirect lighting (ambient)
			half occlusion = 1;
			#ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
				half3 ambient = gi.indirect.diffuse;
				ambient *= surface.Albedo * occlusion * surface.__ambientIntensity;

				color.rgb += ambient;
			#endif

			#if !defined(TERRAIN_BASE_PASS)
				color.rgb *= surface.terrainWeight;
			#endif

			return color;
		}

		void LightingToonyColorsCustom_GI(inout SurfaceOutputCustom surface, UnityGIInput data, inout UnityGI gi)
		{
			half3 normal = surface.Normal;

			// GI without reflection probes
			gi = UnityGlobalIllumination(data, 1.0, normal); // occlusion is applied in the lighting function, if necessary

			surface.atten = data.atten; // transfer attenuation to lighting function
			gi.light.color = _LightColor0.rgb; // remove attenuation

		}

		ENDCG

		// Outline
		Pass
		{
			Name "Outline"
			Tags
			{
				"LightMode"="ForwardBase"
			}
			Cull Front
			Blend Off

			CGPROGRAM
			#pragma vertex vertex_outline
			#pragma fragment fragment_outline
			#pragma target 3.0
			#pragma multi_compile _ TCP2_COLORS_AS_NORMALS TCP2_TANGENT_AS_NORMALS TCP2_UV1_AS_NORMALS TCP2_UV2_AS_NORMALS TCP2_UV3_AS_NORMALS TCP2_UV4_AS_NORMALS
			#pragma multi_compile _ TCP2_UV_NORMALS_FULL TCP2_UV_NORMALS_ZW
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
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
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd

			#pragma multi_compile TCP2_NONE TCP2_ZSMOOTH_ON
			#pragma multi_compile TCP2_NONE TCP2_OUTLINE_CONST_SIZE
			#pragma multi_compile _ TCP2_COLORS_AS_NORMALS TCP2_TANGENT_AS_NORMALS TCP2_UV1_AS_NORMALS TCP2_UV2_AS_NORMALS TCP2_UV3_AS_NORMALS TCP2_UV4_AS_NORMALS
			#pragma multi_compile _ TCP2_UV_NORMALS_FULL TCP2_UV_NORMALS_ZW

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
				float4 tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f_shadowcaster
			{
				V2F_SHADOW_CASTER_NOPOS
				float4 vcolor : TEXCOORD1;
				float pack1 : TEXCOORD2; /* pack1.x = ndl */
				UNITY_VERTEX_OUTPUT_STEREO
			};

			void vertex_shadowcaster (appdata_shadowcaster v, out v2f_shadowcaster output, out float4 opos : SV_POSITION)
			{
				UNITY_INITIALIZE_OUTPUT(v2f_shadowcaster, output);
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				// Shader Properties Sampling
				float __outlineLightingWrapFactorVertex = ( 1.0 );
				float __outlineWidth = ( _OutlineWidth );
				float4 __outlineColorVertex = ( _OutlineColorVertex.rgba );

				float3 objSpaceLight = normalize(mul(unity_WorldToObject, _WorldSpaceLightPos0).xyz);
				float3 normal = objSpaceLight.xyz;
				half lightWrap = __outlineLightingWrapFactorVertex;
				half ndl = max(0, (dot(v.normal.xyz, objSpaceLight.xyz) + lightWrap) / (1 + lightWrap));
				output.pack1.x = ndl;
			
				float size = 1;
			
			#if !defined(SHADOWCASTER_PASS)
				output.vertex = UnityObjectToClipPos(v.vertex.xyz + normal * __outlineWidth * size * 0.01);
			#else
				v.vertex = v.vertex + float4(normal,0) * __outlineWidth * size * 0.01;
			#endif
			
				output.vcolor.xyzw = __outlineColorVertex;

				TRANSFER_SHADOW_CASTER_NOPOS(output,opos)
			}

			half4 fragment_shadowcaster(v2f_shadowcaster input, UNITY_VPOS_TYPE vpos : VPOS) : SV_Target
			{

				SHADOW_CASTER_FRAGMENT(input)
			}

			ENDCG
		}
		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
		UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"
	}

	Fallback "Diffuse"
	CustomEditor "ToonyColorsPro.ShaderGenerator.MaterialInspector_SG2"
}

