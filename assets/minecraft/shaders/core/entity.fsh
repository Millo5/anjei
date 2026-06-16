#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:skybox.glsl>
#moj_import <minecraft:dither.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
#ifdef PER_FACE_LIGHTING
in vec4 vertexPerFaceColorBack;
in vec4 vertexPerFaceColorFront;
#else
in vec4 vertexColor;
#endif
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;

in vec4 baseColor;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);

#ifdef PER_FACE_LIGHTING
    vec4 vcf = vertexPerFaceColorFront;
    vec4 vcb = vertexPerFaceColorBack;
#else
    vec4 vc = vertexColor;
#endif

    if (floor(color * 255) == ivec4(255, 0, 255, 1)) {
        fragColor = skybox();
        return;
    }

    if (ivec4(baseColor * 255.5) == ivec4(255, 0, 0, 255)) {
        if (dither(0.7)) discard;
#ifdef PER_FACE_LIGHTING
        vcf = vec4(1,0,0,1);
        vcb = vec4(1,0,0,1);
#else
        vc = vec4(1,0,0,1);
#endif
    }

    if (ivec4(baseColor * 255.5) == ivec4(0, 255, 0, 255)) {
        if (dither(0.7)) discard;
#ifdef PER_FACE_LIGHTING
        vcf = vec4(1);
        vcb = vec4(1);
#else
        vc = vec4(1);
#endif
    }

    if (ivec4(baseColor * 255.5) == ivec4(0, 0, 255, 255)) {
        discard;
    }

#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
#ifdef PER_FACE_LIGHTING
    color *= (gl_FrontFacing ? vcf : vcb) * ColorModulator;

#else
    color *= vc * ColorModulator;
#endif
#ifndef NO_OVERLAY
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
#endif
#ifndef EMISSIVE
    color *= lightMapColor;
#endif
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}