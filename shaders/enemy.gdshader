shader_type canvas_item;

uniform float squish_scale: hint_range(-10.0, 10.0) = 1.0;

void fragment() {
    vec2 new_uv = UV;
    
    // Calculate distortion
    float width_factor = abs(new_uv.y - 0.5) * squish_scale;
    float height_factor = abs(new_uv.x - 0.5) * squish_scale;

    // Apply distortion
    new_uv.x = mix(new_uv.x, 0.5 + (new_uv.x - 0.5) * (1.0 - width_factor), squish_scale);
    new_uv.y = mix(new_uv.y, 0.5 + (new_uv.y - 0.5) * (1.0 + height_factor), squish_scale);

    // Fetch the color from the distorted UV coordinate
    COLOR = texture(TEXTURE, new_uv);
}
