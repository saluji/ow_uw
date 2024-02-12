// Toony Colors Pro+Mobile 2
// (c) 2014-2023 Jean Moreno

Shader "Toony Colors Pro 2/User/My TCP2 Shader Cope"
{
	Properties
	{
		[TCP2HeaderHelp(Base)]
		_Color ("Color", Color) = (1,1,1,1)
		[TCP2ColorNoAlpha] _HColor ("Highlight Color", Color) = (0.735849,0.735849,0.735849,1)
		[TCP2ColorNoAlpha] _SColor ("Shadow Color", Color) = (0.3584906,0.3584906,0.3584906,1)
		[MainTexture] _MainTex ("Albedo", 2D) = "white" {}
		[TCP2Separator]

		[TCP2Header(Ramp Shading)]
		_RampThreshold ("Threshold", Range(0.01,1)) = 0.5
		_RampSmoothing ("Smoothing", Range(0.001,1)) = 0.5
		[IntRange] _BandsCount ("Bands Count", Range(1,20)) = 4
		[TCP2Separator]
		[HideInInspector] __BeginGroup_ShadowHSV ("Shadow Line", Float) = 0
		_ShadowLineThreshold ("Threshold", Range(0,1)) = 0.5
		_ShadowLineSmoothing ("Smoothing", Range(0.001,0.1)) = 0.015
		_ShadowLineStrength ("Strength", Float) = 1
		_ShadowLineColor ("Color (RGB) Opacity (A)", Color) = (0,0,0,1)
		[HideInInspector] __EndGroup ("Shadow Line", Float) = 0
		
		_StylizedThreshold ("Stylized Threshold", 2D) = "gray" {}
		[TCP2Separator]
		
		[TCP2HeaderHelp(Sketch)]
		_ProgressiveSketchTexture ("Progressive Texture", 2D) = "black" {}
		_ProgressiveSketchSmoothness ("Progressive Smoothness", Range(0.005,0.5)) = 0.1
		[TCP2Separator]
		
		[TCP2HeaderHelp(Outline)]
		_OutlineWidth ("Width", Range(0.1,4)) = 1
		_OutlineColorVertex ("Color", Color) = (0,0,0,1)
		// Outline Normals
		[TCP2MaterialKeywordEnumNoPrefix(Regular, _, Vertex Colors, TCP2_COLORS_AS_NORMALS, Tangents, TCP2_TANGENT_AS_NORMALS, UV1, TCP2_UV1_AS_NORMALS, UV2, TCP2_UV2_AS_NORMALS, UV3, TCP2_UV3_AS_NORMALS, UV4, TCP2_UV4_AS_NORMALS)]
		_NormalsSource ("Outline Normals Source", Float) = 0
		[TCP2MaterialKeywordEnumNoPrefix(Full XYZ, TCP2_UV_NORMALS_FULL, Compressed XY, _, Compressed ZW, TCP2_UV_NORMALS_ZW)]
		_NormalsUVType ("UV Data Type", Float) = 0
		[TCP2Separator]

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
		TCP2_TEX2D_WITH_SAMPLER(_MainTex);
		TCP2_TEX2D_WITH_SAMPLER(_StylizedThreshold);
		TCP2_TEX2D_WITH_SAMPLER(_ProgressiveSketchTexture);
		
		// Shader Properties
		float _OutlineWidth;
		fixed4 _OutlineColorVertex;
		float4 _MainTex_ST;
		fixed4 _Color;
		float4 _StylizedThreshold_ST;
		float _RampThreshold;
		float _RampSmoothing;
		float _BandsCount;
		float4 _ProgressiveSketchTexture_ST;
		float _ProgressiveSketchSmoothness;
		fixed4 _HColor;
		fixed4 _SColor;
		float _ShadowLineThreshold;
		float _ShadowLineStrength;
		float _ShadowLineSmoothing;
		fixed4 _ShadowLineColor;

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
			#if TCP2_UV1_AS_NORMALS
			float4 texcoord0 : TEXCOORD0;
		#elif TCP2_UV2_AS_NORMALS
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
			float4 vcolor : TEXCOORD0;
			float3 pack1 : TEXCOORD1; /* pack1.xyz = normal */
			UNITY_VERTEX_OUTPUT_STEREO
		};

		v2f_outline vertex_outline (appdata_outline v)
		{
			v2f_outline output;
			UNITY_INITIALIZE_OUTPUT(v2f_outline, output);
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

			// Shader Properties Sampling
			float __outlineWidth = ( _OutlineWidth );
			float4 __outlineColorVertex = ( _OutlineColorVertex.rgba );

			output.pack1.xyz = normalize(mul(unity_ObjectToWorld, v.normal).xyz);
		
		#ifdef TCP2_COLORS_AS_NORMALS
			//Vertex Color for Normals
			float3 normal = (v.vertexColor.xyz*2) - 1;
		#elif TCP2_TANGENT_AS_NORMALS
			//Tangent for Normals
			float3 normal = v.tangent.xyz;
		#elif TCP2_UV1_AS_NORMALS || TCP2_UV2_AS_NORMALS || TCP2_UV3_AS_NORMALS || TCP2_UV4_AS_NORMALS
			#if TCP2_UV1_AS_NORMALS
				#define uvChannel texcoord0
			#elif TCP2_UV2_AS_NORMALS
				#define uvChannel texcoord1
			#elif TCP2_UV3_AS_NORMALS
				#define uvChannel texcoord2
			#elif TCP2_UV4_AS_NORMALS
				#define uvChannel texcoord3
			#endif
		
			#if TCP2_UV_NORMALS_FULL
			//UV for Normals, full
			float3 normal = v.uvChannel.xyz;
			#else
			//UV for Normals, compressed
			#if TCP2_UV_NORMALS_ZW
				#define ch1 z
				#define ch2 w
			#else
				#define ch1 x
				#define ch2 y
			#endif
			float3 n;
			//unpack uvs
			v.uvChannel.ch1 = v.uvChannel.ch1 * 255.0/16.0;
			n.x = floor(v.uvChannel.ch1) / 15.0;
			n.y = frac(v.uvChannel.ch1) * 16.0 / 15.0;
			//- get z
			n.z = v.uvChannel.ch2;
			//- transform
			n = n*2 - 1;
			float3 normal = n;
			#endif
		#else
			float3 normal = v.normal;
		#endif
		
		#if TCP2_ZSMOOTH_ON
			//Correct Z artefacts
			normal = UnityObjectToViewPos(normal);
			normal.z = -_ZSmooth;
		#endif
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
			float __outlineLightingWrapFactorFragment = ( 1.0 );

			half4 outlineColor = __outlineColor * input.vcolor.xyzw;
			half lightWrap = __outlineLightingWrapFactorFragment;
			half ndl = max(0, (dot(input.pack1.xyz, _WorldSpaceLightPos0) + lightWrap) / (1 + lightWrap));
			outlineColor *= ndl;

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

			CGPROGRAM

			#pragma vertex vertex_outline
			#pragma fragment fragment_outline

			#pragma target 3.0

			#pragma multi_compile _ TCP2_COLORS_AS_NORMALS TCP2_TANGENT_AS_NORMALS TCP2_UV1_AS_NORMALS TCP2_UV2_AS_NORMALS TCP2_UV3_AS_NORMALS TCP2_UV4_AS_NORMALS
			#pragma multi_compile _ TCP2_UV_NORMALS_FULL TCP2_UV_NORMALS_ZW
			#pragma multi_compile_instancing
			
			ENDCG
		}
		// Main Surface Shader

		CGPROGRAM

		#pragma surface surf ToonyColorsCustom vertex:vertex_surface exclude_path:deferred exclude_path:prepass keepalpha nolightmap nofog nolppv
		#pragma target 3.0

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

			// Shader Properties
			float __stylizedThreshold;
			float __stylizedThresholdScale;
			float __rampThreshold;
			float __rampSmoothing;
			float __bandsCount;
			float4 __progressiveSketchTexture;
			float __progressiveSketchSmoothness;
			float3 __highlightColor;
			float3 __shadowColor;
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

			// Texture Coordinates
			output.texcoord0.xy = v.texcoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;

			float4 clipPos = UnityObjectToClipPos(v.vertex);

			// Screen Position
			float4 screenPos = ComputeScreenPos(clipPos);
			output.screenPosition = screenPos;

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
			output.__stylizedThreshold = ( TCP2_TEX2D_SAMPLE(_StylizedThreshold, _StylizedThreshold, input.texcoord0.xy * _StylizedThreshold_ST.xy + _StylizedThreshold_ST.zw).a );
			output.__stylizedThresholdScale = ( 1.0 );
			output.__rampThreshold = ( _RampThreshold );
			output.__rampSmoothing = ( _RampSmoothing );
			output.__bandsCount = ( _BandsCount );
			output.__progressiveSketchTexture = ( TCP2_TEX2D_SAMPLE(_ProgressiveSketchTexture, _ProgressiveSketchTexture, screenUV * _ScreenParams.zw * _ProgressiveSketchTexture_ST.xy + _ProgressiveSketchTexture_ST.zw).rgba );
			output.__progressiveSketchSmoothness = ( _ProgressiveSketchSmoothness );
			output.__highlightColor = ( _HColor.rgb );
			output.__shadowColor = ( _SColor.rgb );
			output.__shadowLineThreshold = ( _ShadowLineThreshold );
			output.__shadowLineStrength = ( _ShadowLineStrength );
			output.__shadowLineSmoothing = ( _ShadowLineSmoothing );
			output.__shadowLineColor = ( _ShadowLineColor.rgba );
			output.__ambientIntensity = ( 1.0 );

			output.input = input;

			output.Albedo = __albedo.rgb;
			output.Alpha = __alpha;

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
			
			#define		RAMP_THRESHOLD		surface.__rampThreshold
			#define		RAMP_SMOOTH			surface.__rampSmoothing
			#define		RAMP_BANDS			surface.__bandsCount
			ndl = saturate(ndl);
			ramp = smoothstep(RAMP_THRESHOLD - RAMP_SMOOTH*0.5, RAMP_THRESHOLD + RAMP_SMOOTH*0.5, ndl);
			ramp = (round(ramp * RAMP_BANDS) / RAMP_BANDS) * step(ndl, 1);

			// Apply attenuation (shadowmaps & point/spot lights attenuation)
			ramp *= atten;
			half4 sketch = surface.__progressiveSketchTexture;
			half4 sketchWeights = half4(0,0,0,0);
			half sketchStep = 1.0 / 5.0;
			half sketchSmooth = surface.__progressiveSketchSmoothness;
			sketchWeights.a = smoothstep(sketchStep + sketchSmooth, sketchStep - sketchSmooth, ramp);
			sketchWeights.b = smoothstep(sketchStep*2 + sketchSmooth, sketchStep*2 - sketchSmooth, ramp) - sketchWeights.a;
			sketchWeights.g = smoothstep(sketchStep*3 + sketchSmooth, sketchStep*3 - sketchSmooth, ramp) - sketchWeights.a - sketchWeights.b;
			sketchWeights.r = smoothstep(sketchStep*4 + sketchSmooth, sketchStep*4 - sketchSmooth, ramp) - sketchWeights.a - sketchWeights.b - sketchWeights.g;
			half combinedSketch = 1.0 - dot(sketch, sketchWeights);
			
			// Highlight/Shadow Colors
			#if !defined(UNITY_PASS_FORWARDBASE)
				ramp = lerp(half3(0,0,0), surface.__highlightColor, ramp);
			#else
				ramp = lerp(surface.__shadowColor, surface.__highlightColor, ramp);
			#endif

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
			color.rgb *= combinedSketch;

			// Apply indirect lighting (ambient)
			half occlusion = 1;
			#ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
				half3 ambient = gi.indirect.diffuse;
				ambient *= surface.Albedo * occlusion * surface.__ambientIntensity;

				ambient.rgb *= combinedSketch;
				color.rgb += ambient;
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

		// Outline - Depth Pass Only
		Pass
		{
			Name "Outline Depth"
			Tags
			{
				"LightMode"="ForwardBase"
			}
			Cull Off

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
	}

	Fallback "Diffuse"
	CustomEditor "ToonyColorsPro.ShaderGenerator.MaterialInspector_SG2"
}

/* TCP_DATA u config(ver:"2.9.9";unity:"2022.3.7f1";tmplt:"SG2_Template_Default";features:list["UNITY_5_4","UNITY_5_5","UNITY_5_6","UNITY_2017_1","UNITY_2018_1","UNITY_2018_2","UNITY_2018_3","UNITY_2019_1","UNITY_2019_2","UNITY_2019_3","UNITY_2019_4","UNITY_2020_1","UNITY_2021_1","UNITY_2021_2","UNITY_2022_2","OUTLINE","OUTLINE_DEPTH","OUTLINE_BEHIND_DEPTH","RIM_DIR_PERSP_CORRECTION","REFL_ROUGH","REFLECTION_FRESNEL","PARALLAX","OUTLINE_LIGHTING","OUTLINE_LIGHTING_FRAG","OUTLINE_LIGHTING_WRAP","RAMP_BANDS_CRISP_NO_AA","SHADOW_HSV_MASK","SHADOW_LINE","SHADOW_LINE_CRISP_AA","TEXTURED_THRESHOLD","SKETCH_PROGRESSIVE","SKETCH_AMBIENT","SKETCH_PROGRESSIVE_SMOOTH"];flags:list[];flags_extra:dict[pragma_gpu_instancing=list[]];keywords:dict[RENDER_TYPE="Opaque",RampTextureDrawer="[TCP2Gradient]",RampTextureLabel="Ramp Texture",SHADER_TARGET="3.0",BASEGEN_ALBEDO_DOWNSCALE="1",BASEGEN_MASKTEX_DOWNSCALE="1/2",BASEGEN_METALLIC_DOWNSCALE="1/4",BASEGEN_SPECULAR_DOWNSCALE="1/4",BASEGEN_DIFFUSEREMAPMIN_DOWNSCALE="1/4",BASEGEN_MASKMAPREMAPMIN_DOWNSCALE="1/4",RIM_LABEL="Rim Outline"];shaderProperties:list[,,,,,,,sp(name:"Highlight Color";imps:list[imp_mp_color(def:RGBA(0.735849, 0.735849, 0.735849, 1);hdr:False;cc:3;chan:"RGB";prop:"_HColor";md:"";gbv:False;custom:False;refs:"";pnlock:False;guid:"b49051e0-d77e-4ed6-b4ce-a4055686f475";op:Multiply;lbl:"Highlight Color";gpu_inst:False;dots_inst:False;locked:False;impl_index:0)];layers:list[];unlocked:list[];layer_blend:dict[];custom_blend:dict[];clones:dict[];isClone:False),sp(name:"Shadow Color";imps:list[imp_mp_color(def:RGBA(0.3584906, 0.3584906, 0.3584906, 1);hdr:False;cc:3;chan:"RGB";prop:"_SColor";md:"";gbv:False;custom:False;refs:"";pnlock:False;guid:"234d721b-dee3-44b5-b48a-c3db0438f1cc";op:Multiply;lbl:"Shadow Color";gpu_inst:False;dots_inst:False;locked:False;impl_index:0)];layers:list[];unlocked:list[];layer_blend:dict[];custom_blend:dict[];clones:dict[];isClone:False)];customTextures:list[];codeInjection:codeInjection(injectedFiles:list[];mark:False);matLayers:list[]) */
/* TCP_HASH a0bc3aa5afee19ce0dc1e2638d25099b */
