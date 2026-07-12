shader_type canvas_item;

uniform float threshold = 0.3;

const vec3 orig_1 = vec3(0.533, 0.078, 0.000); // #881400
const vec3 orig_2 = vec3(0.988, 0.847, 0.659); // #fcd8a8
const vec3 orig_3 = vec3(0.988, 0.596, 0.220); // #fc9838

const vec3 nova_1 = vec3(0.659, 0.894, 0.988); // #a8e4fc
const vec3 nova_2 = vec3(0.988, 0.596, 0.220); // #fc9838
const vec3 nova_3 = vec3(0.988, 0.847, 0.659); // #fcd8a8

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec3 final_rgb = tex_color.rgb;

    if (distance(tex_color.rgb, orig_1) <= threshold) {
        final_rgb = nova_1;
    }
	
    else if (distance(tex_color.rgb, orig_2) <= threshold) {
        final_rgb = nova_2;
    }

    else if (distance(tex_color.rgb, orig_3) <= threshold) {
        final_rgb = nova_3;
    }

    // Mantém o canal alfa (transparência) original do sprite
    COLOR = vec4(final_rgb, tex_color.a);
}
