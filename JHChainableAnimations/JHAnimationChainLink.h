//
//  JHAnimationChainLink.h
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JHKeyframeAnimation.h"

@class JHChainableAnimator;
typedef void (^JHAnimationCalculationAction)(__weak UIView *view, __weak JHChainableAnimator *weakSelf);
typedef void (^JHAnimationCompletionAction)(__weak UIView *view, __weak JHChainableAnimator *weakSelf);

@interface JHAnimationChainLink : NSObject <NSCopying>

@property (nonatomic, copy) JHAnimationCalculationAction anchorCalculationAction;
@property (nonatomic, assign) NSTimeInterval animationDelay;

- (instancetype)initWithView:(UIView *)view animator:(JHChainableAnimator *)animator NS_DESIGNATED_INITIALIZER;

- (void)animateWithDuration:(NSTimeInterval)duration completion:(void(^)(void))completion;
- (void)addAnimationFromCalculationBlock:(JHKeyframeAnimation *)animation;
- (void)addAnimationKeyframeCalculation:(JHKeyframeAnimationCalculationBlock)functionBlock;
- (void)addAnimationCalculationAction:(JHAnimationCalculationAction)action;
- (void)addAnimationCompletionAction:(JHAnimationCompletionAction)action;
- (void)addPreAnimationBlock:(void(^)(void))preAnimationBlock;

@end
