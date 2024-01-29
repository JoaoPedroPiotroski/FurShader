shader_type spatial;

uniform sampler2D noise1;
uniform float amplitude;

void vertex() {
	vec3 noise = texture(noise1, UV).rgb;
	VERTEX.y += noise.y * amplitude;
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
}
