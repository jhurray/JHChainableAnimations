//
//  ViewController.m
//  JHChainableAnimations tvOS Example
//
//  Created by Jeff Hurray on 12/26/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

#import "ViewController.h"
#import <JHChainableAnimations/JHChainableAnimations.h>


@interface ViewController ()

@property (nonatomic, weak) UIView *myView;
@property (nonatomic, weak) UIButton *pauseButton;
@property (nonatomic, strong) JHChainableAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(100, 150, 50, 50)];
    myView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:myView];
    self.myView = myView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.bounds.size.height-50.0, self.view.bounds.size.width, 50.0);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"Action!" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(animateView:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self.view addSubview:button];
    
    UIButton *pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pauseButton.frame = CGRectMake(16, 32, 200, 50);
    pauseButton.backgroundColor = [UIColor blueColor];
    [pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pause:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self.view addSubview:pauseButton];
    self.pauseButton = pauseButton;
    
    JHChainableAnimator *animator = [[JHChainableAnimator alloc] initWithView:self.myView];
    self.animator = animator;
}


- (void)pause:(UIButton *)sender
{
    if (!self.animator.isPaused) {
        [sender setTitle:@"Resume" forState:UIControlStateNormal];
        [self.animator pause];
    }
    else {
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
        [self.animator resume];
    }
}

- (void)animateView:(UIButton *)sender
{
    
    sender.userInteractionEnabled = NO;
    
    JHChainableAnimator *buttonAnimator = [[JHChainableAnimator alloc] initWithView:sender];
    
    __weak JHChainableAnimator *weakAnimator = self.animator;
    __weak UIView *weakView = self.myView;
    self.animator.completionBlock = ^{
        weakView.layer.transform = CATransform3DIdentity;
        weakView.frame = CGRectMake(100, 150, 50, 50);
        weakAnimator.transformIdentity.makeOpacity(1.0).makeBackground([UIColor blueColor]).animate(1.0);
        
        buttonAnimator.moveY(-50).easeInOutExpo.animateWithCompletion(1.1, ^{
            sender.userInteractionEnabled = YES;
        });
    };
    
    UIColor *purple = [UIColor purpleColor];
    self.animator.moveWidth(30).bounce.makeBackground(purple).easeIn.anchorTopLeft.
    repeat(0.5, 5).rotateZ(95).easeBack.wait(0.2).
    thenAfter(0.5).moveY(300).easeIn.makeOpacity(0.0).animate(0.4);
    
    buttonAnimator.moveY(50).easeInOutExpo.animate(0.5);
    
    
    /* OTHER COOL SHIT TO TRY: Animate on a bezier path  */
    //    UIBezierPath *path = [UIBezierPath bezierPath];
    //    [path moveToPoint:self.myView.center];
    //    [path addCurveToPoint:CGPointMake(250, 200) controlPoint1:CGPointMake(150, 100) controlPoint2:CGPointMake(200, 250)];
    //    [path addLineToPoint:CGPointMake(25, 400)];
    //    [path addLineToPoint:CGPointMake(300, 500)];
    //
    //    self.myView.moveOnPath(path).easeIn.rotate(360).bounce.animate(2.0);
    
    /* OTHER COOL SHIT TO TRY: Bounce around 4 corners  */
    //    self.myView.makeOrigin(0, 0).bounce.
    //        thenAfter(0.5).makeY(self.view.bounds.size.height-100).bounce.
    //        thenAfter(0.5).makeX(self.view.bounds.size.width-50).bounce.
    //        thenAfter(0.5).makeY(0).bounce.animate(0.5);
    
}

@end
