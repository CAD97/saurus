shader_type canvas_item;
render_mode blend_mix;

vec3 hex_round(vec3 frac)
{
	float q = round(frac.x);
	float r = round(frac.y);
	float s = round(frac.z);
	
	float q_diff = abs(q - frac.x);
	float r_diff = abs(r - frac.y);
	float s_diff = abs(s - frac.z);
	
	if (q_diff > r_diff && q_diff > s_diff) {
		q = -r-s;
	} else if (r_diff > s_diff) {
		r = -q-s;
	} else {
		s = -q-r;
	}
	
	return vec3(q, r, s);
}

vec2 uv_to_hex(vec2 uv, vec2 scale)
{
    float q = uv.x * (scale.x - 1.0);
    float r = uv.y * (scale.y - 0.5) - (q/2.0);
    float s = -q-r;
    vec2 axial_pos = hex_round(vec3(q, r, s)).xy;
    
    float offset = fract(axial_pos.x/2.0);
    offset = floor(offset*2.0);
    vec2 oddq_pos = vec2(axial_pos.x, axial_pos.y + (axial_pos.x-offset)/2.0);
    return (oddq_pos + vec2(0.5)) / scale;
}

uniform sampler2D mask_texture : hint_default_white, filter_nearest, repeat_disable;

void fragment() {
	vec2 mask_uv = uv_to_hex(UV, vec2(textureSize(mask_texture, 0)));
	float mask = texture(mask_texture, mask_uv).r;
	mask = mask < 0.001 ? 0.0 : 1.0;
	COLOR *= mask;
	//COLOR = texture(mask_texture, UV);
}
