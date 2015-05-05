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


@interface UIView (UIView_JHAnimationKit)

#pragma mark - Chainable Properties

// Makers
- (JHChainableRect) makeFrame;
- (JHChainableRect) makeBounds;
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

#pragma mark - Semantics (Easier to read)

// view.moveX(10).thenAfter(1.0).seconds.rotate(90) == view.moveX(10).thenAfter(1.0).rotate(90)
- (UIView *) seconds;

#pragma mark - Multiple Animation Chaining

- (JHChainableTimeInterval) thenAfter;

#pragma mark - Animations

// Animation Type
- (UIView *) easeIn;
- (UIView *) easeOut;
- (UIView *) easeInOut;

// Spraaaaangs
// TODO ADD SPRINGS

// Delay
- (JHChainableTimeInterval) delay;
- (JHChainableTimeInterval) wait; // same as delay

// Executors
- (JHChainableAnimation) animate;
- (JHChainableAnimationWithCompletion) animateWithCompletion;

@property (nonatomic, copy) JHAnimationCompletion animationCompletion;

@end
