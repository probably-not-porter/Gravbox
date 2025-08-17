shader_type canvas_item;

// These uniforms allow you to customize the look of the clouds from the Inspector.
// They must be defined with "hint" or "range" for the Godot editor to show them.
uniform float cloud_speed : hint_range(0.0, 1.0) = 0.1;
uniform float cloud_scale : hint_range(0.1, 10.0) = 4.0;
uniform float cloud_density : hint_range(0.0, 1.0) = 0.5;

// This new uniform is a texture that will define the colors of the clouds.
// A GradientTexture2D or a small image with a color palette works well here.
// Note: Ensure the GradientTexture2D has a wide-enough width (e.g., 512) and
// a good range of colors to see proper color animation.
uniform sampler2D color_texture;
uniform float color_speed : hint_range(0.0, 1.0) = 0.05;

// A simple 2D noise function to generate the cloud shapes.
// This is a common method for generating procedural textures.
vec2 random_2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return fract(sin(p) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f); // Smoothstep curve for interpolation

    vec2 a = random_2(i);
    vec2 b = random_2(i + vec2(1.0, 0.0));
    vec2 c = random_2(i + vec2(0.0, 1.0));
    vec2 d = random_2(i + vec2(1.0, 1.0));

    float r1 = mix(a.x, b.x, f.x);
    float r2 = mix(c.x, d.x, f.x);
    return mix(r1, r2, f.y);
}

void fragment() {
    // Animate the cloud texture by moving the UV coordinates over time.
    vec2 animated_uv = UV * cloud_scale + vec2(TIME * cloud_speed, TIME * cloud_speed);
    
    // Generate the noise value for the current pixel.
    float cloud_noise = noise(animated_uv);
    
    // Use the noise value and density uniform to create a mask.
    // The clamp function ensures the value stays between 0.0 and 1.0.
    float cloud_mask = clamp((cloud_noise - cloud_density) / (1.0 - cloud_density), 0.0, 1.0);
    
    // Read the original color from the sprite's texture.
    vec4 base_color = texture(TEXTURE, UV);
    
    // We modify the mask by multiplying it with the alpha of the original texture.
    // This ensures that the cloud effect is only applied to pixels that are not transparent.
    cloud_mask *= base_color.a;

    // We now use a single UV coordinate for the color texture that cycles smoothly
    // from 0.0 to 1.0 over time, ensuring all colors in the gradient are used.
    float color_uv = fract(TIME * color_speed);
    vec4 sampled_cloud_color = texture(color_texture, vec2(color_uv, 0.5));

    // Blend the sampled cloud color with the base color based on the modified mask.
    // The final color will keep the original texture's transparency where the mask is 0.
    vec4 final_color = mix(base_color, sampled_cloud_color, cloud_mask);
    
    // Output the final color to the screen.
    COLOR = final_color;
}
