#version 330

uniform sampler2D InSampler;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

in vec2 texCoord;

out vec4 fragColor;

void main(){
    vec4 color = texture(InSampler, texCoord);

    if(color.a == 0) {
        vec4 accum = vec4(0.0);
        int accumCount = 0;

        vec2 oneTexel = 1.0 / InSize;

        for(int x = -4; x < 5; x++) {
            for(int y = -4; y < 5; y++) {
                color = texture(InSampler, texCoord + vec2(x, y) * oneTexel);
                if(color.a != 0) {
                    accum += color;
                    accumCount++;
                }
            }
        }
        fragColor = accumCount == 0 ? vec4(0.0) : accum / accumCount;
        return;
    }

    fragColor = vec4(color.rgb, color.a * 0.1);
}