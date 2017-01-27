//
//  JHKeyframeAnimation.h
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef double(^JHKeyframeAnimationCalculationBlock)(double t, double b, double c, double d);

@interface JHKeyframeAnimation : CAKeyframeAnimation 

@property (nonatomic, copy) JHKeyframeAnimationCalculationBlock functionBlock;

@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

- (void)calculate;

@end
