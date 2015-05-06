//
//  NSBKeyframeAnimationFunctions.h
//  NSBKeyframeAnimation
//
//  Created by Nacho Soto on 8/6/12.
//  Copyright (c) 2012 Nacho Soto. All rights reserved.
//

typedef double (*NSBKeyframeAnimationFunction)(double, double, double, double);

double NSBKeyframeAnimationFunctionLinear(double t,double b, double c, double d);

double NSBKeyframeAnimationFunctionEaseInQuad(double t,double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseOutQuad(double t,double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseInOutQuad(double t,double b, double c, double d);

double NSBKeyframeAnimationFunctionEaseInCubic(double t,double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseOutCubic(double t,double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseInOutCubic(double t, double b, double c, double d);

double NSBKeyframeAnimationFunctionEaseInQuart(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseOutQuart(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseInOutQuart(double t, double b, double c, double d);

double NSBKeyframeAnimationFunctionEaseInQuint(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseOutQuint(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseInOutQuint(double t, double b, double c, double d);

double NSBKeyframeAnimationFunctionEaseInSine(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseOutSine(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseInOutSine(double t, double b, double c, double d);

double NSBKeyframeAnimationFunctionEaseInExpo(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseOutExpo(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseInOutExpo(double t, double b, double c, double d);

double NSBKeyframeAnimationFunctionEaseInCirc(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseOutCirc(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseInOutCirc(double t, double b, double c, double d);

double NSBKeyframeAnimationFunctionEaseInElastic(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseOutElastic(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseInOutElastic(double t, double b, double c, double d);

double NSBKeyframeAnimationFunctionEaseInBack(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseOutBack(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseInOutBack(double t, double b, double c, double d);

double NSBKeyframeAnimationFunctionEaseInBounce(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseOutBounce(double t, double b, double c, double d);
double NSBKeyframeAnimationFunctionEaseInOutBounce(double t, double b, double c, double d);
