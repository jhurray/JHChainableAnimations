//
//  UIView+UIView_JHAnimationKit.m
//  JHAnimationKitExample
//
//  Created by Jeff Hurray on 4/29/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

#import "UIView+UIView_JHAnimationKit.h"

@implementation UIView (UIView_JHAnimationKit)

#pragma mark - Chainable Properties

-(JHChainableRect)makeFrame {
    JHChainableRect chainable = JHChainableRect(rect){
        
        //implement
        
        return self;
    };
    
    return chainable;
}

-(JHChainableRect)makeBounds {
    JHChainableRect chainable = JHChainableRect(rect) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainablePoint)makeOrigin {
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        
        //implement
        
        return self;
    };
    return chainable;
}


-(JHChainablePoint)makeCenter {
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeX {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
    
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeY {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeWidth {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeHeight {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)moveX {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)moveY {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainablePoint)moveXY {
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableDegrees)rotate {
    JHChainableDegrees chainable = JHChainableDegrees(angle) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)scaleX {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)scaleY {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainablePoint)scaleXY {
    JHChainablePoint chainable = JHChainablePoint(x, y) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeOpacity {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableColor)makeBackground {
    JHChainableColor chainable = JHChainableColor(color) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableColor)makeTint {
    JHChainableColor chainable = JHChainableColor(color) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableColor)makeBorderColor {
    JHChainableColor chainable = JHChainableColor(color) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeBorderWidth {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableFloat)makeCornerRadius {
    JHChainableFloat chainable = JHChainableFloat(f) {
        
        //implement
        
        return self;
    };
    return chainable;
}

// TODO: Anchor points!
//-(JHChainablePoint)anchor;

#pragma mark - Semantics

-(UIView *)then {
    
    //implement
    
    return self;
}

#pragma mark - Animations

-(UIView *)easeIn {
    
    //implement
    
    return self;
}

-(UIView *)easeOut {
    
    //implement
    
    return self;
}

-(UIView *)easeInOut {
    
    //implement
    
    return self;
}

-(JHChainableTimeInterval)delay {
    JHChainableTimeInterval chainable = JHChainableTimeInterval(t) {
      
        // implement
        
        return self;
    };
    return chainable;
}

-(JHChainableAnimation)animate {
    JHChainableAnimation chainable = JHChainableAnimation(duration) {
        
        //implement
        
        return self;
    };
    return chainable;
}

-(JHChainableAnimationWithCompletion)animateWithCompletion {
    JHChainableAnimationWithCompletion chainable = JHChainableAnimationWithCompletion(duration, completion) {
        
        //implement
        
        return self;
    };
    return chainable;
}

@end
