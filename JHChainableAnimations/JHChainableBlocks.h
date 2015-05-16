//
//  JHChainableBlocks.h
//  JHAnimationKitExample
//
//  Created by Jeff Hurray on 4/29/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef JHAnimationKitExample_JHChainableBlocks_h
#define JHAnimationKitExample_JHChainableBlocks_h

#pragma mark - Chainable Block Types + Declarations

typedef UIView* (^JHChainable)();
#define JHChainable() ^UIView* ()

typedef UIView* (^JHChainableTimeInterval)(NSTimeInterval t);
#define JHChainableTimeInterval(t) ^UIView* (NSTimeInterval t)

typedef UIView* (^JHChainableRect)(CGRect rect);
#define JHChainableRect(rect) ^UIView* (CGRect rect)

typedef UIView* (^JHChainableSize)(CGFloat width, CGFloat height);
#define JHChainableSize(width,height) ^UIView* (CGFloat width, CGFloat height)

typedef UIView* (^JHChainablePoint)(CGFloat x, CGFloat y);
#define JHChainablePoint(x,y) ^UIView* (CGFloat x, CGFloat y)

typedef UIView* (^JHChainableFloat)(CGFloat f);
#define JHChainableFloat(f) ^UIView* (CGFloat f)

typedef UIView* (^JHChainableDegrees)(CGFloat angle);
#define JHChainableDegrees(angle) ^UIView* (CGFloat angle)

typedef UIView* (^JHChainablePolarCoordinate)(CGFloat radius, CGFloat angle);
#define JHChainablePolarCoordinate(radius,angle) ^UIView* (CGFloat radius, CGFloat angle)

typedef UIView* (^JHChainableColor)(UIColor *color);
#define JHChainableColor(color) ^UIView* (UIColor *color)

typedef UIView* (^JHChainableLayoutConstraint)(NSLayoutConstraint *constraint, CGFloat f);
#define JHChainableLayoutConstraint(constraint,f) ^UIView* (NSLayoutConstraint *constraint, CGFloat f)

typedef UIView* (^JHChainableBezierPath)(UIBezierPath *path);
#define JHChainableBezierPath(path) ^UIView* (UIBezierPath *path)

typedef void    (^JHAnimationCompletion)();
#define JHAnimationCompletion() ^void ()

typedef UIView* (^JHChainableAnimation)(NSTimeInterval duration);
#define JHChainableAnimation(duration) ^UIView* (NSTimeInterval duration)

typedef UIView* (^JHChainableAnimationWithCompletion)(NSTimeInterval duration, JHAnimationCompletion completion);
#define JHChainableAnimationWithCompletion(duration,completion) ^UIView* (NSTimeInterval duration, JHAnimationCompletion completion)


#endif
