shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D mask_texture : hint_default_white, filter_linear, repeat_disable;

void fragment() {
	vec2 sample_offset = 0.2 / vec2(textureSize(mask_texture, 0));
	float mask = texture(mask_texture, UV).r;
	mask = mask < 0.4 ? 0.0 : 1.0;
	COLOR *= mask;
}
