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

/// If the animatoris paused, the view will still be animating. animating will only be false if the animation ends or is stopped
@property (atomic, assign, getter=isAnimating, readonly) BOOL animating;
@property (atomic, assign, getter=isPaused, readonly) BOOL paused;
@property (nonatomic, copy) void(^completionBlock)();

- (instancetype)initWithView:(UIView *)view NS_DESIGNATED_INITIALIZER;

/// Will pause animations but retain state. `isAnimating` will remain true.
- (void)pause;
/// Will resume animations if the animator is paused and animating
- (void)resume;
/// Will stop animations and clear state
- (void)stop;

@end
