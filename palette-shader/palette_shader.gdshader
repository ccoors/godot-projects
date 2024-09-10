// Shader code adapted from blog article
// https://nas.sr/text/yesterdays-pixels-today/

shader_type canvas_item;

// Input image
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Palette
uniform sampler2D palette_image : source_color;

// Dithering threshold
uniform float threshold : hint_range(0, 1) = 0.03;

void fragment() {
	vec3 src_color = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

	float dist[] = { 10.0, 10.0 };
	vec3 col[] = { vec3(0.0), vec3(0.0) };
	int index[] = { 0, 0 };

	ivec2 palette_size = textureSize(palette_image, 0);
	for (int y = 0; y < palette_size.y; y++) {
		for (int x = 0; x < palette_size.x; x++) {
			vec3 palette_color = texelFetch(palette_image, ivec2(x, y), 0).rgb;
			float d = distance(src_color, palette_color);
			int i = x + y * palette_size.x;
			if (d <= dist[0]) {
				index[1] = index[0];
				dist[1] = dist[0];
				col[1] = col[0];
				index[0] = i;
				dist[0] = d;
				col[0] = palette_color;
			} else if (d <= dist[1]) {
				index[1] = i;
				dist[1] = d;
				col[1] = palette_color;
			}
		}
	}

	if (distance(dist[0], dist[1]) < threshold) {
		// Apply dithering
		float total = FRAGCOORD.x + FRAGCOORD.y;
		bool even_pixel = abs(mod(total, 2.0)) < 0.5;
		vec3 color_a = index[0] < index[1] ? col[0] : col[1];
		vec3 color_b = index[0] < index[1] ? col[1] : col[0];
		COLOR.rgb = even_pixel ? color_a : color_b;
	} else {
		COLOR.rgb = col[0];
	}
}
