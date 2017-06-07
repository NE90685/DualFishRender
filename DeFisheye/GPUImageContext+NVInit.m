//
//  GPUImageContext+NVInit.m
//  DeFisheye
//
//  Created by Amuro Namie on 2017/6/5.
//  Copyright © 2017年 NaverChina. All rights reserved.
//

#import "GPUImageContext+NVInit.h"
#import <objc/runtime.h>

@implementation GPUImageContext (NVInit)

+(void)load{
    
    //Swizzling method
    //Change OpenGL environment to ES 3.0
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        SEL originalSelector;
        unsigned int count = 0;
        Method * memberFuns = class_copyMethodList(class, &count);
        for (int i = 0; i < count; i++) {
            
            SEL name = method_getName(memberFuns[i]);
            NSString * methodName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
            if ([methodName isEqualToString:@"createContext"]) {
                originalSelector = name;
                SEL swizzledSelector = @selector(createContext_swizzling);
                
                Method originalMethod = class_getInstanceMethod(class, originalSelector);
                Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
                
                BOOL didAddMethod =
                class_addMethod(class,
                                originalSelector,
                                method_getImplementation(swizzledMethod),
                                method_getTypeEncoding(swizzledMethod));
                
                if (didAddMethod) {
                    class_replaceMethod(class,
                                        swizzledSelector,
                                        method_getImplementation(originalMethod),
                                        method_getTypeEncoding(originalMethod));
                } else {
                    method_exchangeImplementations(originalMethod, swizzledMethod);
                }
                break;
            }
        }
    });
    
}

- (EAGLContext *)createContext_swizzling;
{
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3 sharegroup:[self valueForKey:@"_sharegroup"]];
    NSAssert(context != nil, @"Unable to create an OpenGL ES 3.0 context. The GPUImage framework requires OpenGL ES 3.0 support to work.");
    return context;
}

@end
