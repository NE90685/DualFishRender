//
//  NVFishEyeFilter.h
//  DeFisheye
//
//  Created by Amuro Namie on 2017/6/5.
//  Copyright © 2017年 NaverChina. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import <GLKit/GLKit.h>

#define PI 3.14159265358979
#define _THETA_S_Y_SCALE	(680.0 / 720.0)


typedef NS_ENUM(NSInteger, NVFishEyeType){
    
    NVFishEye_Default = 0,
    //Equirectangular
    NVFishEye_Equirectangular,
    //Single fish eye
    NVFishEye_Common_180Degree,
    NVFishEye_Jujinon_180Degree, //Like device JUJINON(富士镜头)
    NVFishEye_Kodak_206Degree, //Like Devie Kodak（pixpro sp360 4k）
    NVFishEye_Kodak_235Degree, //Like Devie Kodak（pixpro sp360 4k）
    //Dual fish eye
    NVFishEye_DualFish_Theta_USB, //Theta USB
    NVFishEye_DualFish_Theta_HDMI,//Theta HDMI
    NVFishEye_DualFish_Count
};

typedef struct FishDeviceInfo{
    
    //Shader source
    const char *vertexSrc;
    const char *fragSrc;
    
    //解析度
    const int width;
    const int height;
    
    //圆形图像的中心和半径
    const float circle[2];
    
    const float scale[2];
    
    const float shift[2];
    
}FishDeviceInfo;


//The scale data and shift should ajust with device
//Only kodak and theta is right
//TODO: change scale and shift value for right device
const static FishDeviceInfo shaderMaps[] =
{
    // 0: Default
    { "normal",     "normal",    640,  480, 1.0f, 1.0f, 0.5f, 0.5f, 0.5f, 0.5f},
    
    // 1: 180° fish camera : 3.1415927 / 2 (≒ 180°/ 2)
    { "normal",   "Equirectangular",   1280,  720, 1.570796327f, 1.570796327f, 0.5f, 0.5f, 0.5f, 0.5f},

    // 1: 180° fish camera : 3.1415927 / 2 (≒ 180°/ 2)
    { "normal",   "FishEye",   1280,  720, 1.570796327f, 1.570796327f, 0.5f, 0.5f, 0.5f, 0.5f},
    
    // 2: 180° fish camera (FUJINON FE185C046HA-1 + SENTECH STC-MCE132U3V) : 3.5779249 / 2 (205°/ 2)
    { "normal",   "FishEye",   1280, 1024, 1.797689129f, 1.797689129f, 0.5f, 0.5f, 0.5f, 0.5f},
    
    // 3: 206° fish camera (Kodak PIXPRO SP360 4K) : 3.5953783 / 2 (206°/ 2)
    { "normal",   "FishEye",   1440, 1440, 1.797689129f, 1.797689129f, 0.5f, 0.5f, 0.5f, 0.5f},
    
    // 4: 235° fish camera (Kodak PIXPRO SP360 4K) : 4.1015237 / 2 (235°/ 2)
    { "normal",   "FishEye",   1440, 1440, 2.050761871f, 2.050761871f, 0.4876237f, 0.4876237f, 0.5f, 0.5f},
    
    // 5: RICHO THETA USB解析度  : (需要通过手动调节)
    { "normal",     "Theta",    1280,  720, 1.003f, 1.003f, 1.0f, 1.0f, PI, PI},
    
    // 6: RICHO THETA HDMI解析度 : (需要通过手动调节)
    { "normal",     "Theta",    1920,  1080, 1.003f, 1.003f, 1.0f, 1.0f, PI, PI }
};




@interface NVFishEyeFilter : GPUImageFilter

- (id)initWithType:(NVFishEyeType)type;

- (void)updateDirectWithMatri:(GPUMatrix4x4)matricValue;

- (void)updateScaleWithValue:(CGFloat)value;

- (void)updateTransformWithValue:(GLKMatrix4)matrix;

@end
