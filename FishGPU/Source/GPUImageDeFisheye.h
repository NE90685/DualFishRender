//
//  GPUImageDeFisheye.h
//  GPUImage
//
//  Created by Nhat Dinh Van on 8/16/16.
//

#import "GPUImageFilter.h"

typedef NS_ENUM(NSInteger, NVFishEyeType){
    
    NVFishEye_Default = 0,
    NVFishEye_SingleFish_180Degree, //Like device JUJINON(富士镜头)
    NVFishEye_SingleFish_206Degree, //Like Devie Kodak（pixpro sp360 4k）
    NVFishEye_SingleFish_235Degree, //Like Devie Kodak（pixpro sp360 4k）
    NVFishEye_DualFish_Theta
};

typedef struct FishDeviceInfo{
    
    //Shader source
    const char *vertexSrc;
    const char *fragSrc;
    
    //解析度
    const int width;
    const int height;
    
    //圆形图像的中心和半径
    const float circle[4];

    
}FishDeviceInfo;

const FishDeviceInfo shaderMap[] =
{
    // 1: 180° fish camera : 3.1415927 / 2 (≒ 180°/ 2)
    { "fisheye.vert",   "normal.frag",   1280,  720, 1.570796327f, 1.570796327f, 0.0f, 0.0f },
    
    // 2: 180° fish camera (FUJINON FE185C046HA-1 + SENTECH STC-MCE132U3V) : 3.5779249 / 2 (205°/ 2)
    { "fisheye.vert",   "normal.frag",   1280, 1024, 1.797689129f, 1.797689129f, 0.0f, 0.0f },
    
    // 3: 206° fish camera (Kodak PIXPRO SP360 4K) : 3.5953783 / 2 (206°/ 2)
    { "fisheye.vert",   "normal.frag",   1440, 1440, 1.797689129f, 1.797689129f, 0.0f, 0.0f },
    
    // 4: 235° fish camera (Kodak PIXPRO SP360 4K) : 4.1015237 / 2 (235°/ 2)
    { "fisheye.vert",   "normal.frag",   1440, 1440, 2.050761871f, 2.050761871f, 0.0f, 0.0f },
    
    // 5: RICHO THETA USB解析度  : (需要通过手动调节)
    { "theta.vert",     "theta.frag",    1280,  720, 1.003f, 1.003f, 0.0f, -0.002f },
    
    // 6: RICHO THETA HDMI解析度 : (需要通过手动调节)
    { "theta.vert",     "theta.frag",    1920,  1080, 1.003f, 1.003f, 0.0f, -0.002f }
};

@interface GPUImageDeFisheye : GPUImageFilter

- (void)updateDirectWithMatri:(GPUMatrix4x4)matricValue;


@end
