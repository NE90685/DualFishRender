//
//  NVFishRenderView.h
//  DeFisheye
//
//  Created by Amuro Namie on 2017/6/5.
//  Copyright © 2017年 NaverChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import "NVFishEyeFilter.h"

#define MAX_OVERTURE 95.0
#define MIN_OVERTURE 25.0
#define ES_PI  (3.14159265f)

@interface NVFishRenderView : UIView{
    GPUImageMovie *movieFile;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    NSTimer * timer;
}

@property(nonatomic, strong) UIImage * renderImage;
@property(nonatomic, assign) NVFishEyeType type;

- (instancetype)initWithFrame:(CGRect)frame renderType:(NVFishEyeType)type;

- (void)startRender;

@end
