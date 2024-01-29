shader_type spatial;

uniform sampler2D albedo_texture;
uniform float albedo_density;
uniform vec3 vertex_offset;
uniform bool spiky = true;
uniform float desired_thickness;
uniform float distance_bias;
uniform float curvature;
uniform vec3 droop_dir;
uniform float droop_strength;
uniform float min_light = 0.2;
uniform float density = 250.0;
uniform float attenuation = 2.0;
uniform vec3 color : source_color;
instance uniform float height ;
uniform float layer_dist = 0.2;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void vertex() {
	VERTEX.xyz += layer_dist * NORMAL * height;
	VERTEX += droop_dir * droop_strength * pow(1.-height, curvature);
	VERTEX += vertex_offset;
}

void fragment() {
	vec4 triplanar_coords = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	float rng = float(random(floor(UV * density)));
	vec2 local_space = fract(UV * density) * 2. - 1.;
	float distance_to_center = length(local_space);
	if (!spiky){
		distance_to_center = 0.0;
	}
	
	if (distance_to_center * distance_bias > desired_thickness * (rng-(height))) {
		discard;
	} else {
		vec3 sampled_color = texture(albedo_texture, UV ).rgb;
		vec3 t_sample_x = texture(albedo_texture, triplanar_coords.zy * albedo_density).rgb;
		vec3 t_sample_y = texture(albedo_texture, triplanar_coords.xz * albedo_density).rgb;
		vec3 t_sample_z = texture(albedo_texture, triplanar_coords.xy * albedo_density).rgb;
		
		vec3 world_normal = abs(INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
		vec3 normal_weights = world_normal / (world_normal.x + world_normal.y + world_normal.z);
		
		vec3 local_color = t_sample_x * normal_weights.x + t_sample_y * normal_weights.y + t_sample_z * normal_weights.z;
		ALBEDO.rgb = local_color * max(min_light, pow(height, attenuation));
	}
}
