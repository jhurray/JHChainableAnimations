//
//  JHKeyframeAnimation.h
//  JHAnimationKitExample
//
//  Created by Jeff Hurray on 5/5/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NSBKeyframeAnimationFunctions.h"

@interface JHKeyframeAnimation : CAKeyframeAnimation

// From https://github.com/NachoSoto/NSBKeyframeAnimation
typedef double(^NSBKeyframeAnimationFunctionBlock)(double t, double b, double c, double d);
@property (nonatomic, copy) NSBKeyframeAnimationFunctionBlock functionBlock;

@property(strong, nonatomic) id fromValue;
@property(strong, nonatomic) id toValue;

-(void) calculate;

@end
