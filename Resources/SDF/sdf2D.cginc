#if !defined(SDF2D)

#if defined (SHADERLAB_GLSL)
	#define INLINE
	#define INT2 ivec2
	#define INT3 ivec3
	#define INT4 ivec4
	#define HALF float
	#define HALF2 vec2
	#define HALF3 vec3
	#define HALF4 vec4
	#define FLOAT2 vec2
	#define FLOAT3 vec3
	#define FLOAT4 vec4
	#define FIXED2 vec2
	#define FIXED4 vec4
	#define FLOAT2X2 mat2
	#define FLOAT3X3 mat3
	#define FLOAT4X4 mat4
	#define LERP mix
	#define FRACT fract
	#define MOD mod
#else
	#define INLINE inline
	#define INT2 int2
	#define INT3 int3
	#define INT4 int4
	#define HALF half
	#define HALF2 half2
	#define HALF3 half3
	#define HALF4 half4
	#define FLOAT2 float2
	#define FLOAT3 float3
	#define FLOAT4 float4
	#define FIXED2 fixed2
	#define FIXED4 fixed4
	#define FLOAT2X2 float2x2
	#define FLOAT3X3 float3x3
	#define FLOAT4X4 float4x4
	#define LERP lerp
	#define FRACT frac
	#define MOD fmod
#endif


float sdCircle(FLOAT2 uv, float r)
{
    return length(uv) - r;
}

float sdCircle(FLOAT2 uv, FLOAT2 _offset, float r)
{
    return length(uv - _offset) - r;
}

float sdBox(FLOAT2 p, FLOAT2 b)
{
    FLOAT2 d = abs(p)-b;
    return length(max(d,FLOAT2(0.0, 0.0))) + min(max(d.x,d.y),0.0);
}

// Point a to Point b Line
// th is for the thickness
float sdOrientedBox(FLOAT2 p, FLOAT2 a, FLOAT2 b, float th)
{
    float l = length(b-a);
    FLOAT2  d = (b-a)/l;
    FLOAT2  q = (p-(a+b)*0.5);
          q = mul(FLOAT2X2(d.x,-d.y,d.y,d.x), q);
          q = abs(q)-FLOAT2(l,th)*0.5;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0);    
}

#endif