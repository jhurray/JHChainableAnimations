//
//  JHChainableBlocks.h
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

@class JHChainableAnimator;

typedef JHChainableAnimator * (^JHChainable)(void);
#define JHChainable() ^JHChainableAnimator * (void)

typedef JHChainableAnimator * (^JHChainableTimeInterval)(NSTimeInterval t);
#define JHChainableTimeInterval(t) ^JHChainableAnimator * (NSTimeInterval t)

typedef JHChainableAnimator * (^JHChainableRect)(CGRect rect);
#define JHChainableRect(rect) ^JHChainableAnimator * (CGRect rect)

typedef JHChainableAnimator * (^JHChainableSize)(CGFloat width, CGFloat height);
#define JHChainableSize(width,height) ^JHChainableAnimator * (CGFloat width, CGFloat height)

typedef JHChainableAnimator * (^JHChainablePoint)(CGFloat x, CGFloat y);
#define JHChainablePoint(x,y) ^JHChainableAnimator * (CGFloat x, CGFloat y)

typedef JHChainableAnimator * (^JHChainableFloat)(CGFloat f);
#define JHChainableFloat(f) ^JHChainableAnimator * (CGFloat f)

typedef JHChainableAnimator * (^JHChainableDegrees)(CGFloat angle);
#define JHChainableDegrees(angle) ^JHChainableAnimator * (CGFloat angle)

typedef JHChainableAnimator * (^JHChainablePolarCoordinate)(CGFloat radius, CGFloat angle);
#define JHChainablePolarCoordinate(radius,angle) ^JHChainableAnimator * (CGFloat radius, CGFloat angle)

typedef JHChainableAnimator * (^JHChainableColor)(UIColor *color);
#define JHChainableColor(color) ^JHChainableAnimator * (UIColor *color)

typedef JHChainableAnimator * (^JHChainableBlock)(void(^)(void));
#define JHChainableBlock(block) ^JHChainableAnimator * (void(^block)(void))

typedef JHChainableAnimator * (^JHChainableBezierPath)(UIBezierPath *path);
#define JHChainableBezierPath(path) ^JHChainableAnimator * (UIBezierPath *path)

typedef JHChainableAnimator * (^JHChainableCustomKeyframeAnimationCalculation)(double(^keyframeAnimationCalculationBlock)(double t, double b, double c, double d));
#define JHChainableCustomKeyframeAnimationCalculation(block) ^JHChainableAnimator * (double(^block)(double t, double b, double c, double d))

typedef JHChainableAnimator * (^JHChainableAnimation)(NSTimeInterval duration);
#define JHChainableAnimation(duration) ^JHChainableAnimator * (NSTimeInterval duration)

typedef JHChainableAnimator * (^JHChainableAnimationWithCompletion)(NSTimeInterval duration, void(^completion)(void));
#define JHChainableAnimationWithCompletion(duration,completion) ^JHChainableAnimator * (NSTimeInterval duration, void(^completion)(void))

typedef JHChainableAnimator * (^JHChainableRepeatAnimation)(NSTimeInterval t, NSInteger count);
#define JHChainableRepeatAnimation(t, count) ^JHChainableAnimator * (NSTimeInterval t, NSInteger count)
