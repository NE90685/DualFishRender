//
//  NVFishEyeFilter.m
//  DeFisheye
//
//  Created by Amuro Namie on 2017/6/5.
//  Copyright © 2017年 NaverChina. All rights reserved.
//

#import "NVFishEyeFilter.h"

@implementation NVFishEyeFilter{
    
    FishDeviceInfo _deviceInfo;
}

- (id)initWithType:(NVFishEyeType)type{
    
    _deviceInfo = shaderMaps[type];
    NSAssert1(type != 0, @"Attention!: device type is unknown, error chould happen", nil);
    
    NSString *fragPath = [NSString stringWithCString:_deviceInfo.fragSrc encoding:NSUTF8StringEncoding];
    NSString *vertexPath = [NSString stringWithCString:_deviceInfo.vertexSrc encoding:NSUTF8StringEncoding];
    
    //load shader file
    NSString *fragmentShaderPathname = [[NSBundle mainBundle] pathForResource:fragPath ofType:@"fsh"];
    NSString *fragmentShaderString = [NSString stringWithContentsOfFile:fragmentShaderPathname encoding:NSUTF8StringEncoding error:nil];
    
    NSString *vecShaderPathname = [[NSBundle mainBundle] pathForResource:vertexPath ofType:@"vsh"];
    NSString *vecgmentShaderString = [NSString stringWithContentsOfFile:vecShaderPathname encoding:NSUTF8StringEncoding error:nil];
    
    //compile shader file
    if (!(self = [self initWithVertexShaderFromString:vecgmentShaderString fragmentShaderFromString:fragmentShaderString])) {
        return nil;
    }
    
    //set public uniform parameter
    //1. 3D matrix change, rotate
    GLint moOffsetUniform = [filterProgram uniformIndex:@"mo"];
    GPUMatrix4x4 moOffset = {0.0};
    [self setMatrix4f:moOffset forUniform:moOffsetUniform program:filterProgram];
    
    //2. Devcie diffrent parameter
    CGFloat aspect = _deviceInfo.width / _deviceInfo.height;
    GLint uvOffsetUniform = [filterProgram uniformIndex:@"screen"];
    GPUVector4 uvOffset = {aspect, 1.0, 0.0, 0.0};
    [self setVec4:uvOffset forUniform:uvOffsetUniform program:filterProgram];
    
    
    [self setSize:CGSizeMake(_deviceInfo.scale[0], _deviceInfo.scale[1]) forUniformName:@"scale"];
    
    [self setSize:CGSizeMake(_deviceInfo.shift[0], _deviceInfo.shift[1]) forUniformName:@"shift"];
    
    //Set invTmax value
    //Only single fish eye need it
    if (type < (NVFishEye_DualFish_Count - 2)) {
        
        CGFloat invTmax = 1.0 / _deviceInfo.circle[0];
        [self setFloat:invTmax  forUniformName:@"invTmax"];
    }
   
    return self;
}

- (void)updateDirectWithMatri:(GPUMatrix4x4)matricValue{
    
    GLint moOffsetUniform = [filterProgram uniformIndex:@"mo"];
    [self setMatrix4f:matricValue forUniform:moOffsetUniform program:filterProgram];
}

- (void)updateTransformWithValue:(GLKMatrix4)matrix{
    
    GLint moOffsetUniform = [filterProgram uniformIndex:@"mo"];
    glUniformMatrix4fv(moOffsetUniform, 1, GL_FALSE, matrix.m);
}

- (void)updateScaleWithValue:(CGFloat)value{
    
    CGFloat realValue = value;
    if (value > 1.0 && value < 10.0) {
        value /= 10.0;
    }else if (value > 10){
        value /= 100.0;
    }
    [self setSize:CGSizeMake(realValue, realValue) forUniformName:@"scale"];
}


@end
