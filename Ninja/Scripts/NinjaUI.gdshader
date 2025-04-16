shader_type canvas_item;

uniform float cooldown_progress : hint_range(0.0, 1.0); // 0 = full grayscale, 1 = full color

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Convert texture to grayscale
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    // Blend between grayscale and original color using cooldown progress
    vec3 final_color = mix(vec3(gray), tex_color.rgb, cooldown_progress);

    // Preserve transparency
    COLOR = vec4(final_color, tex_color.a);
}
