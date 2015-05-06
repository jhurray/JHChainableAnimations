//
//  UIView+UIView_JHAnimationKit.h
//  JHAnimationKitExample
//
//  Created by Jeff Hurray on 4/29/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

@import QuartzCore;
#import <UIKit/UIKit.h>
#import "JHChainableBlocks.h"


@interface UIView (UIView_JHChainableAnimations)

#pragma mark - Chainable Properties

// Makers
- (JHChainableRect) makeFrame;
- (JHChainableRect) makeBounds;
- (JHChainableSize) makeSize;
- (JHChainablePoint) makeOrigin;
- (JHChainablePoint) makeCenter;
- (JHChainableFloat) makeX;
- (JHChainableFloat) makeY;
- (JHChainableFloat) makeWidth;
- (JHChainableFloat) makeHeight;
- (JHChainableFloat) makeOpacity;
- (JHChainableColor) makeBackground;
- (JHChainableColor) makeBorderColor;
- (JHChainableFloat) makeBorderWidth;
- (JHChainableFloat) makeCornerRadius;
- (JHChainableFloat) makeScale;
- (JHChainableFloat) makeScaleX;
- (JHChainableFloat) makeScaleY;
- (JHChainablePoint) makeAnchor;

// Movers
- (JHChainableFloat) moveX;
- (JHChainableFloat) moveY;
- (JHChainablePoint) moveXY;
- (JHChainableFloat) moveHeight;
- (JHChainableFloat) moveWidth;
- (JHChainableDegrees) rotate;
- (JHChainablePolarCoordinate) movePolar;

// Anchors
- (UIView *) anchorDefault;
- (UIView *) anchorCenter;
- (UIView *) anchorTopLeft;
- (UIView *) anchorTopRight;
- (UIView *) anchorBottomLeft;
- (UIView *) anchorBottomRight;
- (UIView *) anchorTop;
- (UIView *) anchorBottom;
- (UIView *) anchorLeft;
- (UIView *) anchorRight;

#pragma mark - Multiple Animation Chaining

- (JHChainableTimeInterval) thenAfter;

#pragma mark - Animations

// Delay
- (JHChainableTimeInterval) delay;
- (JHChainableTimeInterval) wait; // same as delay

// Executors
- (JHChainableAnimation) animate;
- (JHChainableAnimationWithCompletion) animateWithCompletion;

@property (nonatomic, copy) JHAnimationCompletion animationCompletion;

#pragma mark - Semantics (Easier to read)

// view.moveX(10).thenAfter(1.0).seconds.rotate(90) == view.moveX(10).thenAfter(1.0).rotate(90)
- (UIView *) seconds;

#pragma mark - Animation Effects

// Simple effects
- (UIView *) easeIn;
- (UIView *) easeOut;
- (UIView *) easeInOut;
- (UIView *) easeBack;
- (UIView *) spring;
- (UIView *) bounce;

// Animation Keyframe Calculation Functions
// Functions from https://github.com/NachoSoto/NSBKeyframeAnimation
// source: http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
- (UIView *) easeInQuad;
- (UIView *) easeOutQuad;
- (UIView *) easeInOutQuad;
- (UIView *) easeInCubic;
- (UIView *) easeOutCubic;
- (UIView *) easeInOutCubic;
- (UIView *) easeInQuart;
- (UIView *) easeOutQuart;
- (UIView *) easeInOutQuart;
- (UIView *) easeInQuint;
- (UIView *) easeOutQuint;
- (UIView *) easeInOutQuint;
- (UIView *) easeInSine;
- (UIView *) easeOutSine;
- (UIView *) easeInOutSine;
- (UIView *) easeInExpo;
- (UIView *) easeOutExpo;
- (UIView *) easeInOutExpo;
- (UIView *) easeInCirc;
- (UIView *) easeOutCirc;
- (UIView *) easeInOutCirc;
- (UIView *) easeInElastic;
- (UIView *) easeOutElastic;
- (UIView *) easeInOutElastic;
- (UIView *) easeInBack;
- (UIView *) easeOutBack;
- (UIView *) easeInOutBack;
- (UIView *) easeInBounce;
- (UIView *) easeOutBounce;
- (UIView *) easeInOutBounce;

@end
