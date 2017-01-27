 //
//  JHKeyframeAnimation.m
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//
// Credits to https://github.com/NachoSoto/NSBKeyframeAnimation
// Credits to https://github.com/khanlou/SKBounceAnimation

#import "JHKeyframeAnimation.h"
#import "JHKeyframeAnimationFunctions.h"
#import <UIKit/UIKit.h>

#define kFPS 60

@interface JHKeyframeAnimation()

- (NSArray *)valueArrayForStartValue:(CGFloat)startValue endValue:(CGFloat)endValue;
- (void)createValueArray;
- (NSArray *)createRectArrayFromXValues:(NSArray *)xValues yValues:(NSArray *)yValues widths:(NSArray *)widths heights:(NSArray *)heights;
- (NSArray *)createPointArrayFromXValues:(NSArray *)xValues yValues:(NSArray *)yValues;
- (NSArray *)createSizeArrayFromWidths:(NSArray *)widths heights:(NSArray *)heights;
- (NSArray *)createColorArrayFromRed:(NSArray *)redValues green:(NSArray *)greenValues blue:(NSArray *)blueValues alpha:(NSArray *)alphaValues;
- (NSArray *)createTransformArrayFromM11:(NSArray *)m11 M12:(NSArray *)m12 M13:(NSArray *)m13 M14:(NSArray *)m14
                                     M21:(NSArray *)m21 M22:(NSArray *)m22 M23:(NSArray *)m23 M24:(NSArray *)m24
                                     M31:(NSArray *)m31 M32:(NSArray *)m32 M33:(NSArray *)m33 M34:(NSArray *)m34
                                     M41:(NSArray *)m41 M42:(NSArray *)m42 M43:(NSArray *)m43 M44:(NSArray *)m44;


@end

@implementation JHKeyframeAnimation

+ (instancetype)animationWithKeyPath:(NSString *)path
{
    JHKeyframeAnimation *animation = [super animationWithKeyPath:path];
    if (animation) {
        animation.functionBlock = ^double(double t, double b, double c, double d) {
            return JHKeyframeAnimationFunctionLinear(t, b, c, d);
        };
    }
    return animation;
}


- (id)copyWithZone:(nullable NSZone *)zone
{
    JHKeyframeAnimation *copy = [[JHKeyframeAnimation allocWithZone:zone] init];
    copy.functionBlock = [self.functionBlock copy];
    if ([self.fromValue isKindOfClass:NSObject.class] && [self.fromValue conformsToProtocol:@protocol(NSCopying)]) {
        NSObject<NSCopying> *fromValue = self.fromValue;
        copy.fromValue = [fromValue copy];
    }
    else {
        copy.fromValue = self.fromValue;
    }
    if ([self.toValue isKindOfClass:NSObject.class] && [self.toValue conformsToProtocol:@protocol(NSCopying)]) {
        NSObject<NSCopying> *toValue = self.toValue;
        copy.toValue = [toValue copy];
    }
    else {
        copy.toValue = self.toValue;
    }
    return copy;
}


- (void)calculate
{
    [self createValueArray];
}


- (void)createValueArray
{
    if (self.fromValue && self.toValue && self.duration) {
        if ([self.fromValue isKindOfClass:[NSNumber class]] && [self.toValue isKindOfClass:[NSNumber class]]) {
            self.values = [self valueArrayForStartValue:[self.fromValue floatValue] endValue:[self.toValue floatValue]];
        }
        else if ([self.fromValue isKindOfClass:[UIColor class]] && [self.toValue isKindOfClass:[UIColor class]]) {
            const CGFloat *fromComponents = CGColorGetComponents(((UIColor *)self.fromValue).CGColor);
            const CGFloat *toComponents = CGColorGetComponents(((UIColor *)self.toValue).CGColor);
            self.values = [self createColorArrayFromRed:
                           [self valueArrayForStartValue:fromComponents[0] endValue:toComponents[0]]
                                                  green:
                           [self valueArrayForStartValue:fromComponents[1] endValue:toComponents[1]]
                                                   blue:
                           [self valueArrayForStartValue:fromComponents[2] endValue:toComponents[2]]
                                                  alpha:
                           [self valueArrayForStartValue:fromComponents[3] endValue:toComponents[3]]];
        }
        else if ([self.fromValue isKindOfClass:[NSValue class]] && [self.toValue isKindOfClass:[NSValue class]]) {
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
                
            }
            else if ([valueType rangeOfString:@"CGPoint"].location == 1) {
                CGPoint fromPoint = [self.fromValue CGPointValue];
                CGPoint toPoint = [self.toValue CGPointValue];
                self.values = [self createPointArrayFromXValues:[self valueArrayForStartValue:fromPoint.x endValue:toPoint.x]
                                                        yValues:[self valueArrayForStartValue:fromPoint.y endValue:toPoint.y]];
            }
            else if ([valueType rangeOfString:@"CATransform3D"].location == 1) {
                CATransform3D fromTransform = [self.fromValue CATransform3DValue];
                CATransform3D toTransform = [self.toValue CATransform3DValue];
                
                self.values = [self createTransformArrayFromM11:
                               [self valueArrayForStartValue:fromTransform.m11 endValue:toTransform.m11]
                                                            M12:
                               [self valueArrayForStartValue:fromTransform.m12 endValue:toTransform.m12]
                                                            M13:
                               [self valueArrayForStartValue:fromTransform.m13 endValue:toTransform.m13]
                                                            M14:
                               [self valueArrayForStartValue:fromTransform.m14 endValue:toTransform.m14]
                                                            M21:
                               [self valueArrayForStartValue:fromTransform.m21 endValue:toTransform.m21]
                                                            M22:
                               [self valueArrayForStartValue:fromTransform.m22 endValue:toTransform.m22]
                                                            M23:
                               [self valueArrayForStartValue:fromTransform.m23 endValue:toTransform.m23]
                                                            M24:
                               [self valueArrayForStartValue:fromTransform.m24 endValue:toTransform.m24]
                                                            M31:
                               [self valueArrayForStartValue:fromTransform.m31 endValue:toTransform.m31]
                                                            M32:
                               [self valueArrayForStartValue:fromTransform.m32 endValue:toTransform.m32]
                                                            M33:
                               [self valueArrayForStartValue:fromTransform.m33 endValue:toTransform.m33]
                                                            M34:
                               [self valueArrayForStartValue:fromTransform.m34 endValue:toTransform.m34]
                                                            M41:
                               [self valueArrayForStartValue:fromTransform.m41 endValue:toTransform.m41]
                                                            M42:
                               [self valueArrayForStartValue:fromTransform.m42 endValue:toTransform.m42]
                                                            M43:
                               [self valueArrayForStartValue:fromTransform.m43 endValue:toTransform.m43]
                                                            M44:
                               [self valueArrayForStartValue:fromTransform.m44 endValue:toTransform.m44]
                               ];
            }
            else if ([valueType rangeOfString:@"CGSize"].location == 1) {
                CGSize fromSize = [self.fromValue CGSizeValue];
                CGSize toSize = [self.toValue CGSizeValue];
                self.values = [self createSizeArrayFromWidths:[self valueArrayForStartValue:fromSize.width endValue:toSize.width]
                                                     heights:[self valueArrayForStartValue:fromSize.height endValue:toSize.height]];
            }
            
        }
        self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
}

- (NSArray *)createRectArrayFromXValues:(NSArray *)xValues yValues:(NSArray *)yValues widths:(NSArray *)widths heights:(NSArray *)heights
{
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


- (NSArray *)createPointArrayFromXValues:(NSArray *)xValues yValues:(NSArray *)yValues
{
    NSAssert(xValues.count == yValues.count, @"array must have arrays of equal size");
    
    NSUInteger numberOfRects = xValues.count;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numberOfRects];
    
    for (NSInteger i = 1; i < numberOfRects; i++) {
        CGPoint value = CGPointMake(
                           [[xValues objectAtIndex:i] floatValue],
                           [[yValues objectAtIndex:i] floatValue]
                           );
        [values addObject:[NSValue valueWithCGPoint:value]];
    }
    return values;
}


- (NSArray *)createSizeArrayFromWidths:(NSArray *)widths heights:(NSArray *)heights
{
    NSAssert(widths.count == heights.count, @"array must have arrays of equal size");
    
    NSUInteger numberOfRects = widths.count;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numberOfRects];
    
    for (NSInteger i = 1; i < numberOfRects; i++) {
        CGSize value = CGSizeMake(
                           [[widths objectAtIndex:i] floatValue],
                           [[heights objectAtIndex:i] floatValue]
                           );
        [values addObject:[NSValue valueWithCGSize:value]];
    }
    return values;
}


- (NSArray *)createColorArrayFromRed:(NSArray*)redValues green:(NSArray*)greenValues blue:(NSArray*)blueValues alpha:(NSArray*)alphaValues
{
    NSAssert(redValues.count == blueValues.count && redValues.count == greenValues.count && redValues.count == alphaValues.count, @"arrays must have arrays of equal size");
    
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

- (NSArray *)valueArrayForStartValue:(CGFloat)startValue endValue:(CGFloat)endValue
{
    NSUInteger steps = ceil(kFPS * self.duration) + 2;
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

- (NSArray *)createTransformArrayFromM11:(NSArray *)m11 M12:(NSArray *)m12 M13:(NSArray *)m13 M14:(NSArray *)m14
                                     M21:(NSArray *)m21 M22:(NSArray *)m22 M23:(NSArray *)m23 M24:(NSArray *)m24
                                     M31:(NSArray *)m31 M32:(NSArray *)m32 M33:(NSArray *)m33 M34:(NSArray *)m34
                                     M41:(NSArray *)m41 M42:(NSArray *)m42 M43:(NSArray *)m43 M44:(NSArray *)m44
{
    NSUInteger numberOfTransforms = m11.count;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numberOfTransforms];
    CATransform3D value;
    
    for (NSInteger i = 1; i < numberOfTransforms; i++) {
        value = CATransform3DIdentity;
        value.m11 = [[m11 objectAtIndex:i] floatValue];
        value.m12 = [[m12 objectAtIndex:i] floatValue];
        value.m13 = [[m13 objectAtIndex:i] floatValue];
        value.m14 = [[m14 objectAtIndex:i] floatValue];
        
        value.m21 = [[m21 objectAtIndex:i] floatValue];
        value.m22 = [[m22 objectAtIndex:i] floatValue];
        value.m23 = [[m23 objectAtIndex:i] floatValue];
        value.m24 = [[m24 objectAtIndex:i] floatValue];
        
        value.m31 = [[m31 objectAtIndex:i] floatValue];
        value.m32 = [[m32 objectAtIndex:i] floatValue];
        value.m33 = [[m33 objectAtIndex:i] floatValue];
        value.m44 = [[m34 objectAtIndex:i] floatValue];
        
        value.m41 = [[m41 objectAtIndex:i] floatValue];
        value.m42 = [[m42 objectAtIndex:i] floatValue];
        value.m43 = [[m43 objectAtIndex:i] floatValue];
        value.m44 = [[m44 objectAtIndex:i] floatValue];
        
        [values addObject:[NSValue valueWithCATransform3D:value]];
    }
    return values;
}

@end
