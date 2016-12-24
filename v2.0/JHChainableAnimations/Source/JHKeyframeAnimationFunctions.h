//
//  JHKeyframeAnimationFunctions.h
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

typedef double (*JHKeyframeAnimationFunction)(double, double, double, double);

double JHKeyframeAnimationFunctionLinear(double t,double b, double c, double d);

double JHKeyframeAnimationFunctionEaseInQuad(double t,double b, double c, double d);
double JHKeyframeAnimationFunctionEaseOutQuad(double t,double b, double c, double d);
double JHKeyframeAnimationFunctionEaseInOutQuad(double t,double b, double c, double d);

double JHKeyframeAnimationFunctionEaseInCubic(double t,double b, double c, double d);
double JHKeyframeAnimationFunctionEaseOutCubic(double t,double b, double c, double d);
double JHKeyframeAnimationFunctionEaseInOutCubic(double t, double b, double c, double d);

double JHKeyframeAnimationFunctionEaseInQuart(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseOutQuart(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseInOutQuart(double t, double b, double c, double d);

double JHKeyframeAnimationFunctionEaseInQuint(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseOutQuint(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseInOutQuint(double t, double b, double c, double d);

double JHKeyframeAnimationFunctionEaseInSine(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseOutSine(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseInOutSine(double t, double b, double c, double d);

double JHKeyframeAnimationFunctionEaseInExpo(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseOutExpo(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseInOutExpo(double t, double b, double c, double d);

double JHKeyframeAnimationFunctionEaseInCirc(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseOutCirc(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseInOutCirc(double t, double b, double c, double d);

double JHKeyframeAnimationFunctionEaseInElastic(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseOutElastic(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseInOutElastic(double t, double b, double c, double d);

double JHKeyframeAnimationFunctionEaseInBack(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseOutBack(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseInOutBack(double t, double b, double c, double d);

double JHKeyframeAnimationFunctionEaseInBounce(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseOutBounce(double t, double b, double c, double d);
double JHKeyframeAnimationFunctionEaseInOutBounce(double t, double b, double c, double d);
