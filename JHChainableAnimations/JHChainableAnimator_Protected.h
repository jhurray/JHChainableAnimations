//
//  JHChainableAnimator_Protected.h
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 1/8/17.
//  Copyright © 2017 jhurray. All rights reserved.
//

#import "JHChainableAnimator.h"
#import "JHAnimationChainLink.h"
#import "JHKeyframeAnimation.h"
#import "JHKeyframeAnimationFunctions.h"

typedef NS_ENUM(NSInteger, JHChainableAnimatorContinuationMode) {
    JHChainableAnimatorContinuationModeContinue,
    JHChainableAnimatorContinuationModePause,
    JHChainableAnimatorContinuationModeStop,
};

@interface JHChainableAnimator ()

@property (nonatomic, weak) UIView *view;
@property (strong, nonatomic) NSMutableArray<JHAnimationChainLink *> *animationChainLinks;
@property (strong, nonatomic) NSMapTable<JHAnimationChainLink *, NSNumber *> *animationDurationMapping;
@property (atomic, assign, getter=isAnimating) BOOL animating;
@property (atomic, assign, getter=isPaused) BOOL paused;
@property (nonatomic, assign) JHChainableAnimatorContinuationMode continuationMode;
@property (nonatomic, readonly) JHAnimationChainLink *currentAnimationLink;

@end
