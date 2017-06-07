//
//  NVFishRenderView.m
//  DeFisheye
//
//  Created by Amuro Namie on 2017/6/5.
//  Copyright © 2017年 NaverChina. All rights reserved.
//

#import "NVFishRenderView.h"
#import <GLKit/GLKit.h>

#define MOVIE 0

@interface NVFishRenderView()

/** Parameters for rotate **/
@property(nonatomic, strong) NSMutableArray * currentTouches;
@property (assign, nonatomic) CGFloat fingerRotationX;
@property (assign, nonatomic) CGFloat fingerRotationY;

@property (assign, nonatomic) GLKMatrix4 modelViewMatrix;
@property (assign, nonatomic) GLKMatrix4 projectionMatrix;

@property (assign, nonatomic) CGFloat savedGyroRotationX;
@property (assign, nonatomic) CGFloat savedGyroRotationY;
/** Used for change pixel with shader **/
@property (nonatomic, strong) GPUImageView * filterView;
/** contain scale vlaue **/
@property(nonatomic, assign) CGFloat overture;
/** Record direction data for transform matrix **/
@property(nonatomic, assign) GLKMatrix4 pm;
@property(nonatomic, assign) GLKMatrix4 lastPm;
/** Used for manager 3D sphere rendering **/
@property(nonatomic, strong) id renderManger;
/** Used for scale 360 degree video **/
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;

@end

@implementation NVFishRenderView{
    
    CGPoint  _lastLoc;
}


- (instancetype)initWithRenderType:(NVFishEyeType)type
{
    self = [super init];
    if (self) {
        _lastLoc = CGPointMake(-1, -1);
        _overture = 75.0;
        _type = type;
        [self initialData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame renderType:(NVFishEyeType)type{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _lastLoc = CGPointMake(-1, -1);
        _overture = 75.0;
        _type = type;
        [self initialData];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        //Device motion data related
        _lastLoc = CGPointMake(-1, -1);
        _overture = 75.0;
    }
    return self;
}

- (void)setType:(NVFishEyeType)type{
    
    if (_type != type) {
        _type = type;
        [self initialData];
    }
}

- (void)startRender{
    
    if ([_renderManger isKindOfClass:[GPUImageMovie class]]) {
        [(GPUImageMovie *)_renderManger startProcessing];
    }else if ([_renderManger isKindOfClass:[GPUImagePicture class]]){
        [(GPUImagePicture *)_renderManger processImage];
    }else{
        NSLog(@"Unknown render manager, please check code!");
    }
}

- (void)initialData
{
    [self addGesture];
    self.overture = MAX_OVERTURE;

    filter = [[NVFishEyeFilter alloc] initWithType:_type];
    _filterView = [[GPUImageView alloc] initWithFrame:self.bounds];
    
    NSString * fileName = @"dubai.mp4";
    if (_type == NVFishEye_DualFish_Theta_HDMI ||
        _type == NVFishEye_DualFish_Theta_USB) {
        fileName = @"theta_s.MP4";
    }else if (_type == NVFishEye_Kodak_235Degree ||
              _type == NVFishEye_Kodak_206Degree){
        fileName = @"kodak_video.mp4";
    }
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    _renderManger = [[GPUImageMovie alloc] initWithURL:sampleURL];
    //TODO:Just test movie, need to remove later
#ifdef MOVIE
    GPUImageMovie * movie = _renderManger;
    movie.runBenchmark = YES;
    movie.playAtActualSpeed = YES;
    [movie addTarget:filter];
#else
    
#endif
    [self addSubview:_filterView];
    [filter addTarget:_filterView];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.03f
                                             target:self
                                           selector:@selector(frameUpdate)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)addGesture{
    
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handlePinchGesture:)];
    [self addGestureRecognizer:_pinchRecognizer];
}


- (void)setRenderImage:(UIImage *)renderImage{
    
#ifndef MOVIE
    GPUImagePicture * picture = [[GPUImagePicture alloc] initWithImage:renderImage];
    [picture addTarget:filter];
    [picture processImage];
#endif
    //update deirection
    [self updateDirection];
}

- (void)frameUpdate{
    
    [self updateDirection];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        [_currentTouches addObject:touch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    float distX = [touch locationInView:touch.view].x - [touch previousLocationInView:touch.view].x;
    float distY = [touch locationInView:touch.view].y - [touch previousLocationInView:touch.view].y;
    distX *= -0.005;
    distY *= -0.005;
    self.fingerRotationX += distY *  self.overture / 100;
    self.fingerRotationY -= distX *  self.overture / 100;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        [self.currentTouches removeObject:touch];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self.currentTouches removeObject:touch];
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    _overture /= recognizer.scale;
    
    if (_overture > MAX_OVERTURE) {
        _overture = MAX_OVERTURE;
    }
    
    if (_overture < MIN_OVERTURE) {
        _overture = MIN_OVERTURE;
    }
}


- (void)updateDirection{
    
    float aspect = 1.0;
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(_overture), aspect, 0.1f, 400.0f);
    _projectionMatrix = GLKMatrix4Rotate(_projectionMatrix, ES_PI, 1.0f, 0.0f, 0.0f);
    
    float scale = 1.0;
    _modelViewMatrix = GLKMatrix4Identity;
    _modelViewMatrix = GLKMatrix4Scale(_modelViewMatrix, scale, scale, scale);
    _modelViewMatrix = GLKMatrix4RotateX(_modelViewMatrix, self.fingerRotationX);
    _modelViewMatrix = GLKMatrix4RotateY(_modelViewMatrix, self.fingerRotationY);
    
    _pm = GLKMatrix4Multiply(_projectionMatrix, _modelViewMatrix);
    _projectionMatrix = _pm;
    GPUVector4 v0 = {_pm.m[0], _pm.m[1], _pm.m[2], _pm.m[3]};
    GPUVector4 v1 = {_pm.m[4], _pm.m[5], _pm.m[6], _pm.m[7]};
    GPUVector4 v2 = {_pm.m[8], _pm.m[9], _pm.m[10], _pm.m[11]};
    GPUVector4 v3 = {_pm.m[12], _pm.m[13], _pm.m[14], _pm.m[15]};
    GPUMatrix4x4 matricValue = {v0, v1, v2, v3};

    [(NVFishEyeFilter *)filter updateDirectWithMatri:matricValue];
    
}

- (void)dealloc
{
    [self removeGestureRecognizer:_pinchRecognizer];
}


@end
