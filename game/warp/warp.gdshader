shader_type canvas_item;

uniform float threshold: hint_range(0.0, 1.0, 0.05) = 0.5;
uniform vec3 color = vec3(0.0);

void fragment() {
	vec2 uv_centered = UV - 0.5;
	float distance_to_center = sqrt(pow(uv_centered.x, 2.0) + pow(uv_centered.y, 2.0));
	float alpha = (0.5 - distance_to_center) * 2.0;
	
	if (COLOR.a >= threshold) {
		COLOR = vec4(color, alpha);
	} else {
		COLOR = vec4(0.0);
	}
}
