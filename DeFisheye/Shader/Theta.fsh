#version 300 es
//#extension GL_ARB_explicit_attrib_location : enable
//#extension GL_ARB_explicit_uniform_location : enable

//
// thetalive.frag
//
//   Use live streaming video of RICOH THETA S
//
precision mediump float;
// texture
uniform sampler2D inputImageTexture;

// Background texture shift amount
uniform vec2 shift;

// Background texture scale and center position
uniform vec2 scale;

// Interpolation value of vertex attribute received from rasterizer
in vec3 textureCoordinate;                                   // Texture coordinates

// Data to be output to the frame buffer
layout (location = 0) out vec4 fc;                  // Fragment color

void main(void)
{
    // The direction vector of the line of sight passing through this fragment
    vec3 direction = normalize(textureCoordinate);
    
    // Relative elevation angle [-1, 1] of this direction vector
    float angle = acos(direction.z) * 0.63661977 - 1.0;
    
    // The mixing ratio of the texture before and after
    float blend = 0.5 - clamp(angle * 10.0, -0.5, 0.5);
    
    // Orientation vector on the xy plane of the direction vector of the line of sight
    vec2 orientation = normalize(textureCoordinate.yx) * 0.885;
    
    // Size of double fish eye texture
    vec2 size = vec2(textureSize(inputImageTexture, 0));
    
    // 1/2 of the height of the image circle of the fisheye image
    float aspect = size.x * 0.25 / size.y;
    
    // Radius of front and rear image circle
    vec2 radius_f = vec2( 0.25, aspect);
    vec2 radius_b = vec2(-0.25, aspect);
    
    // Center of image circle before and after
    vec2 center_f = vec2(0.75, aspect);
    vec2 center_b = vec2(0.25, aspect);
    
    // Sampling the colors of the previous and next textures
    vec4 color_f = texture(inputImageTexture, (1.0 - angle) * orientation * radius_f + center_f);
    vec4 color_b = texture(inputImageTexture, (1.0 + angle) * orientation * radius_b + center_b);
    
    // Blend the sampled colors to find the color of the fragment
    fc = mix(color_f, color_b, blend);
}
