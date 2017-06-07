//
//  GPUImageDeFisheye.m
//  GPUImage
//
//  Created by Nhat Dinh Van on 8/16/16.
//

#import "GPUImageDeFisheye.h"

#define PI 3.14159265358979
#define _THETA_S_Y_SCALE	(680.0 / 720.0)


@implementation GPUImageDeFisheye


- (id)init;
{
    NSString *fragmentShaderPathname = [[NSBundle mainBundle] pathForResource:@"Theta" ofType:@"fsh"];
    NSString *fragmentShaderString = [NSString stringWithContentsOfFile:fragmentShaderPathname encoding:NSUTF8StringEncoding error:nil];
    
    NSString *vecShaderPathname = [[NSBundle mainBundle] pathForResource:@"Theta" ofType:@"vsh"];
    NSString *vecgmentShaderString = [NSString stringWithContentsOfFile:vecShaderPathname encoding:NSUTF8StringEncoding error:nil];

    if (!(self = [self initWithVertexShaderFromString:vecgmentShaderString fragmentShaderFromString:fragmentShaderString])) {
        return nil;
    }
//  =====Test Theta ======
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat aspect = screenSize.width / screenSize.height;

    GLint uvOffsetUniform = [filterProgram uniformIndex:@"screen"];
    GPUVector4 uvOffset = {aspect, 1.0, 0.0, 0.0};
    [self setVec4:uvOffset forUniform:uvOffsetUniform program:filterProgram];
    
    
    [self setSize:CGSizeMake(_THETA_S_Y_SCALE, _THETA_S_Y_SCALE) forUniformName:@"scale"];
    [self setSize:CGSizeMake(PI, PI) forUniformName:@"shift"];
    
    GLint moOffsetUniform = [filterProgram uniformIndex:@"mo"];
    GPUMatrix4x4 moOffset = {0.0};
    [self setMatrix4f:moOffset forUniform:moOffsetUniform program:filterProgram];
//  =====Test Theta ======
    
//    =====Test Kodak====
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    CGFloat aspect = screenSize.width / screenSize.height;
////    aspect = 1.0;
//    
//    GLint uvOffsetUniform = [filterProgram uniformIndex:@"screen"];
//    GPUVector4 uvOffset = {aspect, 1.0, 0.0, 0.0};
//    [self setVec4:uvOffset forUniform:uvOffsetUniform program:filterProgram];
//    
//    
//    [self setSize:CGSizeMake(0.5, 0.5) forUniformName:@"scale"];
//    [self setSize:CGSizeMake(0.5, 0.5) forUniformName:@"shift"];
//    
//    GLint moOffsetUniform = [filterProgram uniformIndex:@"mo"];
//    GPUMatrix4x4 moOffset = {0.0};
//    [self setMatrix4f:moOffset forUniform:moOffsetUniform program:filterProgram];
//    
//    [self setFloat:0.4876237  forUniformName:@"invTmax"];
//    =====Test Kodak====
    
    return self;
}

- (void)updateDirectWithMatri:(GPUMatrix4x4)matricValue{
    
    GLint moOffsetUniform = [filterProgram uniformIndex:@"mo"];
    [self setMatrix4f:matricValue forUniform:moOffsetUniform program:filterProgram];
}

@end

