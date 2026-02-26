#version 330

in vec2 texcoord;
uniform sampler2D tex;
uniform float opacity;
uniform float time;

// --- CONFIGURATION ---
// Controls the color bleeding (Red/Blue separation).
// 0.0 = Crisp Image, 0.001 = Heavy Blur/TV look
const float CHROMATIC_ABERRATION = 0.0005;

// Controls how dark the horizontal lines are.
// 0.0 = No lines, 0.5 = Heavy dark lines
const float SCANLINE_INTENSITY = 0.40;

// Controls how dark the corners of the screen get.
// 0.0 = Flat brightness, 0.5 = Heavy tunnel vision
const float VIGNETTE_INTENSITY = 0.18;

// Controls the overall screen brightness.
// Since scanlines darken the screen, you usually need > 1.0 here.
const float BRIGHTNESS_BOOST = 1.9;
// --- END CONFIGURATION ---

vec4 window_shader() {
    // 1. Setup Coordinates
    vec2 texsize = textureSize(tex, 0);
    vec2 uv = texcoord / texsize;
    float t = time * 0.001;

    // 2. Chromatic Aberration (Phosphor Bleed)
    float r = texture(tex, uv + vec2(CHROMATIC_ABERRATION, 0.0)).r;
    float g = texture(tex, uv).g;
    float b = texture(tex, uv - vec2(CHROMATIC_ABERRATION, 0.0)).b;
    vec3 col = vec3(r, g, b);

    // 3. Scanlines
    // Generates a moving sine wave pattern based on Y coordinate
    float scans = clamp(0.35 + 0.35 * sin(3.5 * t + uv.y * texsize.y * 1.5), 0.0, 1.0);
    
    // Apply intensity curve. We mix the original color with the darkened scanline color.
    float s = pow(scans, 1.7);
    col = col * vec3(1.0 - SCANLINE_INTENSITY + (SCANLINE_INTENSITY * s));

    // 4. Vignette (Dark Corners)
    // Distance from center (0.5, 0.5)
    float dist = distance(uv, vec2(0.5));
    // Create a smooth dark circle. The '0.8' is the radius where darkness starts.
    float vig = smoothstep(0.8, 0.8 - (VIGNETTE_INTENSITY * 2.0), dist);
    col *= vec3(vig);

    // 5. Brightness & Contrast
    col *= BRIGHTNESS_BOOST;
    col = mix(col, col * col, 0.3); // Add slight contrast curve

    // Output
    return vec4(col, 1.0) * opacity;
}
