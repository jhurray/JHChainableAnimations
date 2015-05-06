//
//  JHKeyframeAnimation.m
//  JHAnimationKitExample
//
//  Created by Jeff Hurray on 5/5/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

@import UIKit;
#import "JHKeyframeAnimation.h"

#define kFPS 60

@interface JHKeyframeAnimation()

// From https://github.com/NachoSoto/NSBKeyframeAnimation
- (NSArray*) valueArrayForStartValue:(CGFloat)startValue endValue:(CGFloat)endValue;


// From https://github.com/khanlou/SKBounceAnimation
- (void) createValueArray;
- (NSArray*) createRectArrayFromXValues:(NSArray*)xValues yValues:(NSArray*)yValues widths:(NSArray*)widths heights:(NSArray*)heights;
static CGPathRef createPathFromXYValues(NSArray *xValues, NSArray *yValues);
- (NSArray*) createColorArrayFromRed:(NSArray*)redValues green:(NSArray*)greenValues blue:(NSArray*)blueValues alpha:(NSArray*)alphaValues;

@end

@implementation JHKeyframeAnimation

+ (instancetype) animationWithKeyPath:(NSString *)path {
    JHKeyframeAnimation *animation = [super animationWithKeyPath:path];
    if (animation) {
        animation.functionBlock = ^double(double t, double b, double c, double d) {
            return NSBKeyframeAnimationFunctionLinear(t, b, c, d);
        };
    }
    return animation;
}

-(void) calculate {
    [self createValueArray];
}

- (void) createValueArray {
    if (self.fromValue && self.toValue && self.duration) {
        if ([self.fromValue isKindOfClass:[NSNumber class]] && [self.toValue isKindOfClass:[NSNumber class]]) {
            self.values = [self valueArrayForStartValue:[self.fromValue floatValue] endValue:[self.toValue floatValue]];
        } else if ([self.fromValue isKindOfClass:[UIColor class]] && [self.toValue isKindOfClass:[UIColor class]]) {
            const CGFloat *fromComponents = CGColorGetComponents(((UIColor*)self.fromValue).CGColor);
            const CGFloat *toComponents = CGColorGetComponents(((UIColor*)self.toValue).CGColor);
            //			NSLog(@"from %0.2f %0.2f %0.2f %0.2f", fromComponents[0], fromComponents[1], fromComponents[2], fromComponents[3]);
            //			NSLog(@"to %0.2f %0.2f %0.2f %0.2f", toComponents[0], toComponents[1], toComponents[2], toComponents[3]);
            self.values = [self createColorArrayFromRed:
                           [self valueArrayForStartValue:fromComponents[0] endValue:toComponents[0]]
                                                  green:
                           [self valueArrayForStartValue:fromComponents[1] endValue:toComponents[1]]
                                                   blue:
                           [self valueArrayForStartValue:fromComponents[2] endValue:toComponents[2]]
                                                  alpha:
                           [self valueArrayForStartValue:fromComponents[3] endValue:toComponents[3]]];
        } else if ([self.fromValue isKindOfClass:[NSValue class]] && [self.toValue isKindOfClass:[NSValue class]]) {
            NSString *valueType = [NSString stringWithCString:[self.fromValue objCType] encoding:NSStringEncodingConversionAllowLossy];
            if ([valueType rangeOfString:@"CGRect"].location == 1) {
                CGRect fromRect = [self.fromValue CGRectValue];
                CGRect toRect = [self.toValue CGRectValue];
                self.values = [self createRectArrayFromXValues:
                               [self valueArrayForStartValue:fromRect.origin.x endValue:toRect.origin.x]
                                                       yValues:
                               [self valueArrayForStartValue:fromRect.origin.y endValue:toRect.origin.y]
                                                        widths:
                               [self valueArrayForStartValue:fromRect.size.width endValue:toRect.size.width]
                                                       heights:
                               [self valueArrayForStartValue:fromRect.size.height endValue:toRect.size.height]];
                
            } else if ([valueType rangeOfString:@"CGPoint"].location == 1) {
                CGPoint fromPoint = [self.fromValue CGPointValue];
                CGPoint toPoint = [self.toValue CGPointValue];
                CGPathRef path = createPathFromXYValues([self valueArrayForStartValue:fromPoint.x endValue:toPoint.x], [self valueArrayForStartValue:fromPoint.y endValue:toPoint.y]);
                self.path = path;
                CGPathRelease(path);
                
            } else if ([valueType rangeOfString:@"CGSize"].location == 1) {
                CGSize fromSize = [self.fromValue CGSizeValue];
                CGSize toSize = [self.toValue CGSizeValue];
                CGPathRef path = createPathFromXYValues(
                                                        [self valueArrayForStartValue:fromSize.width endValue:toSize.width],
                                                        [self valueArrayForStartValue:fromSize.height endValue:toSize.height]
                                                        );
                self.path = path;
                CGPathRelease(path);
            }
            
        }
        self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
}

- (NSArray*) createRectArrayFromXValues:(NSArray*)xValues yValues:(NSArray*)yValues widths:(NSArray*)widths heights:(NSArray*)heights {
    NSAssert(xValues.count == yValues.count && xValues.count == widths.count && xValues.count == heights.count, @"array must have arrays of equal size");
    
    NSUInteger numberOfRects = xValues.count;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numberOfRects];
    CGRect value;
    
    for (NSInteger i = 1; i < numberOfRects; i++) {
        value = CGRectMake(
                           [[xValues objectAtIndex:i] floatValue],
                           [[yValues objectAtIndex:i] floatValue],
                           [[widths objectAtIndex:i] floatValue],
                           [[heights objectAtIndex:i] floatValue]
                           );
        [values addObject:[NSValue valueWithCGRect:value]];
    }
    return values;
}

static CGPathRef createPathFromXYValues(NSArray *xValues, NSArray *yValues) {
    NSUInteger numberOfPoints = xValues.count;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint value;
    value = CGPointMake([[xValues objectAtIndex:0] floatValue], [[yValues objectAtIndex:0] floatValue]);
    CGPathMoveToPoint(path, NULL, value.x, value.y);
    
    for (NSInteger i = 1; i < numberOfPoints; i++) {
        value = CGPointMake([[xValues objectAtIndex:i] floatValue], [[yValues objectAtIndex:i] floatValue]);
        CGPathAddLineToPoint(path, NULL, value.x, value.y);
    }
    return path;
}



- (NSArray*) createColorArrayFromRed:(NSArray*)redValues green:(NSArray*)greenValues blue:(NSArray*)blueValues alpha:(NSArray*)alphaValues {
    NSAssert(redValues.count == blueValues.count && redValues.count == greenValues.count && redValues.count == alphaValues.count, @"array must have arrays of equal size");
    
    NSUInteger numberOfColors = redValues.count;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numberOfColors];
    UIColor *value;
    
    for (NSInteger i = 1; i < numberOfColors; i++) {
        value = [UIColor colorWithRed:[[redValues objectAtIndex:i] floatValue]
                                green:[[greenValues objectAtIndex:i] floatValue]
                                 blue:[[blueValues objectAtIndex:i] floatValue]
                                alpha:[[alphaValues objectAtIndex:i] floatValue]];
        [values addObject:(id)value.CGColor];
    }
    return values;
}

- (NSArray*) valueArrayForStartValue:(CGFloat)startValue endValue:(CGFloat)endValue {
    NSUInteger steps = (NSUInteger)ceil(kFPS * self.duration) + 2;
    
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:steps];
    
    const double increment = 1.0 / (double)(steps - 1);
    
    double progress = 0.0,
    v = 0.0,
    value = 0.0;
    
    NSUInteger i;
    for (i = 0; i < steps; i++)
    {
        v = self.functionBlock(self.duration * progress * 1000, 0, 1, self.duration * 1000);
        value = startValue + v * (endValue - startValue);
        
        [valueArray addObject:@(value)];
        
        progress += increment;
    }
    
    return [NSArray arrayWithArray:valueArray];
}

@end
