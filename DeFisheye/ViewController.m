//
//  ViewController.m
//  DeFisheye
//
//  Created by Amuro Namie on 2017/6/2.
//  Copyright © 2017年 NaverChina. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import "NVFishEyeFilter.h"
#import "NVFishRenderView.h"

@implementation ViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Test Video file
    NVFishRenderView * renderView = [[NVFishRenderView alloc] initWithFrame:self.view.bounds renderType:NVFishEye_DualFish_Theta_HDMI];
    [self.view addSubview:renderView];
    [renderView startRender];
}


@end
