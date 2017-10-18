//
//  JHAnimationChainLink.m
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

#import "JHAnimationChainLink.h"
#import "JHChainableAnimator.h"
#import "JHKeyframeAnimation.h"
#import "JHKeyframeAnimationFunctions.h"

static NSString * const kJHAnimationGroupKey = @"kJHAnimationGroupKey";

@interface JHAnimationChainLink ()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) JHChainableAnimator *animator;
@property (nonatomic, strong) NSMutableArray<JHKeyframeAnimation *> *animations;
@property (nonatomic, strong) CAAnimationGroup *animationGroup;
@property (nonatomic, strong) NSMutableArray<void(^)(void)> *preAnimationBlocks;
@property (nonatomic, strong) NSMutableArray<JHAnimationCalculationAction> *animationCalculationActions;
@property (nonatomic, strong) NSMutableArray<JHAnimationCompletionAction> *animationCompletionActions;

@end


@implementation JHAnimationChainLink

- (instancetype)init
{
    NSAssert(NO, @"JHChainableAnimator: Must use `- (instancetype)initWithView:(UIView *)view animator:animator` method.");
    [self doesNotRecognizeSelector:_cmd];
    return [self initWithView:nil animator:nil];
}


- (instancetype)initWithView:(UIView *)view animator:(JHChainableAnimator *)animator
{
    self = [super init];
    if (self) {
        _view = view;
        _animator = animator;
        _animationDelay = 0;
        _animations = [NSMutableArray new];
        _animationGroup = [CAAnimationGroup animation];
        _animationCalculationActions = [NSMutableArray new];
        _animationCompletionActions = [NSMutableArray new];
        _preAnimationBlocks = [NSMutableArray new];
    }
    return self;
}


- (id)copyWithZone:(nullable NSZone *)zone
{
    JHAnimationChainLink *copy = [[JHAnimationChainLink allocWithZone:zone] initWithView:self.view animator:self.animator];
    copy.anchorCalculationAction = [self.anchorCalculationAction copy];
    copy.animationDelay = self.animationDelay;
    copy.animations = [self.animations mutableCopy];
    copy.animationGroup = [self.animationGroup copy];
    copy.animationCalculationActions = [self.animationCalculationActions mutableCopy];
    copy.animationCompletionActions = [self.animationCompletionActions mutableCopy];
    copy.preAnimationBlocks = [self.preAnimationBlocks mutableCopy];
    return copy;
}


- (JHKeyframeAnimation *)basicAnimationForKeyPath:(NSString *)keypath
{
    JHKeyframeAnimation * animation = [JHKeyframeAnimation animationWithKeyPath:keypath];
    animation.repeatCount = 0;
    animation.autoreverses = NO;
    return animation;
}

- (void)addAnimationFromCalculationBlock:(JHKeyframeAnimation *)animation
{
    [self.animations addObject:animation];
}


- (void)addAnimationKeyframeCalculation:(JHKeyframeAnimationCalculationBlock)functionBlock
{
    JHKeyframeAnimation *animation = [self.animations lastObject];
    animation.functionBlock = [functionBlock copy];
}


- (void)addAnimationCalculationAction:(JHAnimationCalculationAction)action
{
    [self.animationCalculationActions addObject:[action copy]];
}


- (void)addAnimationCompletionAction:(JHAnimationCompletionAction)action
{
    [self.animationCompletionActions addObject:[action copy]];
}


- (void)addPreAnimationBlock:(void(^)(void))preAnimationBlock
{
    [self.preAnimationBlocks addObject:[preAnimationBlock copy]];
}


- (void)animateWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        [self.view.layer removeAnimationForKey:kJHAnimationGroupKey];
        [self executeCompletionActions];
        if (completion != nil) {
            completion();
        }
    }];
    
    self.animationGroup.duration = duration;
    [self beginExecution];
    
    [CATransaction commit];
}


- (void)beginExecution
{
    for (void(^block)(void) in self.preAnimationBlocks) {
        block();
    }
    
    if (self.anchorCalculationAction != nil) {
        self.anchorCalculationAction(self.view, self.animator);
    }
    
    for (JHAnimationCalculationAction action in self.animationCalculationActions) {
        action(self.view, self.animator);
    }
    for (JHKeyframeAnimation *animation in self.animations) {
        animation.duration = self.animationGroup.duration;
        [animation calculate];
    }
    self.animationGroup.beginTime = CACurrentMediaTime() + self.animationDelay;
    self.animationGroup.animations = self.animations;
    [self.view.layer addAnimation:self.animationGroup forKey:kJHAnimationGroupKey];
}


- (void)executeCompletionActions
{
    for (JHAnimationCompletionAction action in self.animationCompletionActions) {
        action(self.view, self.animator);
    }
}

@end
