#version 300 es

precision mediump float;
//
// fisheye.frag
//
//   Use an image taken with a fisheye lens
//

// Texture
uniform sampler2D inputImageTexture;

// Background texture shift amount
uniform vec2 shift;

// Background texture scale and center position
uniform vec2 scale;

// Interpolation value of vertex attribute received from rasterizer
in vec3 textureCoordinate;

// Data to be output to the frame buffer
layout (location = 0) out vec4 fc;

// Inverse of zenith angle (θmax)
uniform float invTmax;

void main(void)
{
    // The direction vector of the line of sight passing through this fragment
    vec3 direction = normalize(textureCoordinate);
    
    // Texture coordinates
    vec2 st = normalize(textureCoordinate.xy) * acos(-direction.z) * invTmax;
    
    // Sampling color of gaze direction from whole fish eye image
    fc = texture(inputImageTexture, st * scale + shift);
}
