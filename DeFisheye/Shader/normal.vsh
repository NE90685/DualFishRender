#version 300 es

// tracking.vert
//
//   Perform head tracking and mobile device motion tacking
//

// vertex position
layout (location = 0) in vec4 position;

// Oculus Rift rotation or mobile device motion change
uniform mat4 mo;

// screen's center location
uniform vec4 screen;

// texture's coordinate
out vec3 textureCoordinate;

//uniform mat4 modelViewProjectionMatrix;

void main()
{
    // Convert vertex coordinates to direction vector
    textureCoordinate = vec3(mo * vec4(position.xy * screen.xy + screen.zw, -1.0, 0.0));
    
    // Output vertex coordinates, this means coordinate does not change with projection
    gl_Position = position;
}
