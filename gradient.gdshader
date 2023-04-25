shader_type canvas_item;

uniform vec4 topleft:source_color;
uniform vec4 topright:source_color;
uniform vec4 bottomleft:source_color;
uniform vec4 bottomright:source_color;

void fragment() {
	vec2 uv_corner = vec3(UV, 0.0).xy;
	vec4 top = mix(topleft, topright, uv_corner.x);
	vec4 bottom = mix(bottomleft, bottomright, uv_corner.x);
	COLOR =  mix(top, bottom, uv_corner.y);
}