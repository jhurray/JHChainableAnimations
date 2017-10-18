//
//  JHChainableAnimator.h
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JHChainableBlocks.h"

@interface JHChainableAnimator : NSObject

/// Called after the last animation in the chain has completed
@property (nonatomic, copy) void(^completionBlock)(void);

/// If the animatoris paused, the view will still be animating. animating will only be false if the animation ends or is stopped
@property (atomic, assign, getter=isAnimating, readonly) BOOL animating;
@property (atomic, assign, getter=isPaused, readonly) BOOL paused;

@property (nonatomic, weak, readonly) UIView *view;

- (instancetype)initWithView:(UIView *)view NS_DESIGNATED_INITIALIZER;

/// Will pause animations but retain state. `isAnimating` will remain true.
- (void)pause;
/// Will resume animations if the animator is paused and animating
- (void)resume;
/// Will stop animations and clear state
- (void)stop;

@end


@interface JHChainableAnimator (JH_ChainableMethods)

#pragma mark - Chainable Properties
// Makers
// Affects views position and bounds
- (JHChainableRect)makeFrame;
- (JHChainableRect)makeBounds;
- (JHChainableSize)makeSize;
- (JHChainablePoint)makeOrigin;
- (JHChainablePoint)makeCenter;
- (JHChainableFloat)makeX;
- (JHChainableFloat)makeY;
- (JHChainableFloat)makeWidth;
- (JHChainableFloat)makeHeight;
- (JHChainableFloat)makeOpacity;
- (JHChainableColor)makeBackground;
- (JHChainableColor)makeBorderColor;
- (JHChainableFloat)makeBorderWidth;
- (JHChainableFloat)makeCornerRadius;
- (JHChainableFloat)makeScale;
- (JHChainableFloat)makeScaleX;
- (JHChainableFloat)makeScaleY;
- (JHChainablePoint)makeAnchor;

// Movers
// Affects views position and bounds
- (JHChainableFloat)moveX;
- (JHChainableFloat)moveY;
- (JHChainablePoint)moveXY;
- (JHChainableFloat)moveHeight;
- (JHChainableFloat)moveWidth;
- (JHChainablePolarCoordinate)movePolar;

// Transforms
// Affects views transform property NOT position and bounds
// These should be used for AutoLayout
// These should NOT be mixed with properties that affect position and bounds
- (JHChainableAnimator *)transformIdentity;
- (JHChainableDegrees)rotate; // Same as rotateZ
- (JHChainableDegrees)rotateX;
- (JHChainableDegrees)rotateY;
- (JHChainableDegrees)rotateZ;
- (JHChainableFloat)transformX;
- (JHChainableFloat)transformY;
- (JHChainableFloat)transformZ;
- (JHChainablePoint)transformXY;
- (JHChainableFloat)transformScale; // x and y equal
- (JHChainableFloat)transformScaleX;
- (JHChainableFloat)transformScaleY;


#pragma mark - Bezier Paths
// Animation effects dont apply
- (JHChainableBezierPath)moveOnPath;
- (JHChainableBezierPath)moveAndRotateOnPath;
- (JHChainableBezierPath)moveAndReverseRotateOnPath;


#pragma mark - Anchors
- (JHChainableAnimator *)anchorDefault;
- (JHChainableAnimator *)anchorCenter;
- (JHChainableAnimator *)anchorTopLeft;
- (JHChainableAnimator *)anchorTopRight;
- (JHChainableAnimator *)anchorBottomLeft;
- (JHChainableAnimator *)anchorBottomRight;
- (JHChainableAnimator *)anchorTop;
- (JHChainableAnimator *)anchorBottom;
- (JHChainableAnimator *)anchorLeft;
- (JHChainableAnimator *)anchorRight;


#pragma mark - Delays
- (JHChainableTimeInterval)delay;
- (JHChainableTimeInterval)wait;


#pragma mark - Keyframe Calculation Functions
- (JHChainableAnimator *)easeIn;
- (JHChainableAnimator *)easeOut;
- (JHChainableAnimator *)easeInOut;
- (JHChainableAnimator *)easeBack;
- (JHChainableAnimator *)spring;
- (JHChainableAnimator *)bounce;
- (JHChainableAnimator *)easeInQuad;
- (JHChainableAnimator *)easeOutQuad;
- (JHChainableAnimator *)easeInOutQuad;
- (JHChainableAnimator *)easeInCubic;
- (JHChainableAnimator *)easeOutCubic;
- (JHChainableAnimator *)easeInOutCubic;
- (JHChainableAnimator *)easeInQuart;
- (JHChainableAnimator *)easeOutQuart;
- (JHChainableAnimator *)easeInOutQuart;
- (JHChainableAnimator *)easeInQuint;
- (JHChainableAnimator *)easeOutQuint;
- (JHChainableAnimator *)easeInOutQuint;
- (JHChainableAnimator *)easeInSine;
- (JHChainableAnimator *)easeOutSine;
- (JHChainableAnimator *)easeInOutSine;
- (JHChainableAnimator *)easeInExpo;
- (JHChainableAnimator *)easeOutExpo;
- (JHChainableAnimator *)easeInOutExpo;
- (JHChainableAnimator *)easeInCirc;
- (JHChainableAnimator *)easeOutCirc;
- (JHChainableAnimator *)easeInOutCirc;
- (JHChainableAnimator *)easeInElastic;
- (JHChainableAnimator *)easeOutElastic;
- (JHChainableAnimator *)easeInOutElastic;
- (JHChainableAnimator *)easeInBack;
- (JHChainableAnimator *)easeOutBack;
- (JHChainableAnimator *)easeInOutBack;
- (JHChainableAnimator *)easeInBounce;
- (JHChainableAnimator *)easeOutBounce;
- (JHChainableAnimator *)easeInOutBounce;
- (JHChainableCustomKeyframeAnimationCalculation)customAnimationFunction;

#pragma mark - Blocks
// Allows handling in in context of the animation state
- (JHChainableBlock)preAnimationBlock;
- (JHChainableBlock)postAnimationBlock;


#pragma mark - Animations
- (JHChainableRepeatAnimation)repeat;
- (JHChainableTimeInterval)thenAfter;
- (JHChainableAnimation)animate;
- (JHChainableRepeatAnimation)animateWithRepeat;
- (JHChainableAnimationWithCompletion)animateWithCompletion;

@end


