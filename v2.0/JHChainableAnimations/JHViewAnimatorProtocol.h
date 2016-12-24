//
//  JHViewAnimatorProtocol.h
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JHChainableBlocks.h"

@protocol JHViewAnimator <NSObject>

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
- (id<JHViewAnimator>)transformIdentity;
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
- (id<JHViewAnimator>)anchorDefault;
- (id<JHViewAnimator>)anchorCenter;
- (id<JHViewAnimator>)anchorTopLeft;
- (id<JHViewAnimator>)anchorTopRight;
- (id<JHViewAnimator>)anchorBottomLeft;
- (id<JHViewAnimator>)anchorBottomRight;
- (id<JHViewAnimator>)anchorTop;
- (id<JHViewAnimator>)anchorBottom;
- (id<JHViewAnimator>)anchorLeft;
- (id<JHViewAnimator>)anchorRight;


#pragma mark - Delays
- (JHChainableTimeInterval)delay;
- (JHChainableTimeInterval)wait;


#pragma mark - Keyframe Calculation Functions
- (id<JHViewAnimator>)easeIn;
- (id<JHViewAnimator>)easeOut;
- (id<JHViewAnimator>)easeInOut;
- (id<JHViewAnimator>)easeBack;
- (id<JHViewAnimator>)spring;
- (id<JHViewAnimator>)bounce;
- (id<JHViewAnimator>)easeInQuad;
- (id<JHViewAnimator>)easeOutQuad;
- (id<JHViewAnimator>)easeInOutQuad;
- (id<JHViewAnimator>)easeInCubic;
- (id<JHViewAnimator>)easeOutCubic;
- (id<JHViewAnimator>)easeInOutCubic;
- (id<JHViewAnimator>)easeInQuart;
- (id<JHViewAnimator>)easeOutQuart;
- (id<JHViewAnimator>)easeInOutQuart;
- (id<JHViewAnimator>)easeInQuint;
- (id<JHViewAnimator>)easeOutQuint;
- (id<JHViewAnimator>)easeInOutQuint;
- (id<JHViewAnimator>)easeInSine;
- (id<JHViewAnimator>)easeOutSine;
- (id<JHViewAnimator>)easeInOutSine;
- (id<JHViewAnimator>)easeInExpo;
- (id<JHViewAnimator>)easeOutExpo;
- (id<JHViewAnimator>)easeInOutExpo;
- (id<JHViewAnimator>)easeInCirc;
- (id<JHViewAnimator>)easeOutCirc;
- (id<JHViewAnimator>)easeInOutCirc;
- (id<JHViewAnimator>)easeInElastic;
- (id<JHViewAnimator>)easeOutElastic;
- (id<JHViewAnimator>)easeInOutElastic;
- (id<JHViewAnimator>)easeInBack;
- (id<JHViewAnimator>)easeOutBack;
- (id<JHViewAnimator>)easeInOutBack;
- (id<JHViewAnimator>)easeInBounce;
- (id<JHViewAnimator>)easeOutBounce;
- (id<JHViewAnimator>)easeInOutBounce;
- (JHChainableCustomKeyframeAnimationCalculation)customAnimationFunction;

#pragma mark - Blocks
// Allows handling in in context of the animation state
- (JHChainableBlock)preAnimationBlock;
- (JHChainableBlock)animationBlock;
- (JHChainableBlock)postAnimationBlock;


#pragma mark - Animations
- (JHChainableRepeatAnimation)repeat;
- (JHChainableTimeInterval)thenAfter;
- (JHChainableAnimation)animate;
- (JHChainableAnimationWithCompletion)animateWithCompletion;

@end
