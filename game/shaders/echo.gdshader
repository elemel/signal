shader_type spatial;

render_mode unshaded;

uniform vec3 ping_positions[16];
uniform float ping_times[16];
uniform int ping_count;

uniform float wave_speed = 5.0;
uniform float wave_width = 0.5;

uniform float debug = 1.0;

void fragment() {
    vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
    vec3 world_normal = mat3(INV_VIEW_MATRIX) * NORMAL;

	vec3 color = vec3(0.0);

	for (int i = 0; i < 16; ++i) {
	    float dist = distance(ping_positions[i], world_pos);

	    float wave_front = (TIME - ping_times[i]) * wave_speed;
	    float dist_to_wave = abs(dist - wave_front);

	    color += 1.0 - smoothstep(0.0, wave_width, dist_to_wave);
	}

	vec3 debug_color = vec3(0.5) + 0.5 * world_normal;

    ALBEDO = mix(color, debug_color, debug);
    EMISSION = mix(color, debug_color, debug);
}
