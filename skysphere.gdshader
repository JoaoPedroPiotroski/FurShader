shader_type spatial;
render_mode cull_front;

uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform float blend_amount;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = mix(color1, color2, pow(UV.y, blend_amount));
	ALBEDO = color.rgb;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
}
