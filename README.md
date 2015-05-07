#JHChainableAnimations
Easy to read and write chainable Animations in Objective-C

<table>
<tr>
<td width=75%">
<img src="./img/JHChainableAnimationsExample1.png" width="70%" ></img>
</td>
<td width=25%">
<img src="./Gifs/JHChainableAnimationsExample1.gif"></img>
</td>
</tr>
<tr>
<td width="75%">
<img src="./img/JHChainableAnimationsExample2.png" width="93%" ></img>
</td>
<td width="25%">
<img src="./Gifs/JHChainableAnimationsExample2.gif"></img>
</td>
</tr>
<tr>
<td width="75%">
<img src="./img/JHChainableAnimationsExample3.png" ></img>
</td>
<td width="25%">
<img src="./Gifs/JHChainableAnimationsExample3.gif" ></img>
</td>
</tr>
</table>

##Whats wrong with animations?

CAAnimations and UIView animations are extremely powerful, but it is difficult to chain multiple animations together, especially while changing anchor points. 

Furthermore, complicated animations are difficult to read. 

Say I want to move myView 50 pixels to the right with spring and then change the background color with inward easing when the movement has finished:

###The Old Way

```objective-c
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1.0
                        options:0 animations:^{
                            CGPoint newPosition = self.myView.frame.origin;
                            newPosition.x += 50;
                            self.myView.frame.origin = newPosition;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            self.myView.backgroundColor = [UIColor purpleColor];
        } completion:nil];
    }];
```

Thats pretty gross huh... With JHChainableAnimations it is one line of code. 

###The New Way (JHChainableAnimations!!!)

```objective-c
self.myView.moveX(50).spring.thenAfter(1.0).makeBackground([UIColor purpleColor]).easeIn.animate(0.5);
```

There are also a lot of really good animation libraries out there such as [RBBAnimation](https://github.com/robb/RBBAnimation), [DCAnimationKit](https://github.com/daltoniam/DCAnimationKit), and [PMTween](https://github.com/poetmountain/PMTween),  but they still fall short of having powerful chainable animations AND easy to read/write syntax. 

##Usage
Either clone the repo and manually add the Files in [JHChainableAnimations](./JHChainableAnimations) or add the following to your Podfile

```
pod 'JHChainableAnimations', '~> 1.0.2'
```
Then just import the following header.

```objective-c
#import "JHChainableAnimations.h"
```

This is all a UIView category, so these chainables can be used on any UIView in a file where the header is imported.

###Animating
Chainable properties like **moveX(x)** must come between the view and the **animate(t)** function

Below is an example of how to double an objects size over the course of one second. 

```objective-c
view.makeScale(2.0).animate(1.0);
```

If you want to move the view while you scale it, add another chainable property. Order is not important

```objective-c
view.makeScale(2.0).moveXY(100, 50).animate(1.0);
// the same as view.moveXY(100, 50).makeScale(2.0).animate(1.0);
```

A full list of chainable properties can be found [here](#chainables)

###Chaining Animations

To chain animations seperate the chains with the **thenAfter(t)** function.

Below is an example of how to scale and object for 0.5 seconds, and then move it for 1 second when that is done.

```objective-c
view.makeScale(2.0).thenAfter(0.5).moveXY(100, 50).animate(1.0);
```
###Animation Effects

To add an animation effect, call the effect method after the chainable property you want it to apply to.

Below is an example of scaling a view with a spring effect.

```objective-c
view.makeScale(2.0).spring.animate(1.0);
```

If you add 2 to the same chainable property the second will cancel the first out. 

```objective-c
view.makeScale(2.0).bounce.spring.animate(1.0);
// The same as view.makeScale(2.0).spring.animate(1.0);
```

A full list of animation effect properties can be found [here](#effects)

###Anchoring
To anchor your view call an achoring method at some point in an animation chain. Like effects, calling one after another in the same chain will cancel the first out. 

Below is an example of rotating a view around different anchor points

```objective-c
view.rotate(180).anchorTopLeft.thenAfter(1.0).rotate(90).anchorCenter.animate(1.0);

// view.rotate(90).anchorTopLeft.anchorCenter == view.rotate(90).anchorCenter
```

A full list of anchor properties can be found [here](#anchors)

###Delays
To delay an animation call the **wait(t)** or **delay(t)** chainable property.

Below is an example of moving a view after a delay of 0.5 seconds

```objective-c
view.moveXY(100, 50).wait(0.5).animate(1.0);
// The same as view.moveXY(100, 50).delay(0.5).animate(1.0);
```
###Completion
To run code after an animation finishese set the **animationCompletion** property of your UIView.

```objective-c
view.makeX(0).animateWithCompletion(1.0, JHAnimationCompletion(){
	NSLog(@"Animation Done");
});
```

Is the same as: 

```objective-c
view.animationCompletion = JHAnimationCompletion(){
	NSLog(@"Animation Done");
};
view.makeX(0).animate(1.0);
```

###Semantics
I included a chainable property called **seconds** that is there purely for show. It does however, make the code a little more readable (if you're into that sort of thing).

```objective-c
view.makeScale(2.0).thenAfter(0.5).seconds.moveX(20).animate(1.0);
// view.makeScale(2.0).thenAfter(0.5).moveX(20).animate(1.0);
```

##<a name="chainables"></a>ChainableProperties

<table>
<tr>
<th>
Property
</th>
<th>
Takes a...
</th>
<th>
Usage
</th>
</tr>
<tr>
<td>
- (JHChainableRect) makeFrame;
</td>
<td>
CGRect
</td>
<td>
view.makeFrame(rect).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableRect) makeBounds;
</td>
<td>
CGRect
</td>
<td>
view.makeBounds(rect).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableSize) makeSize;
</td>
<td>
(CGFloat: width, CGFloat: height)
</td>
<td>
view.makeSize(10, 20).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainablePoint) makeOrigin;
</td>
<td>
(CGFloat: x, CGFloat: y)
</td>
<td>
view.makeOrigin(10, 20).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainablePoint) makeCenter;
</td>
<td>
(CGFloat: x, CGFloat: y)
</td>
<td>
view.makeCenter(10, 20).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) makeX;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.makeX(10).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) makeY;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.makeY(10).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) makeWidth;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.makeWidth(10).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) makeHeight;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.makeHeight(10).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) makeOpacity;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.makeOpacity(10).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableColor) makeBackground;
</td>
<td>
(UIColor: color)
</td>
<td>
view.makeBackground(color).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableColor) makeBorderColor;
</td>
<td>
(UIColor: color)
</td>
<td>
view.makeBorderColor(color).animate(1.0);
</td></tr>
<tr>
<td>
- (JHChainableFloat) makeBorderWidth;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.makeBorderWidth(3.0).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) makeCornerRadius;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.makeCornerRadius(3.0).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) makeScale;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.makeScale(2.0).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) makeScaleX;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.makeScaleX(2.0).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) makeScaleY;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.makeScaleY(2.0).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainablePoint) makeAnchor;
</td>
<td>
(CGFloat: x, CGFloat: y)
</td>
<td>
view.makeAnchor(0.5, 0.5).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) moveX;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.moveX(50).animate(1.0)
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) moveY;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.moveY(50).animate(1.0)
</td>
</tr>
<tr>
<td>
- (JHChainablePoint) moveXY;
</td>
<td>
(CGFloat: x, CGFloat: y)
</td>
<td>
view.moveXY(100, 50).animate(1.0)
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) moveHeight;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.moveHeight(50).animate(1.0)
</td>
</tr>
<tr>
<td>
- (JHChainableFloat) moveWidth;
</td>
<td>
(CGFloat: f)
</td>
<td>
view.moveWidth(50).animate(1.0)
</td>
</tr>
<tr>
<td>
- (JHChainableDegrees) rotate;
</td>
<td>
(CGFloat: angle) #not radians!
</td>
<td>
view.rotate(360).animate(1.0);
</td>
</tr>
<tr>
<td>
- (JHChainablePolarCoordinate) movePolar;
</td>
<td>
(CGFloat: radius, CGFloat: angle)
</td>
<td>
view.movePolar(30, 90).animate(1.0);
</td>
</tr>
</table>

##<a name="effects"></a>Animation Effects

A quick look at these funcs can be found [here](http://easings.net/)

These animation functions were taken from a cool keyframe animation library that can be found [here](https://github.com/NachoSoto/NSBKeyframeAnimation)

They are based off of JQuery easing functions that can be found [here](http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js)

<img src="./img/JHChainableAnimationsEffects.png" width="35%">
<img src="./img/JHChainableAnimationsEasing.png" width="49%" height="500px">


##<a name="anchors"></a>Anchoring

Info on anchoring can be found [here](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/CoreAnimationBasics/CoreAnimationBasics.html#//apple_ref/doc/uid/TP40004514-CH2-SW3)

<img src="./img/JHChainableAnimationsAnchors.png" height="200px">


##Contact Info && Contributing

Feel free to email me at [jhurray33@gmail.com](mailto:jhurray33@gmail.com?subject=JHChainableAnimations). I'd love to hear your thoughts on this, or see examples where this has been used.

[MIT License](./LICENSE)



