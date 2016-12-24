//
//  JHChainableBlocks.h
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

@protocol JHViewAnimator;

typedef id<JHViewAnimator> (^JHChainable)();
#define JHChainable() ^id<JHViewAnimator> ()

typedef id<JHViewAnimator> (^JHChainableTimeInterval)(NSTimeInterval t);
#define JHChainableTimeInterval(t) ^id<JHViewAnimator> (NSTimeInterval t)

typedef id<JHViewAnimator> (^JHChainableRect)(CGRect rect);
#define JHChainableRect(rect) ^id<JHViewAnimator> (CGRect rect)

typedef id<JHViewAnimator> (^JHChainableSize)(CGFloat width, CGFloat height);
#define JHChainableSize(width,height) ^id<JHViewAnimator> (CGFloat width, CGFloat height)

typedef id<JHViewAnimator> (^JHChainablePoint)(CGFloat x, CGFloat y);
#define JHChainablePoint(x,y) ^id<JHViewAnimator> (CGFloat x, CGFloat y)

typedef id<JHViewAnimator> (^JHChainableFloat)(CGFloat f);
#define JHChainableFloat(f) ^id<JHViewAnimator> (CGFloat f)

typedef id<JHViewAnimator> (^JHChainableDegrees)(CGFloat angle);
#define JHChainableDegrees(angle) ^id<JHViewAnimator> (CGFloat angle)

typedef id<JHViewAnimator> (^JHChainablePolarCoordinate)(CGFloat radius, CGFloat angle);
#define JHChainablePolarCoordinate(radius,angle) ^id<JHViewAnimator> (CGFloat radius, CGFloat angle)

typedef id<JHViewAnimator> (^JHChainableColor)(UIColor *color);
#define JHChainableColor(color) ^id<JHViewAnimator> (UIColor *color)

typedef id<JHViewAnimator> (^JHChainableBlock)(void(^)());
#define JHChainableBlock(block) ^id<JHViewAnimator> (void(^block)())

typedef id<JHViewAnimator> (^JHChainableBezierPath)(UIBezierPath *path);
#define JHChainableBezierPath(path) ^id<JHViewAnimator> (UIBezierPath *path)

typedef id<JHViewAnimator> (^JHChainableCustomKeyframeAnimationCalculation)(double(^keyframeAnimationCalculationBlock)(double t, double b, double c, double d));
#define JHChainableCustomKeyframeAnimationCalculation(block) ^id<JHViewAnimator> (double(^block)(double t, double b, double c, double d))

typedef id<JHViewAnimator> (^JHChainableAnimation)(NSTimeInterval duration);
#define JHChainableAnimation(duration) ^id<JHViewAnimator> (NSTimeInterval duration)

typedef id<JHViewAnimator> (^JHChainableAnimationWithCompletion)(NSTimeInterval duration, void(^completion)());
#define JHChainableAnimationWithCompletion(duration,completion) ^id<JHViewAnimator> (NSTimeInterval duration, void(^completion)())

typedef id<JHViewAnimator> (^JHChainableRepeatAnimation)(NSTimeInterval t, NSInteger count);
#define JHChainableRepeatAnimation(t, count) ^id<JHViewAnimator> (NSTimeInterval t, NSInteger count)
