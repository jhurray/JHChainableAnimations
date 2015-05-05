//
//  UIView+UIView_JHAnimationKit.m
//  JHAnimationKitExample
//
//  Created by Jeff Hurray on 4/29/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

#import <objc/runtime.h>
#import "JNWSpringAnimation/JNWSpringAnimation.h"
#import "UIView+UIView_JHAnimationKit.h"

/** Degrees to Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

@interface UIView (UIView_JHAnimationKit_Private)

typedef void (^JHAnimationCalculationAction)(UIView *weakSelf);
typedef void (^JHAnimationCompletionAction)(UIView *weakSelf);

// Arrays of animations to be grouped
@property (strong, nonatomic) NSMutableArray *animations;

// Grouped animations
@property (strong, nonatomic) NSMutableArray *animationGroups;

// Code run at the beginning of an animation link to calculate values
@property (strong, nonatomic) NSMutableArray *animationCalculationActions;

// Code run after animation is completed
@property (strong, nonatomic) NSMutableArray *animationCompletionActions;

// Methods
-(void) setup;
-(void) clear;
-(CAAnimationGroup *) basicAnimationGroup;
-(CABasicAnimation *) basicAnimationForKeyPath:(NSString *) keypath;
-(void) addAnimation:(CABasicAnimation *) animation;
-(void) addAnimationFromCalculationBlock:(CABasicAnimation *) animation;
-(CGPoint) newPositionFromNewFrame:(CGRect)newRect;
-(CGPoint) newPositionFromNewOrigin:(CGPoint)newOrigin;
-(CGPoint) newPositionFromNewCenter:(CGPoint)newCenter;
-(void) addAnimationCalculationAction:(JHAnimationCalculationAction)action;
-(void) addAnimationCompletionAction:(JHAnimationCompletionAction)action;

// Swizzled initializers
-(instancetype)swizzled_init;
-(instancetype)swizzled_initWithFrame:(CGRect)frame;
-(instancetype)swizzled_initWithCoder:(NSCoder *)aDecoder;

@end


@implementation UIView (UIView_JHAnimationKit_Private)

// Setters and getters

-(void) setAnimations:(NSMutableArray *)animations {
    objc_setAssociatedObject(self, @selector(animations), animations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) setAnimationGroups:(NSMutableArray *)animationGroups {
    objc_setAssociatedObject(self, @selector(animationGroups), animationGroups, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) setAnimationCalculationActions:(NSMutableArray *)animationCalculationActions {
    objc_setAssociatedObject(self, @selector(animationCalculationActions), animationCalculationActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) setAnimationCompletionActions:(NSMutableArray *)animationCompletionActions {
    objc_setAssociatedObject(self, @selector(animationCompletionActions), animationCompletionActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) setAnimationCompletion:(JHAnimationCompletion)animationCompletion {
    objc_setAssociatedObject(self, @selector(animationCompletion), animationCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSMutableArray *) animations {
    return objc_getAssociatedObject(self, @selector(animations));
}

-(NSMutableArray *) animationGroups {
    return objc_getAssociatedObject(self, @selector(animationGroups));
}

-(NSMutableArray *) animationCalculationActions {
    return objc_getAssociatedObject(self, @selector(animationCalculationActions));
}

-(NSMutableArray *) animationCompletionActions {
    return objc_getAssociatedObject(self, @selector(animationCompletionActions));
}

-(JHAnimationCompletion) animationCompletion {
    return objc_getAssociatedObject(self, @selector(animationCompletion));
}

+ (void)load
{
    // The "+ load" method is called once, very early in the application life-cycle.
    // It's called even before the "main" function is called. Beware: there's no
    // autorelease pool at this point, so avoid Objective-C calls.
    Method original, swizzle;
    
    // Get the "- (instancetype)init" method.
    original = class_getInstanceMethod(self, @selector(init));
    // Get the "- (instancetype)swizzled_init" method.
    swizzle = class_getInstanceMethod(self, @selector(swizzled_init));
    // Swap their implementations.
    method_exchangeImplementations(original, swizzle);
    // Frame
    original = class_getInstanceMethod(self, @selector(initWithFrame:));
    swizzle = class_getInstanceMethod(self, @selector(swizzled_initWithFrame:));
    method_exchangeImplementations(original, swizzle);
    // Coder
    original = class_getInstanceMethod(self, @selector(initWithCoder:));
    swizzle = class_getInstanceMethod(self, @selector(swizzled_initWithCoder:));
    method_exchangeImplementations(original, swizzle);
}

-(instancetype)swizzled_init {
    UIView * result = [self swizzled_init];
    if (result && [result respondsToSelector:@selector(setup)]) {
        [self setup];
    }
    return result;
}

-(instancetype)swizzled_initWithFrame:(CGRect)frame {
    UIView * result = [self swizzled_initWithFrame:frame];
    if (result && [result respondsToSelector:@selector(setup)]) {
        [self setup];
    }
    return result;
}

-(instancetype)swizzled_initWithCoder:(NSCoder *)aDecoder {
    UIView * result = [self swizzled_initWithCoder:aDecoder];
    if (result && [result respondsToSelector:@selector(setup)]) {
        [self setup];
    }
    return result;
}

-(void) setup {
    self.animations = [NSMutableArray arrayWithObject:[NSMutableArray array]];
    self.animationGroups = [NSMutableArray arrayWithObject:[self basicAnimationGroup]];
    self.animationCompletionActions = [NSMutableArray arrayWithObject:[NSMutableArray array]];
    self.animationCalculationActions = [NSMutableArray arrayWithObject:[NSMutableArray array]];
}

-(void) clear {
    [self.animations removeAllObjects];
    [self.animationGroups removeAllObjects];
    [self.animationCompletionActions removeAllObjects];
    [self.animationCalculationActions removeAllObjects];
    [self.animations addObject:[NSMutableArray array]];
    [self.animationCompletionActions addObject:[NSMutableArray array]];
    [self.animationCalculationActions addObject:[NSMutableArray array]];
    [self.animationGroups addObject:[self basicAnimationGroup]];
}

-(CAAnimationGroup *) basicAnimationGroup {
    CAAnimationGroup *group = [CAAnimationGroup animation];
    return group;
}

-(CABasicAnimation *) basicAnimationForKeyPath:(NSString *) keypath {
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:keypath];
    animation.repeatCount = 0;
    animation.autoreverses = NO;
    return animation;
}

-(void) addAnimationFromCalculationBlock:(CABasicAnimation *) animation {
    NSMutableArray *animationCluster = [self.animations firstObject];
    [animationCluster addObject:animation];
}

-(void) addAnimation:(CABasicAnimation *) animation {
    NSMutableArray *animationCluster = [self.animations lastObject];
    [animationCluster addObject:animation];
}

-(void) addAnimationCalculationAction:(JHAnimationCalculationAction)action {
    NSMutableArray *actions = [self.animationCalculationActions lastObject];
    [actions addObject:action];
}

-(void) addAnimationCompletionAction:(JHAnimationCompletionAction)action {
    NSMutableArray *actions = [self.animationCompletionActions lastObject];
    [actions addObject:action];
}

-(CGPoint) newPositionFromNewFrame:(CGRect)newRect {
    CGPoint anchor = self.layer.anchorPoint;
    CGSize size = newRect.size;
    CGPoint newPosition;
    newPosition.x = newRect.origin.x + anchor.x*size.width;
    newPosition.y = newRect.origin.y + anchor.y*size.height;
    return newPosition;
}

-(CGPoint) newPositionFromNewOrigin:(CGPoint) newOrigin {
    CGPoint anchor = self.layer.anchorPoint;
    CGSize size = self.bounds.size;
    CGPoint newPosition;
    newPosition.x = newOrigin.x + anchor.x*size.width;
    newPosition.y = newOrigin.y + anchor.y*size.height;
    return newPosition;
}

-(CGPoint) newPositionFromNewCenter:(CGPoint)newCenter {
    CGPoint anchor = self.layer.anchorPoint;
    CGSize size = self.bounds.size;
    CGPoint newPosition;
    newPosition.x = newCenter.x + (anchor.x-0.5)*size.width;
    newPosition.y = newCenter.y + (anchor.y-0.5)*size.height;
    return newPosition;
}

@end


@implementation UIView (UIView_JHAnimationKit)

@dynamic animationCompletion;

#pragma mark - Chainable Properties

-(JHChainableRect)makeFrame {
    JHChainableRect chainable = JHChainableRect(rect){
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            CGPoint newPosition = [weakSelf newPositionFromNewFrame:rect];
            positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
            [weakSelf addAnimation:positionAnimation];
            CABasicAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.layer.frame = rect;
            weakSelf.frame = rect;
            
        }];
        
        return self;
    };
    
    return chainable;
}

-(JHChainableRect)makeBounds {
    JHChainableRect chainable = JHChainableRect(rect) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.layer.bounds = rect;
            weakSelf.bounds = rect;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainablePoint)makeOrigin {
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(x, y)];
            positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect rect = weakSelf.frame;
            rect.origin.x = x; rect.origin.y = y;
            weakSelf.layer.frame = rect;
            weakSelf.frame = rect;
        }];
        
        return self;
    };
    return chainable;
}


-(JHChainablePoint)makeCenter {
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            CGPoint newPosition = [weakSelf newPositionFromNewCenter:CGPointMake(x, y)];
            positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.center = CGPointMake(x, y);
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeX {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position.x"];
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(f, 0)];
            positionAnimation.toValue = @(newPosition.x);
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect rect = weakSelf.frame;
            rect.origin.x = f;
            weakSelf.layer.frame = rect;
            weakSelf.frame = rect;
        }];
    
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeY {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position.y"];
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(0, f)];
            positionAnimation.toValue = @(newPosition.y);
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect rect = weakSelf.frame;
            rect.origin.y = f;
            weakSelf.layer.frame = rect;
            weakSelf.frame = rect;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeWidth {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, f, weakSelf.bounds.size.height);
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.layer.bounds = CGRectMake(0, 0, f, weakSelf.bounds.size.height);
            weakSelf.bounds = CGRectMake(0, 0, f, weakSelf.bounds.size.height);
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeHeight {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, weakSelf.bounds.size.width, f);
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.layer.bounds = CGRectMake(0, 0, weakSelf.bounds.size.width, f);
            weakSelf.bounds = CGRectMake(0, 0, weakSelf.bounds.size.width, f);
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeOpacity {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        CABasicAnimation *opacityAnimation = [self basicAnimationForKeyPath:@"opacity"];
        opacityAnimation.toValue = @(f);
        [self addAnimation:opacityAnimation];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.alpha = f;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableColor)makeBackground {
    JHChainableColor chainable = JHChainableColor(color) {
        
        CABasicAnimation *colorAnimation = [self basicAnimationForKeyPath:@"backgroundColor"];
        colorAnimation.toValue = (id)color.CGColor;
        [self addAnimation:colorAnimation];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.layer.backgroundColor = color.CGColor;
            weakSelf.backgroundColor = color;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableColor)makeBorderColor {
    JHChainableColor chainable = JHChainableColor(color) {
        
        CABasicAnimation *colorAnimation = [self basicAnimationForKeyPath:@"borderColor"];
        colorAnimation.toValue = (id)color.CGColor;
        [self addAnimation:colorAnimation];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.layer.borderColor = color.CGColor;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeBorderWidth {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        f = MAX(0, f);
        CABasicAnimation *borderAnimation = [self basicAnimationForKeyPath:@"borderWidth"];
        borderAnimation.toValue = @(f);
        [self addAnimation:borderAnimation];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.layer.borderWidth = f;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeCornerRadius {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        f = MAX(0, f);
        CABasicAnimation *cornerAnimation = [self basicAnimationForKeyPath:@"cornerRadius"];
        cornerAnimation.toValue = @(f);
        [self addAnimation:cornerAnimation];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.layer.cornerRadius = f;
        }];
        
        return self;
    };
    return chainable;
}

- (JHChainableFloat) makeScale {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, MAX(weakSelf.bounds.size.width*f, 0), MAX(weakSelf.bounds.size.height*f, 0));
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect rect = CGRectMake(0, 0, MAX(weakSelf.bounds.size.width*f, 0), MAX(weakSelf.bounds.size.height*f, 0));
            weakSelf.layer.bounds = rect;
            weakSelf.bounds = rect;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat) makeScaleX {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, MAX(weakSelf.bounds.size.width*f, 0), weakSelf.bounds.size.height);
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect rect = CGRectMake(0, 0, MAX(weakSelf.bounds.size.width*f, 0), weakSelf.bounds.size.height);
            weakSelf.layer.bounds = rect;
            weakSelf.bounds = rect;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat) makeScaleY {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, weakSelf.bounds.size.width, MAX(weakSelf.bounds.size.height*f, 0));
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect rect = CGRectMake(0, 0, weakSelf.bounds.size.width, MAX(weakSelf.bounds.size.height*f, 0));
            weakSelf.layer.bounds = rect;
            weakSelf.bounds = rect;
        }];
        
        return self;
    };
    return chainable;
}

-(void) makeAnchorFromX:(CGFloat) x Y:(CGFloat)y {
    JHAnimationCompletionAction action = ^void(UIView *weakSelf){
        CGPoint anchorPoint = CGPointMake(x, y);
        if (CGPointEqualToPoint(anchorPoint, weakSelf.layer.anchorPoint)) {
            return;
        }
        CGPoint newPoint = CGPointMake(weakSelf.bounds.size.width * anchorPoint.x,
                                       weakSelf.bounds.size.height * anchorPoint.y);
        CGPoint oldPoint = CGPointMake(weakSelf.bounds.size.width * weakSelf.layer.anchorPoint.x,
                                       weakSelf.bounds.size.height * weakSelf.layer.anchorPoint.y);
        
        newPoint = CGPointApplyAffineTransform(newPoint, weakSelf.transform);
        oldPoint = CGPointApplyAffineTransform(oldPoint, weakSelf.transform);
        
        CGPoint position = weakSelf.layer.position;
        
        position.x -= oldPoint.x;
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        weakSelf.layer.position = position;
        weakSelf.layer.anchorPoint = anchorPoint;
    };
    NSUInteger chainCount = self.animationCompletionActions.count;
    if (chainCount == 1) {
        __weak UIView *weakself = self;
        action(weakself);
    }
    else {
        NSMutableArray *lastActions = [self.animationCompletionActions objectAtIndex:chainCount-2];
        [lastActions addObject:action];
    }
}

- (JHChainablePoint) makeAnchor {
    JHChainablePoint chainable = JHChainablePoint(x, y) {

        [self makeAnchorFromX:x Y:y];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)moveX {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        CABasicAnimation *translationAnimation = [self basicAnimationForKeyPath:@"transform.translation.x"];
        translationAnimation.byValue = @(f);
        [self addAnimation:translationAnimation];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGPoint position = weakSelf.layer.position;
            position.x += f;
            weakSelf.layer.position = position;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)moveY {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        CABasicAnimation *translationAnimation = [self basicAnimationForKeyPath:@"transform.translation.y"];
        translationAnimation.byValue = @(f);
        [self addAnimation:translationAnimation];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGPoint position = weakSelf.layer.position;
            position.y += f;
            weakSelf.layer.position = position;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainablePoint)moveXY {
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        
        CABasicAnimation *translationAnimation1 = [self basicAnimationForKeyPath:@"transform.translation.x"];
        translationAnimation1.byValue = @(x);
        [self addAnimation:translationAnimation1];
        
        CABasicAnimation *translationAnimation2 = [self basicAnimationForKeyPath:@"transform.translation.y"];
        translationAnimation2.byValue = @(y);
        [self addAnimation:translationAnimation2];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGPoint position = weakSelf.layer.position;
            position.x += x; position.y += y;
            weakSelf.layer.position = position;
        }];
        
        return self;
    };
    return chainable;
}

- (JHChainableFloat) moveHeight {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, weakSelf.bounds.size.width, MAX(weakSelf.bounds.size.height+f, 0));
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect rect = CGRectMake(0, 0, weakSelf.bounds.size.width, MAX(weakSelf.bounds.size.height+f, 0));
            weakSelf.layer.bounds = rect;
            weakSelf.bounds = rect;
        }];
        
        return self;
    };
    return chainable;
}

- (JHChainableFloat) moveWidth {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            CABasicAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, MAX(weakSelf.bounds.size.width+f, 0), weakSelf.bounds.size.height);
            boundsAnimation.toValue = [NSValue valueWithCGRect:rect];
            [weakSelf addAnimationFromCalculationBlock:boundsAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect rect = CGRectMake(0, 0, MAX(weakSelf.bounds.size.width+f, 0), weakSelf.bounds.size.height);
            weakSelf.layer.bounds = rect;
            weakSelf.bounds = rect;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableDegrees)rotate {
    JHChainableDegrees chainable = JHChainableDegrees(angle) {
        
        CABasicAnimation *rotationAnimation = [self basicAnimationForKeyPath:@"transform.rotation.z"];
        rotationAnimation.byValue = @(degreesToRadians(angle));
        [self addAnimation:rotationAnimation];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CATransform3D transform = weakSelf.layer.transform;
            CGFloat originalRotation = atan2(transform.m12, transform.m11);
            CATransform3D zRotation = CATransform3DMakeRotation(degreesToRadians(angle)+originalRotation, 0, 0, 1.0);
            weakSelf.layer.transform = zRotation;
        }];
        
        return self;
    };
    return chainable;
}

- (UIView *) anchorDefault {
    return self.anchorCenter;
}

- (UIView *) anchorCenter {
    
    [self makeAnchorFromX:0.5 Y:0.5];
    
    return self;
}

- (UIView *) anchorTopLeft {
    
    [self makeAnchorFromX:0.0 Y:0.0];
    
    return self;
}

- (UIView *) anchorTopRight {
    
    [self makeAnchorFromX:1.0 Y:0.0];
    
    return self;
}

- (UIView *) anchorBottomLeft {
    
    [self makeAnchorFromX:0.0 Y:1.0];
    
    return self;
}

- (UIView *) anchorBottomRight {
    
    [self makeAnchorFromX:1.0 Y:1.0];
    
    return self;
}

- (UIView *) anchorTop {
    
    [self makeAnchorFromX:0.5 Y:0.0];
    
    return self;
}

- (UIView *) anchorBottom {
    
    [self makeAnchorFromX:0.5 Y:1.0];
    
    return self;
}

- (UIView *) anchorLeft {
    
    [self makeAnchorFromX:1.0 Y:0.5];
    
    return self;
}

- (UIView *) anchorRight {
    
    [self makeAnchorFromX:0.0 Y:0.5];
    
    return self;
}

#pragma mark - Semantics (Easier to read)

- (UIView *) seconds {
    return self;
}

#pragma mark - Multiple Animation Chaining

-(JHChainableTimeInterval)thenAfter {
    
    JHChainableTimeInterval chainable = JHChainableTimeInterval(t) {
      
        CAAnimationGroup *group = [self.animationGroups lastObject];
        group.duration = t;
        CAAnimationGroup *newGroup = [self basicAnimationGroup];
        [self.animationGroups addObject:newGroup];
        [self.animations addObject:[NSMutableArray array]];
        [self.animationCompletionActions addObject:[NSMutableArray array]];
        [self.animationCalculationActions addObject:[NSMutableArray array]];
        
        return self;
    };
    
    return chainable;
}

#pragma mark - Animations

-(UIView *)easeIn {
    
    CAAnimationGroup *group = [self.animationGroups lastObject];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return self;
}

-(UIView *)easeOut {
    
    CAAnimationGroup *group = [self.animationGroups lastObject];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return self;
}

-(UIView *)easeInOut {
    
    CAAnimationGroup *group = [self.animationGroups lastObject];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return self;
}

-(JHChainableTimeInterval)delay {
    JHChainableTimeInterval chainable = JHChainableTimeInterval(t) {
      
        CAAnimationGroup *group = [self.animationGroups lastObject];
        group.beginTime = CACurrentMediaTime() + t;
        
        return self;
    };
    return chainable;
}

-(JHChainableTimeInterval)wait {
    JHChainableTimeInterval chainable = JHChainableTimeInterval(t) {
        
        CAAnimationGroup *group = [self.animationGroups lastObject];
        group.beginTime = CACurrentMediaTime() + t;
        
        return self;
    };
    return chainable;
}

-(void) animateChain {
    [self sanityCheck];
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self chainLinkDidFinishAnimating];
    }];
    
    [self animateChainLink];
    
    [CATransaction commit];
}

-(void) chainLinkDidFinishAnimating {
    NSMutableArray *actionCluster = [self.animationCompletionActions firstObject];
    for (JHAnimationCompletionAction action in actionCluster) {
        __weak UIView *weakSelf = self;
        action(weakSelf);
    }
    [self.animationCompletionActions removeObjectAtIndex:0];
    [self.animationCalculationActions removeObjectAtIndex:0];
    [self.animations removeObjectAtIndex:0];
    [self.animationGroups removeObjectAtIndex:0];
    [self sanityCheck];
    if (self.animationGroups.count == 0) {
        if (self.animationCompletion) {
            self.animationCompletion();
        }
        [self clear];
    }
    else {
        [self animateChain];
    }
}

-(void) animateChainLink {
    NSMutableArray *actionCluster = [self.animationCalculationActions firstObject];
    for (JHAnimationCalculationAction action in actionCluster) {
        __weak UIView *weakSelf = self;
        action(weakSelf);
    }
    CAAnimationGroup *group = [self.animationGroups firstObject];
    NSMutableArray *animationCluster = [self.animations firstObject];
    group.animations = animationCluster;
    [self.layer addAnimation:group forKey:@"AnimationChain"];
}

-(JHChainableAnimation)animate {
    JHChainableAnimation chainable = JHChainableAnimation(duration) {
        
        CAAnimationGroup *group = [self.animationGroups lastObject];
        group.duration = duration;
        [self animateChain];
        
        return self;
    };
    return chainable;
}

-(JHChainableAnimationWithCompletion)animateWithCompletion {
    JHChainableAnimationWithCompletion chainable = JHChainableAnimationWithCompletion(duration, completion) {
        
        CAAnimationGroup *group = [self.animationGroups lastObject];
        group.duration = duration;
        self.animationCompletion = completion;
        [self animateChain];
        
        return self;
    };
    return chainable;
}

-(void) sanityCheck {
    NSAssert(self.animations.count == self.animationGroups.count, @"FATAL ERROR: ANIMATION GROUPS AND ANIMATIONS ARE OUT OF SYNC");
    NSAssert(self.animationCalculationActions.count == self.animationCompletionActions.count, @"FATAL ERROR: ANIMATION CALCULATION OBJECTS AND ANIMATION COMPLETION OBJECTS ARE OUT OF SYNC");
    NSAssert(self.animations.count == self.animationCompletionActions.count, @"FATAL ERROR: ANIMATIONS AND ANIMATION COMPLETION OBJECTS  ARE OUT OF SYNC");
}

@end
