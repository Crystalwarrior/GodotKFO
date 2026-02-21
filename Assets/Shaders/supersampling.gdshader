shader_type canvas_item;

void fragment() {
	// Get the raw texture sample and the modulated color
	vec4 tex = texture(TEXTURE, UV);
	
	// Extract modulate by dividing COLOR (modulated) by raw texture
	vec4 modulate = COLOR / tex;
	
	// Get the texture size
	vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;
	
	// Obtain the UV step
	vec2 uv_step = fwidth(UV) * tex_size;
	
	// Obtain the downscaling at which to begin supersampling
	float max_step = max(uv_step.x, uv_step.y);
	
	// If the image is being downscaled...
	if (max_step > 1.0) {
		// Fixed at 2 samples (2x2 grid = 4 samples total)
		float samples = 2.0;
		
		vec2 uv_offset = fwidth(UV) / samples;
		vec2 start_uv = UV - (samples * 0.5 - 0.5) * uv_offset;
		
		// Supersample the texture
		vec3 result = vec3(0.0);
		for (float i = 0.0; i < samples; i++) {
			for (float j = 0.0; j < samples; j++) {
				vec2 sample_uv = start_uv + vec2(i, j) * uv_offset;
				sample_uv = clamp(sample_uv, 0.0, 1.0);
				result += texture(TEXTURE, sample_uv).rgb;
			}
		}
		// Apply the result to the texture
		tex = vec4(result / 4.0, tex.a);
	}
	
	// Apply the texture without forgetting the modulate color
	COLOR = tex * modulate;
}