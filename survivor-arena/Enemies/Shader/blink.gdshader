shader_type canvas_item;

uniform vec4 blink_color: source_color;
uniform float blink_intensity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec4 base_color = tex_color * COLOR;
    vec3 mixed_rgb = mix(base_color.rgb, blink_color.rgb, blink_intensity);
    COLOR = vec4(mixed_rgb, base_color.a);
}