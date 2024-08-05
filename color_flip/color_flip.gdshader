shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable;

void fragment() {
	COLOR = textureLod(screen_texture, SCREEN_UV, 0.0);
	if (UV.y > 0.5) {
		COLOR.rgb = vec3(1.0) - COLOR.rgb;
	}
}
