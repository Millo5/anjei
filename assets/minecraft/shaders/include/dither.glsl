#moj_import <minecraft:globals.glsl>

const mat4 ditherMat = mat4(
    0.0, 8.0, 2.0, 10.0,
    12.0, 4.0, 14.0, 6.0,
    3.0, 11.0, 1.0, 9.0,
    15.0, 7.0, 13.0, 5.0
) / 16.0;

bool dither(float value) {

    vec2 loc = gl_FragCoord.xy;

    int x = int(mod(loc.x, 4.0));
    int y = int(mod(loc.y, 4.0));
    return value < ditherMat[y][x];
}