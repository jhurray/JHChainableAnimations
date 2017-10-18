//
//  JHChainableAnimator.m
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
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

#define JHDegreesToRadians( degrees )( ( degrees )/ 180.0 * M_PI )
#define JHRadiansToDegrees( radians )( ( radians )* ( 180.0 / M_PI ))


@implementation JHChainableAnimator

- (instancetype)init
{
    NSAssert(NO, @"JHChainableAnimator: Must use `- (instancetype)initWithView:(UIView *)view` method.");
    [self doesNotRecognizeSelector:_cmd];
    return [self initWithView:nil];
}


- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        NSParameterAssert(view != nil);
        _view = view;
        [self clear];
    }
    return self;
}


- (void)clear
{
    self.completionBlock = nil;
    self.animationDurationMapping = [NSMapTable weakToStrongObjectsMapTable];
    JHAnimationChainLink *chainLink = [[JHAnimationChainLink alloc] initWithView:self.view animator:self];
    self.animationChainLinks = [NSMutableArray arrayWithObject:chainLink];
    self.continuationMode = JHChainableAnimatorContinuationModeContinue;
}


- (void)pause
{
    self.continuationMode = JHChainableAnimatorContinuationModePause;
}


- (void)resume
{
    if (self.continuationMode == JHChainableAnimatorContinuationModePause && self.isAnimating) {
        self.continuationMode = JHChainableAnimatorContinuationModeContinue;
        [self animateChain];
    }
}


- (void)stop
{
    self.continuationMode = JHChainableAnimatorContinuationModeStop;
}


- (JHAnimationChainLink *)currentAnimationLink
{
    return self.animationChainLinks.lastObject;
}


- (void)animateChain
{
    switch (self.continuationMode) {
        case JHChainableAnimatorContinuationModeContinue:
        {
            self.animating = YES;
            self.paused = NO;
            JHAnimationChainLink *chainLink = self.animationChainLinks.firstObject;
            if (chainLink != nil) {
                NSTimeInterval duration = [self.animationDurationMapping objectForKey:chainLink].doubleValue;
                [chainLink animateWithDuration:duration completion:^{
                    [self.animationChainLinks removeObjectAtIndex:0];
                    [self animateChain];
                }];
            }
            else {
                void(^completionBlock)(void) = self.completionBlock ?: ^{};
                [self clear];
                completionBlock();
                self.animating = NO;
            }
            break;
        }
        case JHChainableAnimatorContinuationModePause:
        {
            self.paused = YES;
            self.animating = YES;
            break;
        }
        case JHChainableAnimatorContinuationModeStop:
        {
            self.paused = NO;
            self.animating = NO;
            [self clear];
            break;
        }
    }
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
    [self.animationChainLinks.firstObject addAnimationFromCalculationBlock:animation];
}


- (void)addAnimationCalculationAction:(JHAnimationCalculationAction)action
{
    [self.currentAnimationLink addAnimationCalculationAction:[action copy]];
}


- (void)addAnimationCompletionAction:(JHAnimationCompletionAction)action
{
    [self.currentAnimationLink addAnimationCompletionAction:[action copy]];
}


- (CGPoint)newPositionFromNewFrame:(CGRect)newRect
{
    CGPoint anchor = self.view.layer.anchorPoint;
    CGSize size = newRect.size;
    CGPoint newPosition;
    newPosition.x = newRect.origin.x + anchor.x*size.width;
    newPosition.y = newRect.origin.y + anchor.y*size.height;
    return newPosition;
}

- (CGPoint)newPositionFromNewOrigin:(CGPoint)newOrigin
{
    CGPoint anchor = self.view.layer.anchorPoint;
    CGSize size = self.view.bounds.size;
    CGPoint newPosition;
    newPosition.x = newOrigin.x + anchor.x*size.width;
    newPosition.y = newOrigin.y + anchor.y*size.height;
    return newPosition;
}

- (CGPoint)newPositionFromNewCenter:(CGPoint)newCenter
{
    CGPoint anchor = self.view.layer.anchorPoint;
    CGSize size = self.view.bounds.size;
    CGPoint newPosition;
    newPosition.x = newCenter.x + (anchor.x-0.5)*size.width;
    newPosition.y = newCenter.y + (anchor.y-0.5)*size.height;
    return newPosition;
}


- (void)makeAnchorFromX:(CGFloat) x Y:(CGFloat)y
{
    JHAnimationCalculationAction action = ^void(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
        CGPoint anchorPoint = CGPointMake(x, y);
        if (CGPointEqualToPoint(anchorPoint, view.layer.anchorPoint)) {
            return;
        }
        CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                       view.bounds.size.height * anchorPoint.y);
        CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                       view.bounds.size.height * view.layer.anchorPoint.y);
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
        
        CGPoint position = view.layer.position;
        
        position.x -= oldPoint.x;
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    };
    self.currentAnimationLink.anchorCalculationAction = [action copy];
}


- (JHChainableRepeatAnimation)repeat
{
    JHChainableRepeatAnimation chainable = JHChainableRepeatAnimation(t, count) {
        
        @synchronized (self) {
            for (NSInteger i = 0; i < count; ++i) {
                JHAnimationChainLink *previousChainLink = self.animationChainLinks.lastObject;
                NSParameterAssert(previousChainLink != nil);
                if (previousChainLink != nil) {
                    [self.animationDurationMapping setObject:@(t) forKey:previousChainLink];
                }
                
                JHAnimationChainLink *newChainLink;
                BOOL isRepeatedChainLink = (i + 1 < count);
                if (isRepeatedChainLink) {
                    newChainLink = [previousChainLink copy];
                }
                else {
                    newChainLink = [[JHAnimationChainLink alloc] initWithView:self.view animator:self];
                }
                [self.animationChainLinks addObject:newChainLink];
            }
            
            return self;
        }
    };
    
    return chainable;
}


- (JHChainableTimeInterval)thenAfter
{
    
    JHChainableTimeInterval chainable = JHChainableTimeInterval(t) {
        
        return self.repeat(t, 1);
    };
    
    return chainable;
}


- (JHChainableAnimation)animate
{
    JHChainableAnimation chainable = JHChainableAnimation(t) {
        
        return self.animateWithCompletion(t, self.completionBlock);
    };
    
    return chainable;
}


- (JHChainableRepeatAnimation)animateWithRepeat
{
    JHChainableRepeatAnimation chainable = JHChainableRepeatAnimation(t, count) {
        @synchronized (self) {
            for (NSInteger i = 0; i < count; ++i) {
                JHAnimationChainLink *previousChainLink = self.animationChainLinks.lastObject;
                NSParameterAssert(previousChainLink != nil);
                if (previousChainLink != nil) {
                    [self.animationDurationMapping setObject:@(t) forKey:previousChainLink];
                }
                
                BOOL isRepeatedChainLink = (i + 1 < count);
                if (isRepeatedChainLink) {
                    JHAnimationChainLink *newChainLink = [previousChainLink copy];
                    [self.animationChainLinks addObject:newChainLink];
                }
                else {
                    [self animateChain];
                }
            }
            
            return self;
        }
    };
    return chainable;
}


- (JHChainableAnimationWithCompletion)animateWithCompletion
{
    JHChainableAnimationWithCompletion chainable = JHChainableAnimationWithCompletion(t, completion) {
        
        @synchronized (self) {
            self.completionBlock = completion;
            JHAnimationChainLink *previousChainLink = self.animationChainLinks.lastObject;
            if (previousChainLink != nil) {
                [self.animationDurationMapping setObject:@(t) forKey:previousChainLink];
            }
            [self animateChain];
            
            return self;
        }
    };
    
    return chainable;
}


#pragma mark - Chainable Properties
- (JHChainableRect)makeFrame
{
    JHChainableRect chainable = JHChainableRect(rect) {
        
        return self.makeOrigin(rect.origin.x, rect.origin.y).makeBounds(rect);
    };
    
    return chainable;
}


- (JHChainableRect)makeBounds
{
    JHChainableRect chainable = JHChainableRect(rect) {
        
        return self.makeSize(rect.size.width, rect.size.height);
    };
    return chainable;
}


- (JHChainableSize)makeSize
{
    JHChainableSize chainable = JHChainableSize(width, height) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *sizeAnimation = [weakSelf basicAnimationForKeyPath:@"bounds.size"];
            sizeAnimation.fromValue = [NSValue valueWithCGSize:view.layer.bounds.size];
            sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(width, height)];
            [weakSelf addAnimationFromCalculationBlock:sizeAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGRect bounds = CGRectMake(0, 0, width, height);
            view.layer.bounds = bounds;
            view.bounds = bounds;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainablePoint)makeOrigin
{
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(x, y)];
            positionAnimation.fromValue = [NSValue valueWithCGPoint:view.layer.position];
            positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(x, y)];
            view.layer.position = newPosition;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainablePoint)makeCenter
{
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            CGPoint newPosition = [weakSelf newPositionFromNewCenter:CGPointMake(x, y)];
            positionAnimation.fromValue = [NSValue valueWithCGPoint:view.layer.position];
            positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            view.center = CGPointMake(x, y);
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)makeX
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position.x"];
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(f, view.layer.frame.origin.y)];
            positionAnimation.fromValue = @(view.layer.position.x);
            positionAnimation.toValue = @(newPosition.x);
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(f, view.layer.frame.origin.y)];
            view.layer.position = newPosition;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)makeY
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position.y"];
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(view.layer.frame.origin.x, f)];
            positionAnimation.fromValue = @(view.layer.position.y);
            positionAnimation.toValue = @(newPosition.y);
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(view.layer.frame.origin.x, f)];
            view.layer.position = newPosition;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)makeWidth
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *sizeAnimation = [weakSelf basicAnimationForKeyPath:@"bounds.size"];
            sizeAnimation.fromValue = [NSValue valueWithCGSize:view.layer.bounds.size];
            sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(f, view.frame.size.height)];
            [weakSelf addAnimationFromCalculationBlock:sizeAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGRect bounds = CGRectMake(0, 0, f, view.frame.size.height);
            view.layer.bounds = bounds;
            view.bounds = bounds;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)makeHeight
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *sizeAnimation = [weakSelf basicAnimationForKeyPath:@"bounds.size"];
            sizeAnimation.fromValue = [NSValue valueWithCGSize:view.layer.bounds.size];
            sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(view.frame.size.width, f)];
            [weakSelf addAnimationFromCalculationBlock:sizeAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGRect bounds = CGRectMake(0, 0, view.frame.size.width, f);
            view.layer.bounds = bounds;
            view.bounds = bounds;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)makeOpacity
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *opacityAnimation = [weakSelf basicAnimationForKeyPath:@"opacity"];
            opacityAnimation.fromValue = @(view.alpha);
            opacityAnimation.toValue = @(f);
            [weakSelf addAnimationFromCalculationBlock:opacityAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            view.alpha = f;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableColor)makeBackground
{
    JHChainableColor chainable = JHChainableColor(color) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *colorAnimation = [weakSelf basicAnimationForKeyPath:@"backgroundColor"];
            colorAnimation.fromValue = view.backgroundColor;
            colorAnimation.toValue = color;
            [weakSelf addAnimationFromCalculationBlock:colorAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            view.layer.backgroundColor = color.CGColor;
            view.backgroundColor = color;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableColor)makeBorderColor
{
    JHChainableColor chainable = JHChainableColor(color) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *colorAnimation = [weakSelf basicAnimationForKeyPath:@"borderColor"];
            UIColor *borderColor = (__bridge UIColor*)(view.layer.borderColor);
            colorAnimation.fromValue = borderColor;
            colorAnimation.toValue = color;
            [weakSelf addAnimationFromCalculationBlock:colorAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            view.layer.borderColor = color.CGColor;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)makeBorderWidth
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        f = MAX(0, f);
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *borderAnimation = [weakSelf basicAnimationForKeyPath:@"borderWidth"];
            borderAnimation.fromValue = @(view.layer.borderWidth);
            borderAnimation.toValue = @(f);
            [weakSelf addAnimationFromCalculationBlock:borderAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            view.layer.borderWidth = f;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)makeCornerRadius
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        f = MAX(0, f);
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *cornerAnimation = [weakSelf basicAnimationForKeyPath:@"cornerRadius"];
            cornerAnimation.fromValue = @(view.layer.cornerRadius);
            cornerAnimation.toValue = @(f);
            [weakSelf addAnimationFromCalculationBlock:cornerAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            view.layer.cornerRadius = f;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)makeScale
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, MAX(view.bounds.size.width*f, 0), MAX(view.bounds.size.height*f, 0));
            boundsAnimation.fromValue = [NSValue valueWithCGRect:view.layer.bounds];
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGRect rect = CGRectMake(0, 0, MAX(view.bounds.size.width*f, 0), MAX(view.bounds.size.height*f, 0));
            view.layer.bounds = rect;
            view.bounds = rect;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)makeScaleX
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, MAX(view.bounds.size.width*f, 0), view.bounds.size.height);
            boundsAnimation.fromValue = [NSValue valueWithCGRect:view.layer.bounds];
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGRect rect = CGRectMake(0, 0, MAX(view.bounds.size.width*f, 0), view.bounds.size.height);
            view.layer.bounds = rect;
            view.bounds = rect;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)makeScaleY
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, view.bounds.size.width, MAX(view.bounds.size.height*f, 0));
            boundsAnimation.fromValue = [NSValue valueWithCGRect:view.layer.bounds];
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGRect rect = CGRectMake(0, 0, view.bounds.size.width, MAX(view.bounds.size.height*f, 0));
            view.layer.bounds = rect;
            view.bounds = rect;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainablePoint)makeAnchor
{
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        
        [self makeAnchorFromX:x Y:y];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)moveX
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position.x"];
            positionAnimation.fromValue = @(view.layer.position.x);
            positionAnimation.toValue = @(view.layer.position.x+f);
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGPoint position = view.layer.position;
            position.x += f;
            view.layer.position = position;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)moveY
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position.y"];
            positionAnimation.fromValue = @(view.layer.position.y);
            positionAnimation.toValue = @(view.layer.position.y+f);
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGPoint position = view.layer.position;
            position.y += f;
            view.layer.position = position;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainablePoint)moveXY
{
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            CGPoint oldOrigin = view.layer.frame.origin;
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(oldOrigin.x+x, oldOrigin.y+y)];
            positionAnimation.fromValue = [NSValue valueWithCGPoint:view.layer.position];
            positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGPoint position = view.layer.position;
            position.x +=x; position.y += y;
            view.layer.position = position;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)moveHeight
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *sizeAnimation = [weakSelf basicAnimationForKeyPath:@"bounds.size"];
            sizeAnimation.fromValue = [NSValue valueWithCGSize:view.layer.bounds.size];
            sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(view.bounds.size.width, MAX(view.bounds.size.height+f, 0))];
            [weakSelf addAnimationFromCalculationBlock:sizeAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGRect bounds = CGRectMake(0, 0, view.bounds.size.width, MAX(view.bounds.size.height+f, 0));
            view.layer.bounds = bounds;
            view.bounds = bounds;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableFloat)moveWidth
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *sizeAnimation = [weakSelf basicAnimationForKeyPath:@"bounds.size"];
            sizeAnimation.fromValue = [NSValue valueWithCGSize:view.layer.bounds.size];
            sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(MAX(view.bounds.size.width+f, 0), view.bounds.size.height)];
            [weakSelf addAnimationFromCalculationBlock:sizeAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGRect bounds = CGRectMake(0, 0, MAX(view.bounds.size.width+f, 0), view.bounds.size.height);
            view.layer.bounds = bounds;
            view.bounds = bounds;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableDegrees)rotate
{
    return [self rotateZ];
}


- (JHChainableDegrees)rotateX
{
    JHChainableDegrees chainable = JHChainableDegrees(angle) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *rotationAnimation = [weakSelf basicAnimationForKeyPath:@"transform.rotation.x"];
            CATransform3D transform = view.layer.transform;
            CGFloat originalRotation = atan2(transform.m23, transform.m22);
            rotationAnimation.fromValue = @(originalRotation);
            rotationAnimation.toValue = @(originalRotation+JHDegreesToRadians(angle));
            [weakSelf addAnimationFromCalculationBlock:rotationAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CATransform3D transform = view.layer.transform;
            CGFloat originalRotation = atan2(transform.m23, transform.m22);
            CATransform3D xRotation = CATransform3DMakeRotation(JHDegreesToRadians(angle)+originalRotation, 1.0, 0, 0);
            view.layer.transform = xRotation;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableDegrees)rotateY
{
    JHChainableDegrees chainable = JHChainableDegrees(angle) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *rotationAnimation = [weakSelf basicAnimationForKeyPath:@"transform.rotation.y"];
            CATransform3D transform = view.layer.transform;
            CGFloat originalRotation = atan2(transform.m31, transform.m33);
            rotationAnimation.fromValue = @(originalRotation);
            rotationAnimation.toValue = @(originalRotation+JHDegreesToRadians(angle));
            [weakSelf addAnimationFromCalculationBlock:rotationAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CATransform3D transform = view.layer.transform;
            CGFloat originalRotation = atan2(transform.m31, transform.m33);
            CATransform3D yRotation = CATransform3DMakeRotation(JHDegreesToRadians(angle)+originalRotation, 0, 1.0, 0);
            view.layer.transform = yRotation;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainableDegrees)rotateZ
{
    JHChainableDegrees chainable = JHChainableDegrees(angle) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *rotationAnimation = [weakSelf basicAnimationForKeyPath:@"transform.rotation.z"];
            CATransform3D transform = view.layer.transform;
            CGFloat originalRotation = atan2(transform.m12, transform.m11);
            rotationAnimation.fromValue = @(originalRotation);
            rotationAnimation.toValue = @(originalRotation+JHDegreesToRadians(angle));
            [weakSelf addAnimationFromCalculationBlock:rotationAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CATransform3D transform = view.layer.transform;
            CGFloat originalRotation = atan2(transform.m12, transform.m11);
            CATransform3D zRotation = CATransform3DMakeRotation(JHDegreesToRadians(angle)+originalRotation, 0, 0, 1.0);
            view.layer.transform = zRotation;
        }];
        
        return self;
    };
    return chainable;
}


- (JHChainablePolarCoordinate)movePolar
{
    JHChainablePolarCoordinate chainable = JHChainablePolarCoordinate(radius, angle) {
        CGFloat x = radius*cosf(JHDegreesToRadians(angle));
        CGFloat y = -radius*sinf(JHDegreesToRadians(angle));
        return self.moveXY(x, y);
    };
    return chainable;
}

// Transforms

- (JHChainableAnimator *)transformIdentity
{
    [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
        JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
        CATransform3D transform = CATransform3DIdentity;
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:view.layer.transform];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
        [weakSelf addAnimationFromCalculationBlock:transformAnimation];
    }];
    [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
        CATransform3D transform = CATransform3DIdentity;
        view.layer.transform = transform;
    }];
    return self;
}


- (JHChainableFloat)transformX
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DTranslate(transform, f, 0, 0);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:view.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DTranslate(transform, f, 0, 0);
            view.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}


- (JHChainableFloat)transformY
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DTranslate(transform, 0, f, 0);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:view.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DTranslate(transform, 0, f, 0);
            view.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}


- (JHChainableFloat)transformZ
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DTranslate(transform, 0, 0, f);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:view.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DTranslate(transform, 0, 0, f);
            view.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}


- (JHChainablePoint)transformXY
{
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DTranslate(transform, x, y, 0);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:view.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DTranslate(transform, x, y, 0);
            view.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}


- (JHChainableFloat)transformScale
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DScale(transform, f, f, 1);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:view.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DScale(transform, f, f, 1);
            view.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}


- (JHChainableFloat)transformScaleX
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DScale(transform, f, 1, 1);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:view.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DScale(transform, f, 1, 1);
            view.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}


- (JHChainableFloat)transformScaleY
{
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DScale(transform, 1, f, 1);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:view.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CATransform3D transform = view.layer.transform;
            transform = CATransform3DScale(transform, 1, f, 1);
            view.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}


- (JHChainableBlock)block
{
    JHChainableBlock chainable = JHChainableBlock(block) {
        [self addAnimationCalculationAction:^(UIView *__weak view, JHChainableAnimator *__weak weakSelf) {
            if (block != nil) {
                block();
            }
        }];
        return self;
    };
    return chainable;
}


- (JHChainableBlock)preAnimationBlock
{
    JHChainableBlock chainable = JHChainableBlock(block) {
        [self.currentAnimationLink addPreAnimationBlock:block];
        return self;
    };
    return chainable;
}


- (JHChainableBlock)postAnimationBlock
{
    JHChainableBlock chainable = JHChainableBlock(block) {
        [self addAnimationCompletionAction:^(UIView *__weak view, JHChainableAnimator *__weak weakSelf) {
            if (block != nil) {
                block();
            }
        }];
        return self;
    };
    return chainable;
}


- (JHChainableBezierPath)moveOnPath
{
    JHChainableBezierPath chainable = JHChainableBezierPath(path) {
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *pathAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            pathAnimation.path = path.CGPath;
            [weakSelf addAnimationFromCalculationBlock:pathAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGPoint endPoint = path.currentPoint;
            view.layer.position = endPoint;
        }];
        return self;
    };
    return chainable;
}


- (JHChainableBezierPath)moveAndRotateOnPath
{
    JHChainableBezierPath chainable = JHChainableBezierPath(path) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *pathAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            pathAnimation.path = path.CGPath;
            pathAnimation.rotationMode = kCAAnimationRotateAuto;
            [weakSelf addAnimationFromCalculationBlock:pathAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGPoint endPoint = path.currentPoint;
            view.layer.position = endPoint;
        }];
        return self;
    };
    return chainable;
}


- (JHChainableBezierPath)moveAndReverseRotateOnPath
{
    JHChainableBezierPath chainable = JHChainableBezierPath(path) {
        
        [self addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            JHKeyframeAnimation *pathAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            pathAnimation.path = path.CGPath;
            pathAnimation.rotationMode = kCAAnimationRotateAutoReverse;
            [weakSelf addAnimationFromCalculationBlock:pathAnimation];
        }];
        [self addAnimationCompletionAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
            CGPoint endPoint = path.currentPoint;
            view.layer.position = endPoint;
        }];
        return self;
    };
    return chainable;
}


- (JHChainableAnimator *)anchorDefault
{
    return self.anchorCenter;
}


- (JHChainableAnimator *)anchorCenter
{
    [self makeAnchorFromX:0.5 Y:0.5];
    return self;
}


- (JHChainableAnimator *)anchorTopLeft
{
    [self makeAnchorFromX:0.0 Y:0.0];
    return self;
}


- (JHChainableAnimator *)anchorTopRight
{
    [self makeAnchorFromX:1.0 Y:0.0];
    return self;
}


- (JHChainableAnimator *)anchorBottomLeft
{
    
    [self makeAnchorFromX:0.0 Y:1.0];
    
    return self;
}


- (JHChainableAnimator *)anchorBottomRight
{
    [self makeAnchorFromX:1.0 Y:1.0];
    return self;
}


- (JHChainableAnimator *)anchorTop
{
    [self makeAnchorFromX:0.5 Y:0.0];
    return self;
}


- (JHChainableAnimator *)anchorBottom
{
    [self makeAnchorFromX:0.5 Y:1.0];
    return self;
}


- (JHChainableAnimator *)anchorLeft
{
    [self makeAnchorFromX:0.0 Y:0.5];
    return self;
}


- (JHChainableAnimator *)anchorRight
{
    [self makeAnchorFromX:1.0 Y:0.5];
    return self;
}


#pragma mark - Animations
- (void)addAnimationKeyframeCalculation:(JHKeyframeAnimationCalculationBlock)functionBlock
{
    [self.currentAnimationLink addAnimationCalculationAction:^(__weak UIView *view, __weak JHChainableAnimator *weakSelf) {
        [weakSelf.animationChainLinks.firstObject addAnimationKeyframeCalculation:functionBlock];
    }];
}


- (JHChainableAnimator *)easeIn
{
    return self.easeInQuad;
}


- (JHChainableAnimator *)easeOut
{
    return self.easeOutQuad;
}


- (JHChainableAnimator *)easeInOut
{
    return self.easeInOutQuad;
}


- (JHChainableAnimator *)easeBack
{
    return self.easeOutBack;
}


- (JHChainableAnimator *)spring
{
    return self.easeOutElastic;
}


- (JHChainableAnimator *)bounce
{
    return self.easeOutBounce;
}


- (JHChainableAnimator *)easeInQuad
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInQuad(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeOutQuad
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseOutQuad(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInOutQuad
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInOutQuad(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInCubic
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInCubic(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeOutCubic
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseOutCubic(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInOutCubic
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInOutCubic(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInQuart
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInQuart(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeOutQuart
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseOutQuart(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInOutQuart
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInOutQuart(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInQuint
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInQuint(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeOutQuint
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseOutQuint(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInOutQuint
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInOutQuint(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInSine
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInSine(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeOutSine
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseOutSine(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInOutSine
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInOutSine(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInExpo
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInExpo(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeOutExpo
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseOutExpo(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInOutExpo
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInOutExpo(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInCirc
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInCirc(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeOutCirc
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseOutCirc(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInOutCirc
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInOutCirc(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInElastic
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInElastic(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeOutElastic
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseOutElastic(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInOutElastic
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInOutElastic(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInBack
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInBack(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeOutBack
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseOutBack(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInOutBack
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInOutBack(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInBounce
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInBounce(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeOutBounce
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseOutBounce(t, b, c, d);
    }];
    return self;
}


- (JHChainableAnimator *)easeInOutBounce
{
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return JHKeyframeAnimationFunctionEaseInOutBounce(t, b, c, d);
    }];
    return self;
}


- (JHChainableCustomKeyframeAnimationCalculation)customAnimationFunction
{
    JHChainableCustomKeyframeAnimationCalculation chainable = JHChainableCustomKeyframeAnimationCalculation(block) {
        [self addAnimationKeyframeCalculation:block];
        return self;
    };
    return chainable;
}


- (JHChainableTimeInterval)delay
{
    JHChainableTimeInterval chainable = JHChainableTimeInterval(t) {
        
        self.currentAnimationLink.animationDelay = t;
        
        return self;
    };
    return chainable;
}


- (JHChainableTimeInterval)wait
{
    JHChainableTimeInterval chainable = JHChainableTimeInterval(t) {
        
        return self.delay(t);
    };
    return chainable;
}
@end
