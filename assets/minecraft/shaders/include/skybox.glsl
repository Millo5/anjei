#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:projection.glsl>

const float TIMESCALE = 10;

// hash and noise2d from here:
// <https://www.shadertoy.com/view/4dS3Wd>
// By Morgan McGuire @morgan3d, http://graphicscodex.com
float hash(vec2 p) { return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }

float noise(vec2 x) {
	vec2 i = floor(x);
	vec2 f = fract(x);

	// Four corners in 2D of a tile
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));

	// Simple 2D lerp using smoothstep envelope between the values.
	// return vec3(mix(mix(a, b, smoothstep(0.0, 1.0, f.x)),
	//			mix(c, d, smoothstep(0.0, 1.0, f.x)),
	//			smoothstep(0.0, 1.0, f.y)));

	// Same code, with the clamps in smoothstep and common subexpressions
	// optimized away.
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 sunDirection(float time) {
    return vec3(sin(time),cos(time),0);
}

float sunGlobalIllumination(float time) {
    return clamp(sunDirection(time * 0.25).y + 0.4, 0.01, 1.0);
}

vec3 atmosphereColor(vec3 rayOrigin, vec3 rayDirection, float time) {

    vec3 sunDir = sunDirection(time * 0.25);
    float sunDistance = distance(rayDirection, sunDir);
    sunDistance *= 4;

    float scatterMult = clamp(sunDistance, 0.0, 1.0);
    float sun = clamp(1.0 - smoothstep(0.01, 0.02, scatterMult), 0.0, 1.0);

    float dist = rayDirection.y;
    dist = 0.25 * mix(scatterMult, 1.0, dist) / dist;


    vec3 color = mix(vec3(0.7, 0.4, 1.0), vec3(0.6, 0.9, 1.0), min(rayDirection.y + 1.5, 2.0) * 0.5);

    color += sun * vec3(1, 1, 0);
    color += color * pow(1.0 - scatterMult, 10.0) * 2.0;

    return color;
}



float cloudPlane(vec3 ro, vec3 rd, float height, vec2 offset) {
    if (rd.y < 0.05) return 0;

    vec2 plane = rd.xz * ((height - ro.y) / rd.y);
    float value = noise((floor(plane * 0.5 + offset))*0.3);
    value = value*3 - 1. - length(plane) * 0.02;

    return max(min(value, 1), 0);
}

vec4 skybox() {

    vec2 loc = gl_FragCoord.xy;
    float time = GameTime * 60 * TIMESCALE;

    loc = 8 * round(loc / 8);

    // INIT
    vec2 uv = (loc - .5 * ScreenSize.xy) / ScreenSize.y;
    vec3 rayOrigin = vec3(0);
    vec3 rayDirection = normalize(mat3(inverse(ModelViewMat)) * vec3(-uv, ProjMat[1][1] / 2));
    rayDirection.y *= -1;
    vec3 color = atmosphereColor(rayOrigin, rayDirection, 0);

    vec3 cloudColor = vec3(1., 0.97,0.95);
    vec3 cloudColo2 = vec3(0.96, 0.98, 1.);
    color = mix(color, cloudColor, cloudPlane(rayOrigin, rayDirection, 6, vec2(0.5 * time, time)));
    color = mix(color, cloudColo2, cloudPlane(rayOrigin, rayDirection, 6, vec2(0.8 * time, time)));


    return vec4(color, 1);

}