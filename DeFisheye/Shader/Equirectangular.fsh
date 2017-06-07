#version 300 es
//
// theta.frag
//
//   Use images shot with RICOH THETA S Or equirectangular view
//
precision mediump float;
// Texture
uniform sampler2D inputImageTexture;

// Background texture shift amount
uniform vec2 shift;

// Background texture scale and center position
uniform vec2 scale;

// Interpolation value of vertex attribute received from rasterizer
in vec3 textureCoordinate;                                   // texture coordinate

// Data to be output to the frame buffer
layout (location = 0) out vec4 fc;

void main(void)
{
    // Sampling the color of the gaze direction from the forward distance cylindrical projection image
    fc = texture(inputImageTexture, atan(textureCoordinate.xy, vec2(textureCoordinate.z, length(textureCoordinate.xz))) * vec2(-0.15915494, -0.31830989) + 0.5);
}
