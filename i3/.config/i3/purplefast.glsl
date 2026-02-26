#version 330

in vec2 texcoord;
uniform sampler2D tex;
uniform float opacity;

vec4 default_post_processing(vec4 c);

vec4 window_shader() {
    // 1. Sample texture
    vec2 texsize = textureSize(tex, 0);
    vec4 c = textureLod(tex, texcoord / texsize, 0.0);

    // 2. Calculate Brightness (Grayscale)
    float gray = dot(c.rgb, vec3(0.2126, 0.7152, 0.0722));

    // 3. Define the two colors
    // The Tint: #4a3c77 (scaled for visibility)
    vec3 purple_tint = vec3(gray) * vec3(0.62, 0.50, 1.0);
    // The Highlight: Pure White (Grayscale)
    vec3 pure_white = vec3(gray);

    // 4. Mix them based on brightness
    // If pixel is dark -> use Purple Tint
    // If pixel is bright -> use Pure White
    // We use 'pow(gray, 3.0)' to push the "White" threshold high, 
    // so mid-tones stay purple and only actual bright text turns white.
    vec3 final_rgb = mix(purple_tint, pure_white, pow(gray, 3.0));

    // 5. Output
    vec4 color = vec4(final_rgb * opacity, c.a * opacity);

    return default_post_processing(color);
}
