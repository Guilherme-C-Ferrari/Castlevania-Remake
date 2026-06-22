shader_type canvas_item;

uniform sampler2D palette_texture;
uniform int speed = 8;
uniform float threshold = 0.1;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
	int current_palette = 0;
	
	int palette_cycle = int(mod(TIME * float(speed), 4.0));
	current_palette = palette_cycle; 

    // Linha da paleta original
    vec4 original_0 = texelFetch(palette_texture, ivec2(0, 0), 0);
    vec4 original_1 = texelFetch(palette_texture, ivec2(1, 0), 0);
    vec4 original_2 = texelFetch(palette_texture, ivec2(2, 0), 0);

    int color_index = -1;
	
    if (distance(color.rgb, original_0.rgb) <= threshold) {
        color_index = 0;
    }
    else if (distance(color.rgb, original_1.rgb) <= threshold) {
        color_index = 1;
    }
    else if (distance(color.rgb, original_2.rgb) <= threshold) {
        color_index = 2;
    }

    if (color_index >= 0) {
        vec4 new_color = texelFetch(
            palette_texture,
            ivec2(color_index, current_palette),
            0
        );
        COLOR = vec4(new_color.rgb, color.a);
		
    }
    else {
        COLOR = color;
    }

}