//
//  JHChainableAnimator.h
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JHViewAnimatorProtocol.h"

@interface JHChainableAnimator : NSObject <JHViewAnimator>

@property (atomic, assign, getter=isAnimating, readonly) BOOL animating;
@property (nonatomic, copy) void(^completionBlock)();

- (instancetype)initWithView:(UIView *)view NS_DESIGNATED_INITIALIZER;
- (UIBezierPath *)bezierPathForAnimation;

@end
