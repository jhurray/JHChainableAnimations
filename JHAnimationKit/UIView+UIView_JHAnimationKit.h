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
-(JHChainableRect)makeFrame;
-(JHChainableRect)makeBounds;
-(JHChainablePoint)makeOrigin;
-(JHChainablePoint)makeCenter;
-(JHChainableFloat)makeX;
-(JHChainableFloat)makeY;
-(JHChainableFloat)makeWidth;
-(JHChainableFloat)makeHeight;
-(JHChainableFloat)makeOpacity;
-(JHChainableColor)makeBackground;
-(JHChainableColor)makeTint;
-(JHChainableColor)makeBorderColor;
-(JHChainableFloat)makeBorderWidth;
-(JHChainableFloat)makeCornerRadius;

// Movers
-(JHChainableFloat)moveX;
-(JHChainableFloat)moveY;
-(JHChainablePoint)moveXY;
-(JHChainableDegrees)rotate;
-(JHChainableFloat)scaleX;
-(JHChainableFloat)scaleY;
-(JHChainablePoint)scaleXY;


// TODO: Anchor points!
//-(JHChainablePoint)anchor;

#pragma mark - Semantics

-(UIView *)then;

#pragma mark - Animations

// Animation Type
-(UIView *)easeIn;
-(UIView *)easeOut;
-(UIView *)easeInOut;

// Delay
-(JHChainableTimeInterval)delay;

// Executors
-(JHChainableAnimation)animate;
-(JHChainableAnimationWithCompletion)animateWithCompletion;

@end
