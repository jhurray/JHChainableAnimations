//
//  UIView+UIView_JHAnimationKit.m
//  JHAnimationKitExample
//
//  Created by Jeff Hurray on 4/29/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+JHChainableAnimations.h"
#import "JHKeyframeAnimation.h"

/** Degrees to Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

@interface UIView (UIView_JHChainableAnimations_Private)

typedef void (^JHAnimationCalculationAction)(UIView *weakSelf);
typedef void (^JHAnimationCompletionAction)(UIView *weakSelf);

// Arrays of animations to be grouped
@property (strong, nonatomic) NSMutableArray *JHAnimations;

// Grouped animations
@property (strong, nonatomic) NSMutableArray *JHAnimationGroups;

// Code run at the beginning of an animation link to calculate values
@property (strong, nonatomic) NSMutableArray *JHAnimationCalculationActions;

// Code run after animation is completed
@property (strong, nonatomic) NSMutableArray *JHAnimationCompletionActions;

// Methods
-(void) clear;
-(CAAnimationGroup *) basicAnimationGroup;
-(JHKeyframeAnimation *) basicAnimationForKeyPath:(NSString *) keypath;
-(void) addAnimation:(JHKeyframeAnimation *) animation;
-(void) addAnimationFromCalculationBlock:(JHKeyframeAnimation *) animation;
-(CGPoint) newPositionFromNewFrame:(CGRect)newRect;
-(CGPoint) newPositionFromNewOrigin:(CGPoint)newOrigin;
-(CGPoint) newPositionFromNewCenter:(CGPoint)newCenter;
-(void) addAnimationCalculationAction:(JHAnimationCalculationAction)action;
-(void) addAnimationCompletionAction:(JHAnimationCompletionAction)action;


@end


@implementation UIView (UIView_JHChainableAnimations_Private)

// Setters and getters

-(void) setJHAnimations:(NSMutableArray *)animations {
    objc_setAssociatedObject(self, @selector(JHAnimations), animations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) setJHAnimationGroups:(NSMutableArray *)animationGroups {
    objc_setAssociatedObject(self, @selector(JHAnimationGroups), animationGroups, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) setJHAnimationCalculationActions:(NSMutableArray *)animationCalculationActions {
    objc_setAssociatedObject(self, @selector(JHAnimationCalculationActions), animationCalculationActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) setJHAnimationCompletionActions:(NSMutableArray *)animationCompletionActions {
    objc_setAssociatedObject(self, @selector(JHAnimationCompletionActions), animationCompletionActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) setAnimationCompletion:(JHAnimationCompletion)animationCompletion {
    objc_setAssociatedObject(self, @selector(animationCompletion), animationCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSMutableArray *) JHAnimations {
    NSMutableArray *animations = objc_getAssociatedObject(self, @selector(JHAnimations));
	if (animations == nil) {
		animations = [NSMutableArray arrayWithObject:[NSMutableArray array]];
		[self setJHAnimations:animations];
	}
	return animations;
}

-(NSMutableArray *) JHAnimationGroups {
    NSMutableArray *animationGroups = objc_getAssociatedObject(self, @selector(JHAnimationGroups));
	if (animationGroups == nil) {
		animationGroups = [NSMutableArray arrayWithObject:[self basicAnimationGroup]];
		[self setJHAnimationGroups:animationGroups];
	}
	return animationGroups;
}

-(NSMutableArray *) JHAnimationCalculationActions {
    NSMutableArray *animationCalculationActions = objc_getAssociatedObject(self, @selector(JHAnimationCalculationActions));
	if (animationCalculationActions == nil) {
		animationCalculationActions = [NSMutableArray arrayWithObject:[NSMutableArray array]];
		[self setJHAnimationCalculationActions:animationCalculationActions];
	}
	return animationCalculationActions;
}

-(NSMutableArray *) JHAnimationCompletionActions {
    NSMutableArray *animationCompletionActions = objc_getAssociatedObject(self, @selector(JHAnimationCompletionActions));
	if (animationCompletionActions == nil) {
		animationCompletionActions = [NSMutableArray arrayWithObject:[NSMutableArray array]];;
		[self setJHAnimationCompletionActions:animationCompletionActions];
	}
	return animationCompletionActions;
}

-(JHAnimationCompletion) animationCompletion {
    return objc_getAssociatedObject(self, @selector(animationCompletion));
}


-(void) clear {
    [self.JHAnimations removeAllObjects];
    [self.JHAnimationGroups removeAllObjects];
    [self.JHAnimationCompletionActions removeAllObjects];
    [self.JHAnimationCalculationActions removeAllObjects];
    [self.JHAnimations addObject:[NSMutableArray array]];
    [self.JHAnimationCompletionActions addObject:[NSMutableArray array]];
    [self.JHAnimationCalculationActions addObject:[NSMutableArray array]];
    [self.JHAnimationGroups addObject:[self basicAnimationGroup]];
}

-(CAAnimationGroup *) basicAnimationGroup {
    CAAnimationGroup *group = [CAAnimationGroup animation];
    return group;
}

-(JHKeyframeAnimation *) basicAnimationForKeyPath:(NSString *) keypath {
    JHKeyframeAnimation * animation = [JHKeyframeAnimation animationWithKeyPath:keypath];
    animation.repeatCount = 0;
    animation.autoreverses = NO;
    return animation;
}

-(void) addAnimationFromCalculationBlock:(JHKeyframeAnimation *) animation {
    NSMutableArray *animationCluster = [self.JHAnimations firstObject];
    [animationCluster addObject:animation];
}

-(void) addAnimation:(JHKeyframeAnimation *) animation {
    NSMutableArray *animationCluster = [self.JHAnimations lastObject];
    [animationCluster addObject:animation];
}

-(void) addAnimationCalculationAction:(JHAnimationCalculationAction)action {
    NSMutableArray *actions = [self.JHAnimationCalculationActions lastObject];
    [actions addObject:action];
}

-(void) addAnimationCompletionAction:(JHAnimationCompletionAction)action {
    NSMutableArray *actions = [self.JHAnimationCompletionActions lastObject];
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


@implementation UIView (UIView_JHChainableAnimations)

@dynamic animationCompletion;

#pragma mark - Chainable Properties

-(JHChainableRect)makeFrame {
    JHChainableRect chainable = JHChainableRect(rect){
        
        return self.makeOrigin(rect.origin.x, rect.origin.y).makeBounds(rect);
    };
    
    return chainable;
}

-(JHChainableRect)makeBounds {
    JHChainableRect chainable = JHChainableRect(rect) {
        
        return self.makeSize(rect.size.width, rect.size.height);
    };
    return chainable;
}

- (JHChainableSize) makeSize {
    JHChainableSize chainable = JHChainableSize(width, height){
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *sizeAnimation = [weakSelf basicAnimationForKeyPath:@"bounds.size"];
            sizeAnimation.fromValue = [NSValue valueWithCGSize:weakSelf.layer.bounds.size];
            sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(width, height)];
            [weakSelf addAnimationFromCalculationBlock:sizeAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect bounds = CGRectMake(0, 0, width, height);
            weakSelf.layer.bounds = bounds;
            weakSelf.bounds = bounds;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainablePoint)makeOrigin {
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(x, y)];
            positionAnimation.fromValue = [NSValue valueWithCGPoint:weakSelf.layer.position];
            positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(x, y)];
            weakSelf.layer.position = newPosition;
        }];
        
        return self;
    };
    return chainable;
}


-(JHChainablePoint)makeCenter {
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            CGPoint newPosition = [weakSelf newPositionFromNewCenter:CGPointMake(x, y)];
            positionAnimation.fromValue = [NSValue valueWithCGPoint:weakSelf.layer.position];
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
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position.x"];
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(f, weakSelf.layer.frame.origin.y)];
            positionAnimation.fromValue = @(weakSelf.layer.position.x);
            positionAnimation.toValue = @(newPosition.x);
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(f, weakSelf.layer.frame.origin.y)];
            weakSelf.layer.position = newPosition;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeY {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position.y"];
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(weakSelf.layer.frame.origin.x, f)];
            positionAnimation.fromValue = @(weakSelf.layer.position.y);
            positionAnimation.toValue = @(newPosition.y);
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(weakSelf.layer.frame.origin.x, f)];
            weakSelf.layer.position = newPosition;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeWidth {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *sizeAnimation = [weakSelf basicAnimationForKeyPath:@"bounds.size"];
            sizeAnimation.fromValue = [NSValue valueWithCGSize:weakSelf.layer.bounds.size];
            sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(f, weakSelf.frame.size.height)];
            [weakSelf addAnimationFromCalculationBlock:sizeAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect bounds = CGRectMake(0, 0, f, weakSelf.frame.size.height);
            weakSelf.layer.bounds = bounds;
            weakSelf.bounds = bounds;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeHeight {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *sizeAnimation = [weakSelf basicAnimationForKeyPath:@"bounds.size"];
            sizeAnimation.fromValue = [NSValue valueWithCGSize:weakSelf.layer.bounds.size];
            sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(weakSelf.frame.size.width, f)];
            [weakSelf addAnimationFromCalculationBlock:sizeAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect bounds = CGRectMake(0, 0, weakSelf.frame.size.width, f);
            weakSelf.layer.bounds = bounds;
            weakSelf.bounds = bounds;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeOpacity {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *opacityAnimation = [weakSelf basicAnimationForKeyPath:@"opacity"];
            opacityAnimation.fromValue = @(weakSelf.alpha);
            opacityAnimation.toValue = @(f);
            [weakSelf addAnimationFromCalculationBlock:opacityAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            weakSelf.alpha = f;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableColor)makeBackground {
    JHChainableColor chainable = JHChainableColor(color) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *colorAnimation = [weakSelf basicAnimationForKeyPath:@"backgroundColor"];
            colorAnimation.fromValue = weakSelf.backgroundColor;
            colorAnimation.toValue = color;
            [weakSelf addAnimationFromCalculationBlock:colorAnimation];
        }];
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
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *colorAnimation = [weakSelf basicAnimationForKeyPath:@"borderColor"];
            UIColor *borderColor = (__bridge UIColor*)(weakSelf.layer.borderColor);
            colorAnimation.fromValue = borderColor;
            colorAnimation.toValue = color;
            [weakSelf addAnimationFromCalculationBlock:colorAnimation];
        }];
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
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *borderAnimation = [weakSelf basicAnimationForKeyPath:@"borderWidth"];
            borderAnimation.fromValue = @(weakSelf.layer.borderWidth);
            borderAnimation.toValue = @(f);
            [weakSelf addAnimationFromCalculationBlock:borderAnimation];
        }];
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
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *cornerAnimation = [weakSelf basicAnimationForKeyPath:@"cornerRadius"];
            cornerAnimation.fromValue = @(weakSelf.layer.cornerRadius);
            cornerAnimation.toValue = @(f);
            [weakSelf addAnimationFromCalculationBlock:cornerAnimation];
        }];
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
            JHKeyframeAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, MAX(weakSelf.bounds.size.width*f, 0), MAX(weakSelf.bounds.size.height*f, 0));
            boundsAnimation.fromValue = [NSValue valueWithCGRect:weakSelf.layer.bounds];
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
            JHKeyframeAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, MAX(weakSelf.bounds.size.width*f, 0), weakSelf.bounds.size.height);
            boundsAnimation.fromValue = [NSValue valueWithCGRect:weakSelf.layer.bounds];
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
            JHKeyframeAnimation *boundsAnimation = [weakSelf basicAnimationForKeyPath:@"bounds"];
            CGRect rect = CGRectMake(0, 0, weakSelf.bounds.size.width, MAX(weakSelf.bounds.size.height*f, 0));
            boundsAnimation.fromValue = [NSValue valueWithCGRect:weakSelf.layer.bounds];
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
    JHAnimationCalculationAction action = ^void(UIView *weakSelf){
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
    NSMutableArray *lastCalculationActions = [self.JHAnimationCalculationActions lastObject];
    [lastCalculationActions insertObject:action atIndex:0];
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
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position.x"];
            positionAnimation.fromValue = @(weakSelf.layer.position.x);
            positionAnimation.toValue = @(weakSelf.layer.position.x+f);
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
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
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position.y"];
            positionAnimation.fromValue = @(weakSelf.layer.position.y);
            positionAnimation.toValue = @(weakSelf.layer.position.y+f);
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
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
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *positionAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            CGPoint oldOrigin = weakSelf.layer.frame.origin;
            CGPoint newPosition = [weakSelf newPositionFromNewOrigin:CGPointMake(oldOrigin.x+x, oldOrigin.y+y)];
            positionAnimation.fromValue = [NSValue valueWithCGPoint:weakSelf.layer.position];
            positionAnimation.toValue = [NSValue valueWithCGPoint:newPosition];
            [weakSelf addAnimationFromCalculationBlock:positionAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGPoint position = weakSelf.layer.position;
            position.x +=x; position.y += y;
            weakSelf.layer.position = position;
        }];
        
        return self;
    };
    return chainable;
}

- (JHChainableFloat) moveHeight {
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *sizeAnimation = [weakSelf basicAnimationForKeyPath:@"bounds.size"];
            sizeAnimation.fromValue = [NSValue valueWithCGSize:weakSelf.layer.bounds.size];
            sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(weakSelf.bounds.size.width, MAX(weakSelf.bounds.size.height+f, 0))];
            [weakSelf addAnimationFromCalculationBlock:sizeAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect bounds = CGRectMake(0, 0, weakSelf.bounds.size.width, MAX(weakSelf.bounds.size.height+f, 0));
            weakSelf.layer.bounds = bounds;
            weakSelf.bounds = bounds;
        }];
        
        return self;
    };
    return chainable;
}

- (JHChainableFloat) moveWidth {
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *sizeAnimation = [weakSelf basicAnimationForKeyPath:@"bounds.size"];
            sizeAnimation.fromValue = [NSValue valueWithCGSize:weakSelf.layer.bounds.size];
            sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(MAX(weakSelf.bounds.size.width+f, 0), weakSelf.bounds.size.height)];
            [weakSelf addAnimationFromCalculationBlock:sizeAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGRect bounds = CGRectMake(0, 0, MAX(weakSelf.bounds.size.width+f, 0), weakSelf.bounds.size.height);
            weakSelf.layer.bounds = bounds;
            weakSelf.bounds = bounds;
        }];
        
        return self;
    };
    return chainable;
}

-(JHChainableDegrees)rotate {
    JHChainableDegrees chainable = JHChainableDegrees(angle) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *rotationAnimation = [weakSelf basicAnimationForKeyPath:@"transform.rotation.z"];
            CATransform3D transform = weakSelf.layer.transform;
            CGFloat originalRotation = atan2(transform.m12, transform.m11);
            rotationAnimation.fromValue = @(originalRotation);
            rotationAnimation.toValue = @(originalRotation+degreesToRadians(angle));
            [weakSelf addAnimationFromCalculationBlock:rotationAnimation];
        }];
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

- (JHChainablePolarCoordinate) movePolar {
    JHChainablePolarCoordinate chainable = JHChainablePolarCoordinate(radius, angle) {
        CGFloat x = radius*cosf(degreesToRadians(angle));
        CGFloat y = -radius*sinf(degreesToRadians(angle));
        return self.moveXY(x, y);
    };
    return chainable;
}

// Transforms

- (UIView *) transformIdentity {
    [self addAnimationCalculationAction:^(UIView *weakSelf) {
        JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
        CATransform3D transform = CATransform3DIdentity;
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:weakSelf.layer.transform];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
        [weakSelf addAnimationFromCalculationBlock:transformAnimation];
    }];
    [self addAnimationCompletionAction:^(UIView *weakSelf) {
        CATransform3D transform = CATransform3DIdentity;
        weakSelf.layer.transform = transform;
    }];
    return self;
}

- (JHChainableFloat) transformX {
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DTranslate(transform, f, 0, 0);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:weakSelf.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DTranslate(transform, f, 0, 0);
            weakSelf.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}

- (JHChainableFloat) transformY {
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DTranslate(transform, 0, f, 0);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:weakSelf.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DTranslate(transform, 0, f, 0);
            weakSelf.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}

- (JHChainableFloat) transformZ {
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DTranslate(transform, 0, 0, f);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:weakSelf.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DTranslate(transform, 0, 0, f);
            weakSelf.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}

- (JHChainablePoint) transformXY {
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DTranslate(transform, x, y, 0);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:weakSelf.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DTranslate(transform, x, y, 0);
            weakSelf.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}

- (JHChainableFloat) transformScale {
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DScale(transform, f, f, 1);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:weakSelf.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DScale(transform, f, f, 1);
            weakSelf.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}

- (JHChainableFloat) transformScaleX {
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DScale(transform, f, 1, 1);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:weakSelf.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DScale(transform, f, 1, 1);
            weakSelf.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}

- (JHChainableFloat) transformScaleY {
    JHChainableFloat chainable = JHChainableFloat(f) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *transformAnimation = [weakSelf basicAnimationForKeyPath:@"transform"];
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DScale(transform, 1, f, 1);
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:weakSelf.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
            [weakSelf addAnimationFromCalculationBlock:transformAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CATransform3D transform = weakSelf.layer.transform;
            transform = CATransform3DScale(transform, 1, f, 1);
            weakSelf.layer.transform = transform;
        }];
        return self;
    };
    return chainable;
}

// AutoLayout
- (JHChainableLayoutConstraint) makeConstraint {
    JHChainableLayoutConstraint chainable = JHChainableLayoutConstraint(constraint, f) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            if ([weakSelf.constraints containsObject:constraint]) {
                constraint.constant = f;
                [weakSelf setNeedsUpdateConstraints];
            }
        }];
        return self;
    };
    return chainable;
}

- (JHChainableLayoutConstraint) moveConstraint {
    JHChainableLayoutConstraint chainable = JHChainableLayoutConstraint(constraint, f) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            if ([weakSelf.constraints containsObject:constraint]) {
                constraint.constant += f;
                [weakSelf setNeedsUpdateConstraints];
            }
        }];
        return self;
    };
    return chainable;
}

// Bezier Paths

- (UIBezierPath *) bezierPathForAnimation {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.layer.position];
    return path;
}

- (JHChainableBezierPath) moveOnPath {
    JHChainableBezierPath chainable = JHChainableBezierPath(path) {
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *pathAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            pathAnimation.path = path.CGPath;
            [weakSelf addAnimationFromCalculationBlock:pathAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGPoint endPoint = path.currentPoint;
            weakSelf.layer.position = endPoint;
        }];
        return self;
    };
    return chainable;
}

- (JHChainableBezierPath) moveAndRotateOnPath {
    JHChainableBezierPath chainable = JHChainableBezierPath(path) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *pathAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            pathAnimation.path = path.CGPath;
            pathAnimation.rotationMode = kCAAnimationRotateAuto;
            [weakSelf addAnimationFromCalculationBlock:pathAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGPoint endPoint = path.currentPoint;
            weakSelf.layer.position = endPoint;
        }];
        return self;
    };
    return chainable;
}

- (JHChainableBezierPath) moveAndReverseRotateOnPath {
    JHChainableBezierPath chainable = JHChainableBezierPath(path) {
        
        [self addAnimationCalculationAction:^(UIView *weakSelf) {
            JHKeyframeAnimation *pathAnimation = [weakSelf basicAnimationForKeyPath:@"position"];
            pathAnimation.path = path.CGPath;
            pathAnimation.rotationMode = kCAAnimationRotateAutoReverse;
            [weakSelf addAnimationFromCalculationBlock:pathAnimation];
        }];
        [self addAnimationCompletionAction:^(UIView *weakSelf) {
            CGPoint endPoint = path.currentPoint;
            weakSelf.layer.position = endPoint;
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
    
    [self makeAnchorFromX:0.0 Y:0.5];
    
    return self;
}

- (UIView *) anchorRight {
    
    [self makeAnchorFromX:1.0 Y:0.5];
    
    return self;
}

#pragma mark - Semantics (Easier to read)

- (UIView *) seconds {
    return self;
}

#pragma mark - Multiple Animation Chaining

-(JHChainableTimeInterval)thenAfter {
    
    JHChainableTimeInterval chainable = JHChainableTimeInterval(t) {
      
        CAAnimationGroup *group = [self.JHAnimationGroups lastObject];
        group.duration = t;
        CAAnimationGroup *newGroup = [self basicAnimationGroup];
        [self.JHAnimationGroups addObject:newGroup];
        [self.JHAnimations addObject:[NSMutableArray array]];
        [self.JHAnimationCompletionActions addObject:[NSMutableArray array]];
        [self.JHAnimationCalculationActions addObject:[NSMutableArray array]];
        
        return self;
    };
    
    return chainable;
}

#pragma mark - Animations

-(void) addAnimationKeyframeCalculation:(NSBKeyframeAnimationFunctionBlock) functionBlock {
    [self addAnimationCalculationAction:^(UIView *weakSelf) {
        NSMutableArray *animationCluster = [weakSelf.JHAnimations firstObject];
        JHKeyframeAnimation *animation = [animationCluster lastObject];
        animation.functionBlock = functionBlock;
    }];
}

- (UIView *) easeIn {
    return self.easeInQuad;
}

- (UIView *) easeOut {
    return self.easeOutQuad;
}

- (UIView *) easeInOut {
    return self.easeInOutQuad;
}

- (UIView *) easeBack {
    return self.easeOutBack;
}

- (UIView *) spring {
    return self.easeOutElastic;
}

- (UIView *) bounce {
    return self.easeOutBounce;
}

- (UIView *) easeInQuad {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInQuad(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeOutQuad {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutQuad(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInOutQuad {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutQuad(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInCubic {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInCubic(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeOutCubic {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutCubic(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInOutCubic {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutCubic(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInQuart {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInQuart(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeOutQuart {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutQuart(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInOutQuart {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutQuart(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInQuint {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInQuint(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeOutQuint {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutQuint(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInOutQuint {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutQuint(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInSine {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInSine(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeOutSine {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutSine(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInOutSine {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutSine(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInExpo {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInExpo(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeOutExpo {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutExpo(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInOutExpo {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutExpo(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInCirc {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInCirc(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeOutCirc {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutCirc(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInOutCirc {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutCirc(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInElastic {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInElastic(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeOutElastic {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutElastic(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInOutElastic {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutElastic(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInBack {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInBack(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeOutBack {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutBack(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInOutBack {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutBack(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInBounce {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInBounce(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeOutBounce {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseOutBounce(t, b, c, d);
    }];
    return self;
}

- (UIView *) easeInOutBounce {
    [self addAnimationKeyframeCalculation:^double(double t, double b, double c, double d) {
        return NSBKeyframeAnimationFunctionEaseInOutBounce(t, b, c, d);
    }];
    return self;
}

-(JHChainableTimeInterval)delay {
    JHChainableTimeInterval chainable = JHChainableTimeInterval(t) {
      
        for (CAAnimation *aGroup in self.JHAnimationGroups) {
            t+=aGroup.duration;
        }
        CAAnimationGroup *group = [self.JHAnimationGroups lastObject];
        group.beginTime = CACurrentMediaTime() + t;
        
        return self;
    };
    return chainable;
}

-(JHChainableTimeInterval)wait {
    JHChainableTimeInterval chainable = JHChainableTimeInterval(t) {
        
        return self.delay(t);
    };
    return chainable;
}

-(void) animateChain {
    [self sanityCheck];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        [self.layer removeAnimationForKey:@"AnimationChain"];
        [self chainLinkDidFinishAnimating];
    }];
    
    [self animateChainLink];
    
    [CATransaction commit];
    
    [self executeCompletionActions];
}

-(void) executeCompletionActions {
    CAAnimationGroup *group = [self.JHAnimationGroups firstObject];
    NSTimeInterval delay = MAX(group.beginTime - CACurrentMediaTime(), 0.0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *actionCluster = [self.JHAnimationCompletionActions firstObject];
        for (JHAnimationCompletionAction action in actionCluster) {
            __weak UIView *weakSelf = self;
            action(weakSelf);
        }
    });
}

-(void) chainLinkDidFinishAnimating {
    [self.JHAnimationCompletionActions removeObjectAtIndex:0];
    [self.JHAnimationCalculationActions removeObjectAtIndex:0];
    [self.JHAnimations removeObjectAtIndex:0];
    [self.JHAnimationGroups removeObjectAtIndex:0];
    [self sanityCheck];
    if (self.JHAnimationGroups.count == 0) {
        [self clear];
        if (self.animationCompletion) {
            JHAnimationCompletion completion = self.animationCompletion;
            self.animationCompletion = nil;
            completion();
        }
    }
    else {
        [self animateChain];
    }
}

-(void) animateChainLink {
    [self makeAnchorFromX:0.5 Y:0.5];
    NSMutableArray *actionCluster = [self.JHAnimationCalculationActions firstObject];
    for (JHAnimationCalculationAction action in actionCluster) {
        __weak UIView *weakSelf = self;
        action(weakSelf);
    }
    CAAnimationGroup *group = [self.JHAnimationGroups firstObject];
    NSMutableArray *animationCluster = [self.JHAnimations firstObject];
    for (JHKeyframeAnimation *animation in animationCluster) {
        animation.duration = group.duration;
        [animation calculate];
    }
    group.animations = animationCluster;
    [self.layer addAnimation:group forKey:@"AnimationChain"];
    
    // For constraints
    NSTimeInterval delay = MAX(group.beginTime - CACurrentMediaTime(), 0.0);
    [self.class animateWithDuration:group.duration
                              delay:delay
                            options:0
                         animations:^{
        [self updateConstraints];
    } completion:nil];
}

-(JHChainableAnimation)animate {
    JHChainableAnimation chainable = JHChainableAnimation(duration) {
        
        CAAnimationGroup *group = [self.JHAnimationGroups lastObject];
        group.duration = duration;
        [self animateChain];
        
        return self;
    };
    return chainable;
}

-(JHChainableAnimationWithCompletion)animateWithCompletion {
    JHChainableAnimationWithCompletion chainable = JHChainableAnimationWithCompletion(duration, completion) {
        
        CAAnimationGroup *group = [self.JHAnimationGroups lastObject];
        group.duration = duration;
        self.animationCompletion = completion;
        [self animateChain];
        
        return self;
    };
    return chainable;
}

-(void) sanityCheck {
    NSAssert(self.JHAnimations.count == self.JHAnimationGroups.count, @"FATAL ERROR: ANIMATION GROUPS AND ANIMATIONS ARE OUT OF SYNC");
    NSAssert(self.JHAnimationCalculationActions.count == self.JHAnimationCompletionActions.count, @"FATAL ERROR: ANIMATION CALCULATION OBJECTS AND ANIMATION COMPLETION OBJECTS ARE OUT OF SYNC");
    NSAssert(self.JHAnimations.count == self.JHAnimationCompletionActions.count, @"FATAL ERROR: ANIMATIONS AND ANIMATION COMPLETION OBJECTS  ARE OUT OF SYNC");
}

@end
